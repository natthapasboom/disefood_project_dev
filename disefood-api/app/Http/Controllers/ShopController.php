<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\ShopRepositoryInterface;
use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Repositories\Interfaces\ProfileRepositoryInterface;
use App\Http\Requests\CreateShopRequest;
use App\Http\Requests\CreateFoodRequest;
use App\Http\Requests\UpdateShopRequest;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

class ShopController extends Controller
{
    private $shopRepo;
    private $foodRepo;
    private $userProfileRepo;

    public function __construct
    (
        ShopRepositoryInterface $shopRepo,
        FoodRepositoryInterface $foodRepo,
        ProfileRepositoryInterface $userProfileRepoRepo
    )
    {
        $this->shopRepo = $shopRepo;
        $this->foodRepo = $foodRepo;
        $this->userProfileRepo = $userProfileRepoRepo;
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
        $path = Storage::disk('s3')->put('images/shop/cover_image', $request->file('cover_image'),'public');
        $shop['cover_image'] = $path;
        $this->shopRepo->create($shop);
        return response('create shop success', 200);
    }

    public function addFoodToShop(CreateFoodRequest $request, $shop_id)
    {
        $food = $request->validated();
        $path = Storage::disk('s3')->put('images/shop/food/cover_image', $request->file('cover_image'), 'public');
        $food['cover_image'] = $path;
        return $this->foodRepo->addFood($food, $shop_id);
    }

    public function updateShop(Request $request, $shop_id)
    {
        $shop = $request->except(['_method' ]);
        $shop_beforeUpdate = $this->shopRepo->findById($shop_id);
        $path_beforeUpdate = $shop_beforeUpdate['cover_image'];
        Storage::disk('s3')->delete($path_beforeUpdate);
        $shop['cover_image'] = Storage::disk('s3')->put('images/shop/cover_image', $request->file('cover_image'), 'public');

        $this->shopRepo->updateShop($shop, $shop_id);
        return $this->shopRepo->findById($shop_id);
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
