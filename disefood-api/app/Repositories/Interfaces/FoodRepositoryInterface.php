<?php


namespace App\Repositories\Interfaces;


interface FoodRepositoryInterface
{
    public function get();
    public function findByFoodId($foodId);
//    public function findByShopId($shopId);
    public function addMenuByShopId($newMenu, $shopId);
//    public function update($food, $food_id);
//    public function delete($food_id);
}
