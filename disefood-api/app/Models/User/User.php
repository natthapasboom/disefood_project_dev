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
        'username', 'email', 'password'
    ];
    protected $hidden = [
        'id', 'password'
    ];

    public function profile()
    {
        return $this->hasOne(Profile::class, 'user_id', 'id');
    }

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
