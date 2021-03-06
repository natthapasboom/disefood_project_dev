<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateAccountNumberRequest;
use App\Http\Requests\UpdateAccountNumberInShopRequest;
use App\Http\Requests\UpdateFoodInShop;
use App\Repositories\Interfaces\AccountNumberRepositoryInterface;
use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Repositories\Interfaces\ShopRepositoryInterface;
use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\CreateShopRequest;
use App\Http\Requests\CreateFoodRequest;
use App\Http\Requests\UpdateShopRequest;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use function Aws\boolean_value;

class ShopController extends Controller
{
    private $shopRepo;
    private $foodRepo;
    private $accNumberRepo;
    private $orderRepo;

    public function __construct
    (
        ShopRepositoryInterface $shopRepo,
        FoodRepositoryInterface $foodRepo,
        AccountNumberRepositoryInterface $accNumber,
        OrderRepositoryInterface $orderRepo
    )
    {
        $this->shopRepo = $shopRepo;
        $this->foodRepo = $foodRepo;
        $this->accNumberRepo = $accNumber;
        $this->orderRepo = $orderRepo;
    }

    public function getShopsList()
    {
        $shops = $this->shopRepo->getAll();
        foreach ($shops as $shop) {
            $feedbacks = $shop->feedbacks;
            $sumOfRating = 0;
            $shop["averageRating"] = 0;
            foreach ($feedbacks as $feedback) {
                $rating = $feedback->rating;
                $sumOfRating += $rating;
                $shop["averageRating"] = $sumOfRating / count($feedbacks);
            }
        }
        return response()->json(['data' => $shops, 'msg' => 'Get shop lists success', 'status' => 200]);
    }

    public function findShopById($shopId)
    {
        $shop = $this->shopRepo->findById($shopId);
        $shop->accountNumbers;
        if(!$shop) {
            return response()->json(['msg' => 'Shop not found', 'status' => 404]);
        } else {
            return  response()->json(['data' => $shop, 'status' => 200]);
        }
    }

    public function getMenuByShopId($shopId)
    {
        $shop = $this->shopRepo->findMenuByShopId($shopId);
        if(!$shop) {
            return response()->json(['msg' => 'shop not found', 'status' => 404]);
        } else {
            $menus = $shop->foods;
            if(count($menus) == 0) {
                return response()->json(['msg' => 'this shop dont have any menu', 'status' => 404]);
            } else {
                return  response()->json(['data' => $menus, 'status' => 200]);
            }
        }
    }

    public function search(Request $request) {
        try {
            if($request->has('name')) {
                $data = $request->name;
                $shops = $this->shopRepo->search($data);
            } elseif ($request->has('approved')) {
                $data = boolean_value($request->approved);
                $shops = $this->shopRepo->search($data);
            }
            $countShops = count($shops);
            if($countShops == 0) {
                return response()->json(['msg' => 'Shop Not found'], 404);
            }

            foreach ($shops as $shop) {
                $feedbacks = $shop->feedbacks;
                $sumOfRating = 0;
                $shop["averageRating"] = 0;
                foreach ($feedbacks as $feedback) {
                    $rating = $feedback->rating;
                    $sumOfRating += $rating;
                    $shop["averageRating"] = $sumOfRating / count($feedbacks);
                }
                $shop->makeHidden('feedbacks');
            }
            return response()->json(['data' => $shops], 200);
        } catch (\Throwable $error) {
            report($error);
        }
    }

