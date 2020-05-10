<?php


namespace App\Repositories\Eloquents;
use App\Repositories\Interfaces\UserRepositoryInterface;
use App\Models\User\User;
use Illuminate\Support\Facades\Hash;

class UserRepository implements UserRepositoryInterface
{
    private $user;

    public function __construct()
    {
        $this->user = new User;
    }

    public function getUserById($user_id)
    {
        return $this->user->where('user_id', $user_id)->first();
    }

    public function create($user)
    {
        return $this->user->create($user);
    }

    public function get()
    {
        return $this->user->get();
    }

    public function login($user)
    {
        $username = $user['username'];
        $password = $user['password'];
        $user = $this->user->where('username', $username)->first();
        $user_id = $user['user_id'];
        $checkPass = $user['password'];

        if($username == $user['username']){
            if(Hash::check($password, $checkPass)){
                $temp = $this->user->find($user_id);
                $profile = $temp->profile()->get();
                return $profile;
            }
        }
    }
}
