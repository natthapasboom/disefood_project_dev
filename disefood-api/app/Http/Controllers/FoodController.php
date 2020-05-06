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

    public function getFoodsByShopId($shop_id)
    {
        return $this->foodRepo->findByShopId($shop_id);
    }

    public function updateFoodByFoodId(UpdateFoodInShop $request, $food_id)
    {
        $food = $request->validated();
        $this->foodRepo->update($food, $food_id);
        $food = $this->foodRepo->findByFoodId($food_id);
        return response()->json($food);
    }

    public function deleteByFoodId($food_id)
    {
        $foodBeforeDelete = $this->foodRepo->findByFoodId($food_id);
        $path = $foodBeforeDelete['cover_image'];
        Storage::disk('s3')->delete($path);
        $this->foodRepo->delete($food_id);
        return response('delete shop success', 200);
    }
}
