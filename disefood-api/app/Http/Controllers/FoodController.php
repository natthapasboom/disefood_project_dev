<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\FoodRepositoryInterface;
//use App\Http\Requests\CreateFoodRequest;

class FoodController extends Controller
{
    private $foodRepo;

    public function __construct(FoodRepositoryInterface $foodRepo)
    {
        $this->foodRepo = $foodRepo;
    }

    public function getFoodsList()
    {
        return $this->foodRepo->get();
    }

    public function getFoodsByShopId($shop_id)
    {
        return $this->foodRepo->findByShopId($shop_id);
    }
}
