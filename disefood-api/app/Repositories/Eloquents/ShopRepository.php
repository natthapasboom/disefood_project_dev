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

    public function get()
    {
        return $this->shop->all();
    }

    public function findById($shop_id)
    {
        return $this->shop->find($shop_id);
    }

    public function create($shop)
    {
        return $this->shop->create($shop);
    }

    public function delete($shop_id)
    {
        return $this->shop->where('shop_id', $shop_id)->delete();
    }

    public function updateShop($shop, $shop_id)
    {
        return $this->shop->where('shop_id', $shop_id)->update($shop);
    }
}
