<?php


namespace App\Repositories\Interfaces;


interface FoodRepositoryInterface
{
    public function get();
    public function findByFoodId($food_id);
    public function findByShopId($shop_id);
    public function addFood($food, $shop_id);
    public function update($food, $food_id);
    public function delete($food_id);
}
