<?php

namespace App\Http\Controllers;

// use Illuminate\Http\Request;
use App\Repositories\Interfaces\FoodRepositoryInterface;

class FoodController extends Controller
{
    public function __construct(FoodRepositoryInterface $foodRepository)
    {
        $this->foodRepository = $foodRepository;
    }

    public function getFoodsList()
    {
        $foodsList = $this->foodRepository->get();
        return $foodsList;
    }

    public function getFoodsByShopId($shop_id)
    {
        $foodsList = $this->foodRepository->findByShopId($shop_id);
        return $foodsList;
    }
}
