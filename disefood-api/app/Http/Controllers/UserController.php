<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Repositories\Interfaces\UserRepositoryInterface;
use App\Repositories\Interfaces\ProfileRepositoryInterface;

class UserController extends Controller
{

    /**
     * UserController constructor.
     */
    public function __construct
    (
        UserRepositoryInterface $userRepository,
        ProfileRepositoryInterface $profileRepository
    )
    {
        $this->userRepository = $userRepository;
        $this->profileRepository = $profileRepository;
    }

    public function getUserById($user_id)
    {
        $user = $this->userRepository->getUserById($user_id);
        return $user;
    }

    public function getProfileById($user_id)
    {
        $user_profile = $this->profileRepository->getProfileById($user_id);
        return $user_profile;
    }
}
