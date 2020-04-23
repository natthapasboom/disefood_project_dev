<?php


namespace App\Repositories\Eloquents;

use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Models\Order\Order;

class OrderRepository implements OrderRepositoryInterface
{
    private $order;

    public function __construct()
    {
        $this->order = new Order;
    }

    public function getOrderByShopId($shop_id)
    {
        return $this->order->where('shop_id', $shop_id)->get();
    }

    public function getOrderByUserId($user_id)
    {
        return $this->order->where('user_id', $user_id)->get();
    }
}
