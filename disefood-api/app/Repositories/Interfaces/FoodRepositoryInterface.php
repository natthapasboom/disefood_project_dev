<?php


namespace App\Repositories\Interfaces;


interface FoodRepositoryInterface
{
    public function get();
    public function findByShopId($shop_id);
}
