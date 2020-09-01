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
        $docImg = Storage::disk('s3')->put('images/shop/doc_img', $request->file('document_img'), 'public');
        $req['cover_img'] = $pathImg;
        $req['document_img'] = $docImg;
        $req['approved'] = false;
        $shop = $this->shopRepo->create($req);
        return response()->json(['data' => $shop, 'msg' => 'Create shop success', 'status' => 200]);
    }

    public function approved(Request $request, $shopId)
    {
        $req = $request->except(['_method' ]);
        $this->shopRepo->updateShop($req, $shopId);
        $shop = $this->shopRepo->findById($shopId);
        if(!$shop) {
            return response()->json(['data' => $shop, 'msg' => 'Shop not found', 'status' => 404]);
        }
        return response()->json(['data' => $shop, 'msg' => 'Approved Success', 'status' => 200]);
    }

    public function rejected($shopId)
    {
        $shop = $this->shopRepo->delete($shopId);
        return response()->json(['data' => $shop, 'msg' => 'Rejected Success', 'status'=> 200]);
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

    public function addMenu(CreateFoodRequest $request, $shopId)
    {
        $req = $request->validated();
        $pathImg = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
        $req['cover_img'] = $pathImg;
        $menu = $this->foodRepo->addMenuByShopId($req, $shopId);
        return response()->json(['data' => $menu, 'msg' => 'Add Menu Success', 'status' => 200]);
    }

    public function update(UpdateShopRequest $request, $shopId)
    {
        $shop = $this->shopRepo->findById($shopId);
        if(!$shop) {
            return response()->json(['data' => $shop, 'msg' => 'Shop Not Found', 'status' => 404]);
        } else {
            $req = $request->validated();
            if(!isset($req['cover_img'])){
                $this->shopRepo->updateShop($req, $shopId);
                $res = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $res, 'msg' => 'Updated Success', 'status' => 200]);
            } else {
                $oldPath = $shop['cover_img'];
                Storage::disk('s3')->delete($oldPath);
                $newPath = Storage::disk('s3')->put('images/shop/cover_img', $request->file('cover_img'), 'public');
                $req['cover_img'] = $newPath;
                $this->shopRepo->updateShop($req, $shopId);
                $res = $this->shopRepo->findById($shopId);
                return response()->json(['data' => $res, 'msg' => 'Updated With Image Success', 'status' => 200]);
            }
        }
    }
}
