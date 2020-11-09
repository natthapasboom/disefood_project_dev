<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class AccountNumber extends Model
{
    protected $table = 'account_number';
    protected $primaryKey = 'id';
    protected $fillable = [
        'number', 'channel', 'shop_id'
    ];

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }
}
