<?php


namespace App\Repositories\Eloquents;

use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Models\Order\Order;
use function Aws\map;

class OrderRepository implements OrderRepositoryInterface
{
    private $order;

    public function __construct()
    {
        $this->order = new Order;
    }

    public function getAll()
    {
        return $this->order->all();
    }

    public function getById($orderId)
    {
        return $this->order->where('id', $orderId)->first();
    }

    public function getByUserId($userId)
    {
        $orders = $this->order->where('user_id', $userId)->get();
        foreach ( $orders as $order) {
          $id = $order['id'];
          $order->find($id)->get();
          $order->orderDetails;
        }
        return $orders;
    }

    public function getByShopId($shopId)
    {
        $orders = $this->order->where('shop_id', $shopId)->get();
        foreach ( $orders as $order) {
            $id = $order['id'];
            $order->find($id)->get();
            $order->orderDetails;
        }
        return $orders;
    }

    public function updateById($orderId, $newOrder)
    {
        return $this->order->where('id', $orderId)->update($newOrder);
    }

    public function create($newOrder)
    {
        // TODO: Implement create() method.
    }

    public function delete($orderId)
    {
        return $this->order->where('id', $orderId)->delete();
    }
}
