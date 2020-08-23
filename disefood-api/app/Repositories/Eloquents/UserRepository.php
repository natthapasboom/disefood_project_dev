<?php


namespace App\Repositories\Eloquents;

use App\Repositories\Interfaces\UserRepositoryInterface;
use App\Models\User\User;

class UserRepository implements UserRepositoryInterface
{
    private $user;

    public function __construct()
    {
        $this->user = new User;
    }

    public function getAll()
    {
        return $this->user->get();
    }

    public function getUserById($userId)
    {
        return $this->user->where('id', $userId)->first();
    }

    public function create($newUser)
    {

        return $this->user->create($newUser);
    }

    public function findByUserName($username)
    {
        return $this->user->where('username', $username)->first();
    }

    public function updateById($user, $userId)
    {
        return $this->user->where('id', $userId)->update($user);
    }
}
