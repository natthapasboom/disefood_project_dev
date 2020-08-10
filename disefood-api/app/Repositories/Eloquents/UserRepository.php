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
        return $this->user->with('profile')->get();
    }

    public function login($user)
    {
        $username = $user['username'];
        $password = $user['password'];
        $find_user = $this->user->where('username', $username)->first();
        $find_user_id = $find_user['user_id'];
        $find_user_password = $find_user['password'];

        if($username == $find_user['username']){
            if(Hash::check($password, $find_user_password)){
                $res_user = $this->user->find($find_user_id);
                $res_user->profile;
                return $res_user;
            }else{
                return 'if 1';
            }
        }else{
            return  'if 2';
        }
    }
}
