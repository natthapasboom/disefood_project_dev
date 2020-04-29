<?php


namespace App\Repositories\Eloquents;

use App\Repositories\Interfaces\ProfileRepositoryInterface;
use App\Models\User\Profile;

class ProfileRepository implements ProfileRepositoryInterface
{
    private $profile;

    public function __construct()
    {
        $this->profile = new Profile;
    }

    public function getProfileById($user_id)
    {
        return $this->profile->where('user_id', $user_id)->first();
    }

    public function create($user, $user_id)
    {
        $user['user_id'] = $user_id;
        return $this->profile->create($user);
    }
}
