<?php

namespace App\Models\Order;

use App\Models\Shop\Food;
use Illuminate\Database\Eloquent\Model;

class OrderDetail extends Model
{
    protected $table = 'order_detail';
    protected $primaryKey = 'id';
    protected $fillable = [
        'description', 'quantity', 'price', 'order_id', 'food_id',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
