<?php


namespace App\Repositories\Interfaces;


interface AccountNumberRepositoryInterface
{
    public function getAll();
    public function getById($id);
    public function getByShopId($shopId);
    public function create($newAccountNumber, $shopId);
    public function updateById($newAccountNumber, $id);
    public function delete($id);
}
