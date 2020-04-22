<?php


namespace App\Repositories\Eloquents;

use App\Repositories\Interfaces\OrderDetailRepositoryInterface;
use App\Models\Order\OrderDetail;

class OrderDetailRepository implements OrderDetailRepositoryInterface
{
    private $orderDetail;

    public function __construct()
    {
        $this->orderDetail = new OrderDetail;
    }

    public function getOrderDetailByOrderId($order_id)
    {
        return $this->orderDetail->where('order_id', $order_id)->get();
    }
}
