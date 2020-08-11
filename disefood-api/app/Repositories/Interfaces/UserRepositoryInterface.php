<?php


namespace App\Repositories\Interfaces;


interface UserRepositoryInterface
{
    public function get();
    public function create($user);
    public function login($user);
    public function getUserById($user_id);
    public function delete($user_id);

}
