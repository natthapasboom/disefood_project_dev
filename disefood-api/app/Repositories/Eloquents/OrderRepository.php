<?php


namespace App\Repositories\Eloquents;

use App\Models\Shop\Shop;
use App\Models\Shop\Food;
use App\Models\Order\Order;
use App\Models\Order\OrderDetail;
use App\Repositories\Interfaces\OrderRepositoryInterface;
use function Aws\map;

class OrderRepository implements OrderRepositoryInterface
{
    private $order;
    private $shop;
    private $orderDetail;
    private $food;

    public function __construct()
    {
        $this->order = new Order;
        $this->orderDetail = new OrderDetail;
        $this->shop = new Shop;
        $this->food = new Food;
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
          $order->shop->makeHidden('user_id', 'shop_slot', 'approved', 'created_at', 'updated_at', 'deleted_at');
          $orderDetails = $order->orderDetails;
          foreach ($orderDetails as $orderDetail) {
              $orderDetail->food->makeHidden('shop_id', 'status', 'created_at', 'updated_at');
          }
        }
        return $orders;
    }

    public function getByShopId($shopId)
    {
        $orders = $this->order->where('shop_id', $shopId)->where('status', 'in process')->orderBy('time_pickup','asc')->get();
        foreach ( $orders as $order) {
            $id = $order['id'];
            $order->find($id)->get();
            $order->user->makeHidden('email', 'profile_img', 'role', 'created_at', 'updated_at');
            $order->shop->makeHidden('user_id', 'created_at', 'updated_at', 'deleted_at', 'cover_img', 'approved');
            $order->payment;
            $orderDetails = $order->orderDetails;
            foreach ($orderDetails as $orderDetail) {
                $orderDetail->food;
            }
        }
        return $orders;
    }

    public function updateById($orderId, $newOrder)
    {
        return $this->order->where('id', $orderId)->update($newOrder);
    }

    public function create($newOrders, $shopId, $userId)
    {
        $timePickUp = $newOrders['time_pickup'];
        $inputNewOrders = $newOrders['newOrder'];
        $order = $this->order;
        $shop = $this->shop->find($shopId);
        if(!$shop) return response()->json(['msg' => 'Shop not found'], 404);
        $order->shop_id = $shop->id;
        $order->user_id = $userId;
        $order->time_pickup = $timePickUp;


        $orderDetails = [];

        foreach ($inputNewOrders as $newOrder) {
            $orderDetail = new OrderDetail();
            $foodId = $newOrder['foodId'];
            $quantity = $newOrder['quantity'];
            $description = $newOrder['description'];

            $food = $this->food->find($foodId);

            $orderDetail->description = $description;
            $orderDetail->food_id = $food->id;
            $orderDetail->price = $quantity * $food->price;
            $orderDetail->quantity = $quantity;

            $order->total_price = $order->total_price + $orderDetail->price;
            $order->total_quantity = $order->total_quantity + $orderDetail->quantity;

            array_push($orderDetails, $orderDetail);
        }
        $order->save();
        $order->orderDetails()->saveMany($orderDetails);
        $order->orderDetails;
        return $order;
    }

    public function delete($orderId)
    {
        return $this->order->where('id', $orderId)->delete();
    }
}
