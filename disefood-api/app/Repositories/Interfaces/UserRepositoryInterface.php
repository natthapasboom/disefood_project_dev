<?php


namespace App\Repositories\Interfaces;


interface UserRepositoryInterface
{
    public function getAll();
    public function getUserById($userId);
    public function create($newUser);
    public function findByUserName($username);
    public function updateById($user, $userId);
}
