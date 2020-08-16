<?php


namespace App\Repositories\Eloquents;

use App\Models\Shop\Food;
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
        $shop = $this->shop->find($shopId);
        $shop->foods;
        return $shop;
    }

//    public function addMenu($menu, $shopId)
//    {
//        $food = new Food();
//        $shop = $this->shop->find($shopId);
//        $food->name = $menu['name'];
//        $food->price = $menu['price'];
//        $food->status = $menu['status'];
//        $food->cover_img = $menu['cover_img'];
//        $shop->foods->save($food);
//        return $food;
//    }

//    public function delete($shop_id)
//    {
//        return $this->shop->where('shop_id', $shop_id)->delete();
//    }

//    public function getShopByUserId($user_id)
//    {
//        return $this->shop->where('user_id',$user_id)->first();
//    }
}
