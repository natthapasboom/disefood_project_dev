<?php


namespace App\Repositories\Interfaces;


interface PaymentRepositoryInterface
{
    public function getAll();
    public function getById($pId);
    public function getByOrderId($orderId);
    public function create($newPayment);
}
