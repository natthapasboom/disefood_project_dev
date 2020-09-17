<?php

namespace App\Http\Controllers;

use App\Http\Requests\UpdateFoodInShop;
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

    public function __construct
    (
        ShopRepositoryInterface $shopRepo,
        FoodRepositoryInterface $foodRepo
    )
    {
        $this->shopRepo = $shopRepo;
        $this->foodRepo = $foodRepo;
    }

    public function getShopsList()
    {
        $shops = $this->shopRepo->getAll();
        return response()->json(['data' => $shops, 'msg' => 'Get shop lists success', 'status' => 200]);
    }

    public function findShopById($shopId)
    {
        $shop = $this->shopRepo->findById($shopId);
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

        if(!boolean_value($shop['approved'])) return response()->json(['msg' => 'Waiting for Approved']);

        return response()->json(['data' => $shop], 200);
    }

//    seller
    public function create(CreateShopRequest $request)
    {
        $seller = $this->isSeller();
        if($seller){
            $req = $request->validated();
            $pathImg = Storage::disk('s3')->put('images/shop/cover_img', $request->file('cover_img'),'public');
            $docImg = Storage::disk('s3')->put('images/shop/doc_img', $request->file('document_img'), 'public');
            $req['cover_img'] = $pathImg;
            $req['document_img'] = $docImg;
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
        if($seller){
            $shop = $this->shopRepo->findById($shopId);
            if(!$shop) {
                return response()->json(['msg' => 'Shop Not Found'], 404);
            }
            else {
                $req = $request->validated();
                if(!isset($req['cover_img'])){
                    $this->shopRepo->updateShop($req, $shopId);
                    $res = $this->shopRepo->findById($shopId);
                    return response()->json(['data' => $res, 'msg' => 'Updated Success'], 200);
                } else {
                    $oldPath = $shop['cover_img'];
                    Storage::disk('s3')->delete($oldPath);
                    $newPath = Storage::disk('s3')->put('images/shop/cover_img', $request->file('cover_img'), 'public');
                    $req['cover_img'] = $newPath;
                    $this->shopRepo->updateShop($req, $shopId);
                    $res = $this->shopRepo->findById($shopId);
                    return response()->json(['data' => $res, 'msg' => 'Updated With Image Success'], 200);
                }
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
        if($this->isOwner($sellerId, $shopId)) {
            $req = $request->validated();
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
        if($this->isOwner($sellerId, $shopId)) {
            if(!$food) {
                return response()->json(['data' => $food, 'msg' => 'Food Not Found'], 404);
            } else {
                $req = $request->validated();
                if(!isset($req['cover_img'])) {
                    $this->foodRepo->update($req, $foodId);
                    $food = $this->foodRepo->findByFoodId($foodId);
                    return response()->json(['data' => $food, 'msg' => 'Updated Success'], 200);
                } else {
                    $oldPath = $food['cover_img'];
                    Storage::disk('s3')->delete($oldPath);
                    $newPath = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
                    $req['cover_img'] = $newPath;
                    $this->foodRepo->update($req, $foodId);
                    $food = $this->foodRepo->findByFoodId($foodId);
                    return response()->json(['data' => $food, 'msg' => 'Updated with Image Success']);
                }
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
        if($this->isOwner($sellerId, $shopId)) {
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
        $shop = $this->shopRepo->findById($shopId);
        if( $shop['user_id'] == $userId )
            return true;
    }
}
