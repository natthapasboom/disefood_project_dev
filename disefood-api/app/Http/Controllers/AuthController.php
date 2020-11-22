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
use Laravel\Socialite\Facades\Socialite;

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
        if (!$req) response()->json(['msg' => 'Failed Validation'], 422);
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
        if (!Auth::attempt($credentials))
            return response()->json([
                'msg' => 'Wrong username or password',
            ], 401);

        $user = $request->user();

        $tokenResult = $user->createToken('Auth Token');
        $token = $tokenResult->token;
        $token->expires_at = Carbon::now()->addWeek(1);
        $token->save();
        return response()->json([
            'data' => $user,
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
        if (Auth::check()) {
            Auth::user()->AauthAccessToken()->delete();
            return response()->json(['msg' => 'Logout Success'], 200);
        }
    }

    public function updateProfile(UpdateUserRequest $request)
    {
        if (!Auth::check()) {
            return response()->json(['msg' => 'No permission'], 401);
        }

        $user = Auth::user();
        $userId = $user->id;
        $username = $user->username;
        $credentials['username'] = $username;
        $credentials['password'] = $request['confirm_password'];
        unset($request['confirm_password']);
        if (!Auth::guard('web')->attempt($credentials)) {
            return response()->json(['msg' => 'Wrong password'], 401);
        }

        if ($request->profile_img != null) {
            $req = $request->validated();
            unset($req['confirm_password']);
            if (!$req) {
                return response()->json(['msg' => 'Failed Validation'], 422);
            }

            $oldPath = $user['profile_img'];
            Storage::disk('s3')->delete($oldPath);
            $newPath = Storage::disk('s3')->put('images/user/profile_img', $request->file('profile_img'), 'public');
            $req['profile_img'] = $newPath;
            $this->userRepo->updateById($req, $userId);
            $newUser = $this->userRepo->getUserById($userId);
            return response()->json(['data' => $newUser, 'msg' => 'Updated Profile With Image Success'], 200);
        } else {
            $req = $request->except(['_method']);
            $this->userRepo->updateById($req, $userId);
            $newUser = $this->userRepo->getUserById($userId);
            return response()->json(['data' => $newUser, 'msg' => 'Updated Profile Success'], 200);
        }
    }

    /**
     * Social Login
     * @param string $provider
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function redirectToProvider($provider = 'facebook')
    {
        return Socialite::driver($provider)->redirect();
    }

    public function handleProviderCallback($provider = 'facebook')
    {
        $providerUser = Socialite::driver($provider)->user();
        $token = $providerUser->token;
        response()->json(['data' => $token]);
    }

    public function getProfileFacebook(Request $request, $provider = 'facebook')
    {
        $token = $request['token'];
        $facebookUser = Socialite::driver($provider)->userFromToken($token);
        $newUser['remember_token'] = $facebookUser->token;
        $newUser['username'] = $facebookUser->getName();
        $newUser['email'] = $facebookUser->getEmail();
        $newUser['profile_img'] = $facebookUser->getAvatar();
        return response()->json(['data' => $facebookUser]);
        $duplicateUser = $this->userRepo->findByEmail($facebookUser->getEmail());


        if (!!$duplicateUser) {
            $user = $duplicateUser;
        } else {
            $newUser['password'] = bcrypt(0);
            $user = $this->userRepo->create($newUser);
        }

        $firstName = $user->first_name;
        $lastName = $user->last_name;
        $tel = $user->tel;

        $missingValue_status = null;
        if(!$firstName || !$lastName || !$tel) {
            $missingValue_status = true;
        } else {
            $missingValue_status = false;
        }

        $tokenResult = $user->createToken('Auth Token');
        $token = $tokenResult->token;
        $token->expires_at = Carbon::now()->addWeek(1);
        $token->save();

        return response()->json([
            'data' => $user,
            'missing_profile' => $missingValue_status,
            'access_token' => $tokenResult->accessToken,
            'token_type' => 'Bearer',
            'expires_at' => Carbon::parse(
                $tokenResult->token->expires_at
            )->toDateTimeString()
        ]);
    }
}
