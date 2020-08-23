<?php


namespace App\Repositories\Interfaces;


interface ShopRepositoryInterface
{
    public function getAll();
    public function create($newShop);
    public function findById($shopId);
    public function updateShop($shop, $shopId);
    public function findMenuByShopId($shopId);
//    public function addMenu($menu, $shopId);
//    public function getShopByUserId($user_id);
//    public function delete($shop_id);
}
