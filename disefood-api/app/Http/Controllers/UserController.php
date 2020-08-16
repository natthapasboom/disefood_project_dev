<?php

namespace App\Http\Controllers;

//use Illuminate\Http\Request;
use App\Http\Requests\CreateUserStore;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Repositories\Interfaces\UserRepositoryInterface;
use Illuminate\Support\Facades\Storage;


class UserController extends Controller
{

    private $userRepo;

    public function __construct
    (
        UserRepositoryInterface $userRepo
    )
    {
        $this->userRepo = $userRepo;
    }

    public function getAll()
    {
        $users = $this->userRepo->getAll();
        return response()->json(['data' => $users]);
    }

//    public function getUserById($userId)
//    {
//        $user = $this->userRepo->getUserById($userId);
//        return response()->json(['data' => $user]);
//    }
//    public function getProfileById($user_id)
//    {
//        return $this->profileRepo->getProfileById($user_id);
//    }

//    public function getShopByUserId($user_id)
//    {
//        return $this->userShopRepo->getShopByUserId($user_id);
//    }

//    public function register(CreateUserStore $request)
//    {
//        $newUser = $request->validated();
//        $path = Storage::disk('s3')->put('images/user/profile_img', $request->file('profile_img'), 'public');
//        $newUser['profile_img'] = $path;
//        $newUser['password'] = bcrypt($newUser['password']);
//        $user = $this->userRepo->create($newUser);
//        $user_id = $user['user_id'];
//        $this->profileRepo->create($newUser, $user_id);
//
//        return response('register success', 200);
//    }

//    public function login(LoginRequest $request)
//    {
//
//        $login =  $request->validated();
//        $key = 'example_key';
//        $res = $this->userRepo->login($login);
//        $payload = $res;
//        $jwt = JWT::encode($payload, $key);
//        $decoded = JWT::decode($jwt, $key, array('HS256'));
//        $response = [
//            'access token' => $jwt,
//            'data' => $decoded
//        ];
//        return response($response, 200);
//    }

//    public function deleteById($user_id) {
//        $user = $this->userRepo->getUserById($user_id);
//        $temp = $user->profile()->first();
//        $path = $temp->profile_img;
//        Storage::disk('s3')->delete($path);
//        $this->userRepo->delete($user_id);
//        return response('delete success', 200);
//    }

//    public function updateById($user_id, UpdateUserRequest $request) {
//        $user = $this->userRepo->getUserById($user_id);
//        $temp = $user->profile()->first();
//        $path = $temp->profile_img;
//    }
}