    //    admin
    public function approved(Request $request, $shopId)
    {
        $admin = $this->isAdmin();
        if($admin) {
            $req = $request->except(['_method' ]);
            $shop = $this->shopRepo->findById($shopId);
            if(!$shop) {
                return response()->json(['msg' => 'Shop not found'], 404);
            } else {
                $this->shopRepo->updateShop($req, $shopId);
                $shop = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $shop, 'msg' => 'Approved Success'], 200);
            }
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

//    admin
    public function rejected($shopId)
    {
        $admin = $this->isAdmin();
        if($admin) {
            $shop = $this->shopRepo->findById($shopId);
            if(!$shop) {
                return response()->json(['msg' => 'Shop not found'], 404);
            } else {
                $shop = $this->shopRepo->delete($shopId);
                return response()->json(['data' => $shop, 'msg' => 'Rejected Success'], 200);
            }
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

//    seller
    public function getShopByOwner()
    {
        $user = Auth::user();
        $userId = $user['id'];
        $shop = $this->shopRepo->getBySellerId($userId);
        if(!$shop) return response()->json(['msg' => 'Shop Not Found'], 404);

        if(!boolean_value($shop['approved'])) return response()->json(['data' => $shop, 'msg' => 'Waiting for Approved']);

        return response()->json(['data' => $shop], 200);
    }

//    seller
    public function create(CreateShopRequest $request)
    {
        $seller = $this->isSeller();
        if($seller){
            $req = $request->validated();

            if(!$req) response()->json(['msg' => 'Failed Validation'], 422);

            $pathImg = Storage::disk('s3')->put('images/shop/cover_img', $request->file('cover_img'),'public');
            $req['cover_img'] = $pathImg;
            $req['approved'] = false;
            $req['user_id'] = $seller['id'];
            $shop = $this->shopRepo->create($req);
            return response()->json(['data' => $shop, 'msg' => 'Create shop success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }

    }

//    seller
    public function update(UpdateShopRequest $request, $shopId)
    {
        $seller = $this->isSeller();
        $isOwner = $this->isOwner($seller->id, $shopId);
        if($isOwner){
            $shop = $this->shopRepo->findById($shopId);

            if(!$shop) response()->json(['msg' => 'Shop Not Found'], 404);

            if($request->cover_img != null) {
                $req = $request->validated();

                if(!$req) response()->json(['msg' => 'Failed Validation'], 422);

                $oldPath = $shop['cover_img'];
                Storage::disk('s3')->delete($oldPath);
                $newPath = Storage::disk('s3')->put('images/shop/cover_img', $request->file('cover_img'), 'public');
                $req['cover_img'] = $newPath;
                $this->shopRepo->updateShop($req, $shopId);
                $newShop = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $newShop, 'msg' => 'Updated With Image Success'], 200);
            } else {
                $req = $request->except(['_method']);
                $this->shopRepo->updateShop($req, $shopId);
                $newShop = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $newShop, 'msg' => 'Updated Success'], 200);
            }
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

//    seller
    public function addMenu(CreateFoodRequest $request, $shopId)
    {
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            $req = $request->validated();

            if(!$req) response()->json(['msg' => 'Failed Validation'], 422);

            $pathImg = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
            $req['cover_img'] = $pathImg;
            $menu = $this->foodRepo->addMenuByShopId($req, $shopId);
            return response()->json(['data' => $menu, 'msg' => 'Add Menu Success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    public function updateMenuByFoodId(UpdateFoodInShop $request, $foodId)
    {
        $food = $this->foodRepo->findByFoodId($foodId);
        $shopId = $food['shop_id'];
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            if(!$food) response()->json(['msg' => 'Food not found'], 404);

            if($request->cover_img != null) {
                $req = $request->validated();

                if(!$req) response()->json(['msg' => 'Failed Validation'], 422);

                $oldPath = $food['cover_img'];
                Storage::disk('s3')->delete($oldPath);
                $newPath = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
                $req['cover_img'] = $newPath;
                $this->foodRepo->update($req, $foodId);
                $newFood = $this->foodRepo->findByFoodId($foodId);
                return response()->json(['data' => $newFood, 'msg' => 'Updated with Image Success']);
            } else {
                $req = $request->except(['_method']);
                $this->foodRepo->update($req, $foodId);
                $newFood = $this->foodRepo->findByFoodId($foodId);
                return response()->json(['data' => $newFood, 'msg' => 'Updated Success'], 200);
            }
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    public function deleteMenuByFoodId($foodId)
    {
        $food = $this->foodRepo->findByFoodId($foodId);
        $shopId = $food['shop_id'];
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            if(!$food) {
                return response()->json(['data' => $food, 'msg' => 'Food Not Found'], 404);
            } else {
                $oldPath = $food['cover_img'];
                Storage::disk('s3')->delete($oldPath);
                $food = $this->foodRepo->delete($foodId);
                return response()->json(['data' => $food, 'msg' => 'Remove Food Success'], 200);
            }
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    public function getAccountNumbers()
    {
        return $this->accNumberRepo->getAll();
    }

    public function getAccountNumberByShopId($shopId)
    {
        $accNumbers = $this->accNumberRepo->getByShopId($shopId);
        return response()->json(['data' => $accNumbers], 200);
    }

    public function addAccountNumber(CreateAccountNumberRequest $request, $shopId)
    {
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            $req = $request->validated();
            $accountNumber = $this->accNumberRepo->create($req, $shopId);
            return response()->json(['data' => $accountNumber, 'msg' => 'Add account number success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    public function updateAccountNumberById(UpdateAccountNumberInShopRequest $request, $accNumberId)
    {
        $accNumber = $this->accNumberRepo->getById($accNumberId);
        $shopId = $accNumber['shop_id'];
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            $req = $request->validated();

            if(!$req) return response()->json(['msg' => 'Failed Validation'], 422);

            $this->accNumberRepo->updateById($req, $accNumberId);
            $newAccNumber = $this->accNumberRepo->getById($accNumberId);
            return response()->json(['data' => $newAccNumber, 'msg' => 'Updated Success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    public function deleteById($accNumberId)
    {
        $accNumber = $this->accNumberRepo->getById($accNumberId);
        $shopId = $accNumber['shop_id'];
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            $accNumber = $this->accNumberRepo->delete($accNumberId);
            return response()->json(['data' => $accNumber, 'msg' => 'Remove Success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }

    }

    public function dataSummary($shopId)
    {
        $user = Auth::user();
        $userId = $user['id'];

        if (!$this->isOwner($userId, $shopId)) {
            return response()->json(['msg' => 'No Permission'], 401);
        }

        $shop = $this->shopRepo->findById($shopId);
        $foods = $shop->foods;
        foreach ($foods as $food) {
            $food['totalQuantity'] = 0;
            $food['totalAmount'] = 0;
            $orderDetails = $food->orderDetails;
            $foods->makeHidden('orderDetails');

            foreach ($orderDetails as $orderDetail) {
                $order = $orderDetail->order;
                if($order->status === 'success' || $order->status === 'in process') {
                    $food['totalQuantity'] += $orderDetail->quantity;
                    $food['totalAmount'] += $orderDetail->price;
                    $shop['totalAmountShop'] += $orderDetail->price;
                    $shop['totalQuantityShop'] += $orderDetail->quantity;
                }
            }
        }

        $data = $foods->sortByDesc('totalAmount')->take(10)->values()->all();
        $totalQuantityShop = $shop['totalQuantityShop'];
        $totalAmountShop = $shop['totalAmountShop'];

        return response()->json(['data' => $data, 'totalQuantityShop' => $totalQuantityShop, 'totalAmountShop' => $totalAmountShop], 200);
    }

    private function isSeller()
    {
        $user = Auth::user();
        $role = $user['role'];
        if($role == 'seller')
            return $user;
    }

    private function isAdmin()
    {
        $user = Auth::user();
        $role = $user['role'];
        if($role == 'admin')
            return $user;
    }

    private function isOwner($userId, $shopId)
    {
        $isOwner = null;
        $shop = $this->shopRepo->findById($shopId);
        if( $shop['user_id'] == $userId ){
            $isOwner = true;
        } else {
            $isOwner = false;
        }
        return $isOwner;
    }
}
