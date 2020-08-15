<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class Food extends Model
{
    protected $table = 'foods';
    protected $primaryKey = 'id';
    protected $fillable = [
        'shop_id', 'name', 'price', 'status', 'cover_img','type_name'
    ];

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }
}
