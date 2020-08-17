<?php


namespace App\Repositories\Eloquents;

use App\Models\Shop\Food;
use App\Models\Shop\Shop;
use App\Repositories\Interfaces\FoodRepositoryInterface;

class FoodRepository implements FoodRepositoryInterface
{
    private $food;

    public function __construct()
    {
        $this->food = new Food();
    }

    public function get()
    {
        return $this->food->all();
    }

//    public function addFood($food, $shopId)
//    {
//        $food['shop_id'] = $shopId;
//        return $this->food->create($food);
//    }

    public function findByFoodId($foodId)
    {
        return $this->food->where('id', $foodId)->first();
    }

//    public function findByShopId($shopId)
//    {
//        return $this->food->where('shop_id', $shopId)->get();
//    }

//    public function update($food, $food_id)
//    {
//        return $this->food->where('food_id', $food_id)->update($food);
//    }

//    public function delete($food_id)
//    {
//        return $this->food->where('food_id', $food_id)->delete();
//    }
    public function addMenuByShopId($newMenu, $shopId)
    {
        $shop = Shop::find($shopId);
        $this->food->shop()->associate($shop);

        $this->food->name = $newMenu['name'];
        $this->food->price = $newMenu['price'];
        $this->food->status = $newMenu['status'];
        $this->food->cover_img = $newMenu['cover_img'];

        $this->food->save($newMenu);
        return $this->food;
    }
}
