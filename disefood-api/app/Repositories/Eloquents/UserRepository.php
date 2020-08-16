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

//    public function delete($user_id)
//    {
//        return $this->user->find($user_id)->delete();
//    }
//
//    public function updateById($user_id, $user)
//    {
//        return $this->user->where('id', $user_id)->update($user);
//    }
}
