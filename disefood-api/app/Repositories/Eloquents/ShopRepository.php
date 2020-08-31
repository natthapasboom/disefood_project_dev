<?php


namespace App\Repositories\Eloquents;

use App\Models\Shop\Shop;
use App\Repositories\Interfaces\ShopRepositoryInterface;

class ShopRepository implements ShopRepositoryInterface
{
    private $shop;

    public function __construct()
    {
        $this->shop = new Shop();
    }

    public function getAll()
    {
        return $this->shop->all();
    }

    public function findById($shopId)
    {
        return $this->shop->where('id', $shopId)->first();
    }

    public function create($shop)
    {
        return $this->shop->create($shop);
    }

    public function updateShop($shop, $shopId)
    {
        return $this->shop->where('id', $shopId)->update($shop);
    }

    public function findMenuByShopId($shopId)
    {
        return $this->shop->find($shopId);
    }

    public function delete($shopId)
    {
        return $this->shop->where('id', $shopId)->delete();
    }
}
