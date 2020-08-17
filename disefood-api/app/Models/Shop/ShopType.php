<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class ShopType extends Model
{
    protected $table = 'shop_types';
    protected $primaryKey = 'id';
    protected $fillable = [
        'type_name'
    ];

    public function shops()
    {
        return $this->hasMany(ShopsShopType::class, 'shop_type_id', 'id');
    }
}
