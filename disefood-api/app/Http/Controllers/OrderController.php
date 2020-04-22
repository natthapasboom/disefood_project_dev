<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Repositories\Interfaces\OrderDetailRepositoryInterface;

class OrderController extends Controller
{
    private $orderRepo;
    private $orderDetailRepo;

    public function __construct
    (
        OrderRepositoryInterface $orderRepo,
        OrderDetailRepositoryInterface $orderDetailRepo
    )
    {
        $this->orderRepo = $orderRepo;
        $this->orderDetailRepo = $orderDetailRepo;
    }

    public function getOrderBySeller($shop_id)
    {
        return $this->orderRepo->getOrderByShopId($shop_id);
    }

    public function getOrderByUser($user_id)
    {
        return $this->orderRepo->getOrderByUserId($user_id);
    }

    public function getOrderDetailByOrderId($order_id)
    {
        return $this->orderDetailRepo->getOrderDetailByOrderId($order_id);
    }
}
