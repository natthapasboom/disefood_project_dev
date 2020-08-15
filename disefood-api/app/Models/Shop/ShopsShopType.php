<?php


namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class ShopsShopType extends Model
{
    protected $table = 'shop_types';
    protected $primaryKey = 'id';
    protected $fillable = [
        'shop_id', 'shop_type_id'
    ];

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }

    public function shopType()
    {
        return $this->belongsTo(ShopsShopType::class);
    }
}
