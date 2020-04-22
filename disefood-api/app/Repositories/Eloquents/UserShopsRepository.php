<?php


namespace App\Repositories\Eloquents;

use App\Models\UserShop;
use App\Repositories\Interfaces\UserShopsRepositoryInterface;

class UserShopsRepository implements UserShopsRepositoryInterface
{
    private $userShops;

    public function __construct()
    {
        $this->userShops = new UserShop;
    }

    public function getShopByUserId($user_id)
    {
        return $this->userShops->where('user_id', $user_id)->get();
    }
}
