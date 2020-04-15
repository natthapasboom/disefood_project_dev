<?php


namespace App\Repositories\Eloquents;

use App\Models\Shop\Shop;
use App\Repositories\Interfaces\ShopRepositoryInterface;

class ShopRepository implements ShopRepositoryInterface
{
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
}
