<?php


namespace App\Repositories\Interfaces;


interface FoodRepositoryInterface
{
    public function addFood($food, $shop_id);
    public function get();
    public function findByShopId($shop_id);
}
