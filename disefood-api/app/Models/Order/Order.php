<?php

namespace App\Models\Order;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $table = 'orders';
    protected $primaryKey = 'order_id';
    protected $fillable = [
        'total_price', 'quantity', 'status', 'proof_payment',
        'payment_method', 'shop_id', 'user_id'
    ];
}
