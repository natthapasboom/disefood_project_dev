<?php


namespace App\Repositories\Interfaces;


interface UserShopsRepositoryInterface
{
    public function getShopByUserId($user_id);
}
