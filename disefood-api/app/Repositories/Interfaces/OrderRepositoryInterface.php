<?php


namespace App\Repositories\Interfaces;

interface OrderRepositoryInterface
{
    public function getOrderByShopId($shop_id);
    public function getOrderByUserId($user_id);
}
