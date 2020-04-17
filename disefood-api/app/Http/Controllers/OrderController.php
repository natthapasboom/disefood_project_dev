<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Repositories\Interfaces\OrderDetailRepositoryInterface;

class OrderController extends Controller
{

    public function __construct
    (
        OrderRepositoryInterface $orderRepository,
        OrderDetailRepositoryInterface $orderDetailRepository
    )
    {
        $this->orderRepository = $orderRepository;
        $this->orderDetailRepository = $orderDetailRepository;
    }

    public function getOrderBySeller($shop_id)
    {
        $seller_order = $this->orderRepository->getOrderByShopId($shop_id);
        return $seller_order;
    }

    public function getOrderByUser($user_id)
    {
        $user_order = $this->orderRepository->getOrderByUserId($user_id);
        return $user_order;
    }

    public function getOrderDetailByOrderId($order_id)
    {
        $order = $this->orderDetailRepository->getOrderDetailByOrderId($order_id);
        return $order;
    }
}
