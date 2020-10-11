<?php


namespace App\Repositories\Interfaces;


interface FavoriteRepositoryInterface
{
    public function getAll();
    public function getById($fId);
    public function getByUserId($userId);
    public function create($newF);
    public function delete($fId);
}
