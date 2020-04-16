<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class Food extends Model
{
    protected $table = 'foods';
    protected $primaryKey = 'food_id';
    protected $fillable = [
        'shop_id', 'name', 'price', 'status', 'cover_image','type'
    ];
}
