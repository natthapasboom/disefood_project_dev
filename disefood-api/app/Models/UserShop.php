<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserShop extends Model
{
    protected $table = 'user_shops';
    protected $primaryKey = 'id';
    protected $fillable = [
        'shop_id', 'user_id'
    ];
}
