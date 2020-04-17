<?php

namespace App\Models\Order;

use Illuminate\Database\Eloquent\Model;

class OrderDetail extends Model
{
    protected $table = 'order_details';
    protected $primaryKey = 'id';
    protected $fillable = [
        'description', 'quantity', 'order_id', 'food_id',
    ];
}
