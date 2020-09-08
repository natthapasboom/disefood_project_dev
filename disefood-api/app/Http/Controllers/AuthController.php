<?php


namespace App\Http\Controllers;

use App\Http\Requests\CreateUserStore;
use App\Http\Requests\LoginRequest;
use App\Repositories\Interfaces\UserRepositoryInterface;
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
//use Illuminate\Support\Facades\Hash;

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
        $request->validated();
        $credentials = request(['username', 'password']);
        if(!Auth::attempt($credentials))
            return response()->json([
                'msg' => 'Unauthorized',
                'status' => 401
            ]);

        $user = $request->user();

        $tokenResult = $user->createToken('Auth Token');
        $token = $tokenResult->token;
        $token->save();
        return response()->json([
            'data'  => $user,
            'access_token' => $tokenResult->accessToken,
            'token_type' => 'Bearer',
            'expires_at' => Carbon::parse(
                $tokenResult->token->expires_at
            )->toDateTimeString()
        ]);
    }

    public function detail()
    {
        $user = Auth::user();
        return response()->json(['data' => $user, 'status' => 200]);
    }

    public function logout()
    {
//        if (Auth::check()) {
//            Auth::user()->OauthAccessToken()->delete();
//        }
    }
}
