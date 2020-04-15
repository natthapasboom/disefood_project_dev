<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class Shop extends Model
{
    protected $table = 'shops';
    protected $primaryKey = 'shop_id';
    protected $fillable = [
        'name', 'shop_slot', 'cover_image'
    ];
}
