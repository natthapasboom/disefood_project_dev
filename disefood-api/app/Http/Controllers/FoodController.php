<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\UpdateFoodInShop;
use Illuminate\Support\Facades\Storage;

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

    public function getFoodById($foodId)
    {
        $food = $this->foodRepo->findByFoodId($foodId);
        if(!$food) {
            return  response()->json(['msg' => 'Food Not Found', 'status' => 404]);
        } else {
            return response()->json(['data' => $food]);
        }
    }
}
