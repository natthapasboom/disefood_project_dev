<?php

namespace App\Models\Shop;

use App\Models\Order\OrderDetail;
use Illuminate\Database\Eloquent\Model;

class Food extends Model
{
    protected $table = 'foods';
    protected $primaryKey = 'id';
    protected $fillable = [
        'shop_id', 'name', 'price', 'status', 'cover_img'
    ];

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }

    public function orderDetails()
    {
        return $this->hasMany(OrderDetail::class, 'food_id', 'id');
    }
}
