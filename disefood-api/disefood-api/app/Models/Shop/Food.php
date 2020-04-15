<?php

namespace App\Models\Food;

use Illuminate\Database\Eloquent\Model;

class Food extends Model
{
    protected $table = 'foods';
    protected $primaryKey = 'food_id';
    protected $fillable = [
        'shop_id', 'name', 'cover_image','type'
    ];
}
