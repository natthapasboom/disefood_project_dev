<?php

namespace App\Models\User;

use App\Models\Order\Order;
use App\Models\Shop\Shop;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    protected $table = 'users';
    protected $primaryKey ='id';
    protected $fillable = [
        'username', 'email', 'password',
        'first_name', 'last_name', 'tel',
        'profile_img', 'role'
    ];
    protected $hidden = [
        'id', 'password'
    ];

//    protected $attributes = [
//        'username' => false,
//        'email' => false,
//        'password' => false,
//        'first_name' => false,
//        'last_name' => false,
//        'tel' => false,
//        'profile_img' => false,
//        'role' => false
//    ];

    public function shop()
    {
        return $this->hasOne(Shop::class, 'user_id', 'id');
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class, 'user_id', 'id');
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'user_id', 'id');
    }
}
