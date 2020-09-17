<?php


namespace App\Repositories\Interfaces;

interface OrderRepositoryInterface
{
    public function getAll();
    public function getById($orderId);
    public function getByUserId($userId);
    public function getByShopId($shopId);
    public function updateById($orderId, $newOrder);
    public function create($newOrder);
    public function delete($orderId);
}
