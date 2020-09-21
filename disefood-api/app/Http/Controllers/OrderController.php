<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateOrderRequest;
use App\Http\Requests\UpdateOrder;
use App\Repositories\Interfaces\ShopRepositoryInterface;
use Illuminate\Http\Request;
use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Repositories\Interfaces\OrderDetailRepositoryInterface;
use Illuminate\Support\Facades\Auth;

class OrderController extends Controller
{
    private $orderRepo;
    private $orderDetailRepo;
    private $shopRepo;

    public function __construct
    (
        OrderRepositoryInterface $orderRepo,
        OrderDetailRepositoryInterface $orderDetailRepo,
        ShopRepositoryInterface  $shopRepo
    )
    {
        $this->orderRepo = $orderRepo;
        $this->orderDetailRepo = $orderDetailRepo;
        $this->shopRepo = $shopRepo;
    }

    public function getAll()
    {
        return $this->orderRepo->getAll();
    }

    public function getById($orderId)
    {
        return $this->orderRepo->getById($orderId);
    }

    //Seller
    public function getByShopId($shopId)
    {
        $user = Auth::user();
        if( $this->isSeller($user) && $this->isOwner($user['id'], $shopId)) {
            $order = $this->orderRepo->getByShopId($shopId);
            return response()->json(['data' => $order], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    //Seller
    public function updateStatus(UpdateOrder $request, $orderId)
    {
        //TODO: check payment before change status
        $user = Auth::user();
        $order = $this->orderRepo->getById($orderId);
        $request = $request->validated();
        if(!$order) return response()->json(['msg' => 'Order Not Found'], 404);
        if( $this->isSeller($user) && $this->isOwner($user['id'], $order['shop_id'])) {
            $this->orderRepo->updateById($order['id'], $request);
            $order = $this->getById($order['id']);
            return response()->json(['data' => $order, 'msg' => 'Updated Success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    //Customer
    public function createOrder(CreateOrderRequest $request, $shopId)
    {
        $request = $request->validated();
        $user = Auth::user();
        $userId = $user->id;
        $order = $this->orderRepo->create($request, $shopId, $userId);
        return response()->json(['data' => $order, 'msg' => 'Created Success'], 200);
    }
    //Customer
    public function getOrderMe()
    {
        $user = Auth::user();
        $userId = $user['id'];
        $order =  $this->orderRepo->getByUserId($userId);
        return response()->json(['data' => $order], 200);
    }

    //Customer
    public function rejectedOrder($orderId)
    {
        $user = Auth::user();
        $order = $this->orderRepo->getById($orderId);

        if(!$order) return response()->json(['msg' => 'Order Not Found'], 404);

        $status = $order->status;
        if($status != 'not confirmed') return response()->json(['msg' => 'Can not reject this order'], 404);

        if($order['user_id'] != $user['id']) return response()->json(['msg' => 'No Permission'], 401);

        $order = $this->orderRepo->delete($orderId);
        return response()->json(['data' => $order, 'msg' => 'Rejected Success'], 200);
    }

    private function isSeller($user)
    {
        $role = $user['role'];
        if($role == 'seller')
            return true;
    }

    private function isOwner($userId, $shopId)
    {
        $shop = $this->shopRepo->findById($shopId);
        if( $shop['user_id'] == $userId )
            return true;
    }
}
