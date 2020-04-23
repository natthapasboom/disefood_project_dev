<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\ShopRepositoryInterface;
use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\CreateShopRequest;
use App\Http\Requests\CreateFoodRequest;

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
        return $this->shopRepo->create($shop);
    }

    public function addFoodToShop(CreateFoodRequest $request, $shop_id)
    {
        $food = $request->validated();
//        dd($request->all());
//        dd($this->foodRepo->addFood($food, $shop_id));
        return $this->foodRepo->addFood($food, $shop_id);
    }
}
