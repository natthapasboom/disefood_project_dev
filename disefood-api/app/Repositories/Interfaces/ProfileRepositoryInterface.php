<?php


namespace App\Repositories\Interfaces;


interface ProfileRepositoryInterface
{
    public function create($user, $user_id);
    public function getProfileById($user_id);
}
