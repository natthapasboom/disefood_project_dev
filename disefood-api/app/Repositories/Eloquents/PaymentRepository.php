<?php


namespace App\Repositories\Eloquents;


use App\Models\Payment\Payment;
use App\Repositories\Interfaces\PaymentRepositoryInterface;

class PaymentRepository implements PaymentRepositoryInterface
{
    private $payment;

    public function __construct()
    {
        $this->payment = new Payment();
    }

    public function getAll()
    {
        return $this->payment->all();
    }

    public function getById($pId)
    {
        return $this->payment->where('id', $pId)->first();
    }

    public function getByOrderId($orderId)
    {
        return $this->payment->where('order_id', $orderId)->first();
    }

    public function create($newPayment)
    {
        return $this->payment->create($newPayment);
    }
}
