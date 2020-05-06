<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\ShopRepositoryInterface;
use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\CreateShopRequest;
use App\Http\Requests\CreateFoodRequest;
use App\Http\Requests\UpdateShopRequest;
use Illuminate\Support\Facades\Storage;

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
        return $this->shopRepo->get();
    }

    public function findShopById($shop_id)
    {
        $shop = $this->shopRepo->findById($shop_id);
        if($shop == null) {
            return response()->json(['error' => 'Shop not found'], 404);
        }
        return $shop;
    }

    public function create(CreateShopRequest $request)
    {
        $shop = $request->validated();
        $path = Storage::disk('s3')->put('images/shop/cover_image', $request->file('cover_image'));
        $shop['cover_image'] = $path;
        return $this->shopRepo->create($shop);
    }

    public function addFoodToShop(CreateFoodRequest $request, $shop_id)
    {
        $food = $request->validated();
        $path = Storage::disk('s3')->put('images/shop/food/cover_image', $request->file('cover_image'));
        $food['cover_image'] = $path;
        return $this->foodRepo->addFood($food, $shop_id);
    }

    public function updateShop(UpdateShopRequest $request, $shop_id)
    {
        $shop = $request->validated();
//        $shopBeforeUpdate = $this->shopRepo->findById($shop_id);
//        Storage::delete($shopBeforeUpdate['cover_image']);
//        $shop['cover_image'] = Storage::disk('s3')->put('images/shop/food/cover_image', $request->file('cover_image'));
        $this->shopRepo->updateShop($shop, $shop_id);
        $shop = $this->shopRepo->findById($shop_id);
        return response()->json($shop);
    }

    public function deleteByShopId($shop_id)
    {
        $shopBeforeDelete = $this->shopRepo->findById($shop_id);
        $path = $shopBeforeDelete['cover_image'];
        Storage::disk('s3')->delete($path);
        $this->shopRepo->delete($shop_id);
        return response('delete success', 200);
    }
}
