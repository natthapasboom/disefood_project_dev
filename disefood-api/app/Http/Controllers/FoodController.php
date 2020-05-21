<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\UpdateFoodInShop;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

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

    public function updateFoodByFoodId(Request $request, $food_id)
    {
        $food = $request->except(['_method']);
//        $food_beforeUpdate = $this->foodRepo->findByFoodId($food_id);
//        $path_beforeUpdate = $food_beforeUpdate['cover_image'];
//        Storage::disk('s3')->delete($path_beforeUpdate);
//        $food['cover_image'] = Storage::disk('s3')->put('images/shop/food/cover_image', $request->file('cover_image'), 'public');

        $this->foodRepo->update($food, $food_id);
        return $this->foodRepo->findByFoodId($food_id);
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
