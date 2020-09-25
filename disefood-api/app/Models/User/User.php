<?php

namespace App\Models\User;

use App\Models\Order\Order;
use App\Models\Shop\Shop;
use App\OauthAccessToken;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;
    protected $table = 'users';
    protected $primaryKey ='id';
    protected $fillable = [
        'username', 'email', 'password',
        'first_name', 'last_name', 'tel',
        'profile_img', 'role'
    ];

    protected $hidden = [
        'password', 'remember_token'
    ];

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

    public function AauthAccessToken(){
        return $this->hasMany(OauthAccessToken::class);
    }
}
