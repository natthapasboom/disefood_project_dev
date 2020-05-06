<?php


namespace App\Repositories\Eloquents;

use App\Models\Shop\Food;
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

    public function addFood($food, $shop_id)
    {
        $food['shop_id'] = $shop_id;
        return $this->food->create($food);
    }

    public function findByFoodId($food_id)
    {
        return $this->food->where('food_id', $food_id)->first();
    }

    public function findByShopId($shop_id)
    {
        return $this->food->where('shop_id', $shop_id)->get();
    }

    public function update($food, $food_id)
    {
        return $this->food->where('food_id', $food_id)->update($food);
    }

    public function delete($food_id)
    {
        return $this->food->where('food_id', $food_id)->delete();
    }
}
