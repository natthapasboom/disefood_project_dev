<?php


namespace App\Repositories\Interfaces;


interface UserRepositoryInterface
{
    public function create($user);
    public function getUserById($user_id);
}
