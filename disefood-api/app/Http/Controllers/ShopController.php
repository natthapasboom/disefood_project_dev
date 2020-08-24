<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\ShopRepositoryInterface;
use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\CreateShopRequest;
use App\Http\Requests\CreateFoodRequest;
use App\Http\Requests\UpdateShopRequest;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

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

    public function create(CreateShopRequest $request)
    {
        $req = $request->validated();
        $pathImg = Storage::disk('s3')->put('images/shop/cover_img', $request->file('cover_img'),'public');
        $req['cover_img'] = $pathImg;
        $req['approved'] = false;
        $shop = $this->shopRepo->create($req);
        return response()->json(['data' => $shop, 'msg' => 'Create shop success', 'status' => 200]);
    }

    public function approved(Request $request, $shopId)
    {
        $req = $request->except(['_method' ]);
        $this->shopRepo->updateShop($req, $shopId);
        $shop = $this->shopRepo->findById($shopId);
        return response()->json([ 'data' => $shop, 'msg' => 'Approved Success', 'status' => 200]);
    }

    public function getMenuByShopId($shopId)
    {
        $foods = $this->shopRepo->findMenuByShopId($shopId);
        if(!$foods){
            return  response()->json(['data' => $foods, 'msg' => 'Menu or Shop not found', 'status' => 404]);
        } else {
            return  response()->json(['data' => $foods, 'status' => 200]);
        }
    }

    public function addMenu(CreateFoodRequest $request, $shopId)
    {
        $req = $request->validated();
        $pathImg = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
        $req['cover_img'] = $pathImg;
        $menu = $this->foodRepo->addMenuByShopId($req, $shopId);
        return response()->json(['data' => $menu, 'msg' => 'Add menu success', 'status' => 200]);
    }

    public function update(UpdateShopRequest $request, $shopId)
    {
        $shop = $this->shopRepo->findById($shopId);
        if(!$shop) {
            return response()->json(['data' => $shop, 'msg' => 'Shop not found', 'status' => 404]);
        } else {
            $req = $request->validated();
            if(!$req['cover_img']){
                dd(1);
                $this->shopRepo->updateShop($req, $shopId);
                $res = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $res, 'msg' => 'Updated success', 'status' => 200]);
            } else {
                $oldPath = $shop['cover_img'];
                Storage::disk('s3')->delete($oldPath);
                $newPath = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
                $req['cover_img'] = $newPath;
                $this->shopRepo->updateShop($req, $shopId);
                $res = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $res, 'msg' => 'Updated with image success', 'status' => 200]);
            }
        }


    }

//    public function getShopByUserId($user_id)
//    {
//        $shop = $this->shopRepo->getShopByUserId($user_id);
//        if($shop == null)
//        {
//            return response('shop not found', 404);
//        }else{
//            return $shop;
//        }
//    }
//    public function addFoodToShop(CreateFoodRequest $request, $shop_id)
//    {
//        $food = $request->validated();
////        $path = Storage::disk('s3')->put('images/shop/food/cover_image', $request->file('cover_image'), 'public');
////        $food['cover_image'] = $path;
//        $food['cover_image'] = null;
//        return $this->foodRepo->addFood($food, $shop_id);
//    }
//    public function updateShop(Request $request, $shop_id)
//    {
//        $shop = $request->except(['_method' ]);
////        $shop_beforeUpdate = $this->shopRepo->findById($shop_id);
////        $path_beforeUpdate = $shop_beforeUpdate['cover_image'];
////        Storage::disk('s3')->delete($path_beforeUpdate);
////        $shop['cover_image'] = Storage::disk('s3')->put('images/shop/cover_image', $request->file('cover_image'), 'public');
//
//        $this->shopRepo->updateShop($shop, $shop_id);
//        return $this->shopRepo->findById($shop_id);
//    }
//    public function deleteByShopId($shop_id)
//    {
//        $shopBeforeDelete = $this->shopRepo->findById($shop_id);
//        $path = $shopBeforeDelete['cover_image'];
//        Storage::disk('s3')->delete($path);
//        $this->shopRepo->delete($shop_id);
//        return response('delete success', 200);
//    }
}
