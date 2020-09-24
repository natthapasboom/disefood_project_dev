<?php


namespace App\Http\Controllers;

use App\Http\Requests\CreateUserStore;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Repositories\Interfaces\UserRepositoryInterface;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

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

    //TODO: insert token to column remember_token !!!
    public function register(CreateUserStore $request)
    {
        $req = $request->validated();
        if(!$req) response()->json(['msg' => 'Failed Validation'], 422);
        $pathImg = Storage::disk('s3')->put('images/user/profile_img', $request->file('profile_img'), 'public');
        $req['password'] = bcrypt($req['password']);
        $req['profile_img'] = $pathImg;
        $user = $this->userRepo->create($req);
        return response()->json(['data' => $user, 'msg' => 'Register Success'], 200);
    }

    public function login(LoginRequest $request)
    {
        $request->validated();
        $credentials = request(['username', 'password']);
        if(!Auth::attempt($credentials))
            return response()->json([
                'msg' => 'Wrong username or password',
            ], 401);

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
        return response()->json(['data' => $user], 200);
    }

    public function logout()
    {
        if( Auth::check()) {
            Auth::user()->AauthAccessToken()->delete();
            return response()->json(['msg' => 'Logout Success'], 200);
        }
    }

    //TODO: if u want to update profile. u must type password to verified
    public function updateProfile(UpdateUserRequest $request)
    {
//        $req = $request->validated();
//        if( Auth::check() ) {
//            $user = Auth::user();
//            $username = $user->username;
//            $credentials['username'] = $username;
//            $credentials['password'] = $req['confirm_password'];
//            dd(Auth::attempt($credentials));
//        } else {
//            response()->json(['msg' => 'No permission'], 401);
//        }
    }
}
