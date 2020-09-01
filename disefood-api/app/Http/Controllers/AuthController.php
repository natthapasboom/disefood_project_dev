<?php


namespace App\Http\Controllers;

use App\Http\Requests\CreateUserStore;
use App\Http\Requests\LoginRequest;
use App\Repositories\Interfaces\UserRepositoryInterface;
use Illuminate\Support\Facades\Storage;
use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    private $userRepo;

    public function __construct
    (
        UserRepositoryInterface $userRepo
    )
    {
        $this->userRepo = $userRepo;
    }

    public function register(CreateUserStore $request)
    {
        $req = $request->validated();
        $pathImg = Storage::disk('s3')->put('images/user/profile_img', $request->file('profile_img'), 'public');
        $req['password'] = bcrypt($req['password']);
        $req['profile_img'] = $pathImg;
        $user = $this->userRepo->create($req);
        return response()->json(['data' => $user, 'msg' => 'Register Success', 'status' => 200]);
    }

    public function login(LoginRequest $request)
    {
        $req =  $request->validated();
        $username = $req['username'];
        $password = $req['password'];
        $user = null;
        $key = 'example_key';
        if(!$username || !$password || $username == null || $password == null) {
            return response()->json(['data' => $user, 'msg' => 'Username or Password is Wrong' , 'status' => 404]);
        } else {
            $user = $this->userRepo->findByUserName($username);
            if (Hash::check($password, $user['password']))
                $payload = $user;
                $token = JWT::encode($payload, $key);
                return response()->json(['data' => $user, 'token' => $token, 'status' => 200]);
        }
    }
}
