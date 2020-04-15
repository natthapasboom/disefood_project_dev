<?php


namespace App\Repositories\Eloquents;
use App\Models\Food\Food;
use App\Repositories\Interfaces\FoodRepositoryInterface;
// use App\Models\Shop\Shop;
// use App\Repositories\Interfaces\ShopRepositoryInterface;

class FoodRepository implements FoodRepositoryInterface
{
    public function __construct()
    {
        $this->food = new Food();
    }

    public function get()
    {
        return $this->food->all();
    }

    public function findByShopId($shop_id)
    {
        return $this->food->where('shop_id', $shop_id)->get();
    }
}
