<?php


namespace App\Repositories\Interfaces;


interface FoodRepositoryInterface
{
    public function get();
    public function findByFoodId($foodId);
    public function addMenuByShopId($newMenu, $shopId);
    public function update($food, $foodId);
    public function delete($foodId);
}
