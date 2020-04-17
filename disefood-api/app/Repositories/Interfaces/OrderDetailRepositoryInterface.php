<?php


namespace App\Repositories\Interfaces;


interface OrderDetailRepositoryInterface
{
    public function getOrderDetailByOrderId($order_id);
}
