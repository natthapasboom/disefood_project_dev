<?php


namespace App\Repositories\Interfaces;


interface ShopRepositoryInterface
{
    public function get();
    public function findById($shop_id);
}
