<?php


namespace App\Repositories\Interfaces;


interface ShopRepositoryInterface
{
    public function get();
    public function create($newShop);
    public function findById($shop_id);
    public function delete($shop_id);
    public function updateShop($shop, $shop_id);

}
