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
        return response()->json(['data' => $users, 'status' => 200]);
    }

    public function getProfileById($userId)
    {
        $user = $this->userRepo->getUserById($userId);
        if ( !$user )
            return response()->json(['data' => $user, 'msg' => 'User Not Found' , 'status' => 404]);
        else
            return response()->json(['data' => $user, 'status' => 200]);
    }

    public function update($userId, UpdateUserRequest $request)
    {
        $user = $this->userRepo->getUserById($userId);
        if ( !$user ) {
            return response()->json(['data' => $user, 'msg' => 'User Not Found', 'status' => 404]);
        } else {
            $req = $request->validated();
            if ( !isset($req['profile_img']) ){
                $this->userRepo->updateById($req, $userId);
                $res = $this->userRepo->getUserById($userId);
                return response()->json(['data' => $res, 'msg' => 'Updated Success', 'status' => 200]);
            } else {
                $oldPath =  $user['profile_img'];
                Storage::disk('s3')->delete($oldPath);
                $newPath = Storage::disk('s3')->put('images/user/profile_img', $request->file('profile_img'), 'public');
                $req['profile_img'] = $newPath;
                $this->userRepo->updateById($req, $userId);
                $res = $this->userRepo->getUserById($userId);
                return response()->json(['data' => $res, 'msg' => 'Updated with Image Success', 'status' => 200]);
            }
        }
    }
}
