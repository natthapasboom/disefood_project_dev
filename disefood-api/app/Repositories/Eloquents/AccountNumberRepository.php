<?php


namespace App\Repositories\Eloquents;


use App\Models\Shop\AccountNumber;
use App\Models\Shop\Shop;
use App\Repositories\Interfaces\AccountNumberRepositoryInterface;

class AccountNumberRepository implements AccountNumberRepositoryInterface
{
    private $accNumber;

    public function __construct()
    {
        $this->accNumber = new AccountNumber();
    }

    public function getAll()
    {
        return $this->accNumber->all();
    }

    public function getById($id)
    {
        return $this->accNumber->where('id', $id)->first();
    }

    public function getByShopId($shopId)
    {
        return $this->accNumber->where('shop_id', $shopId)->get();
    }

    public function create($newAccountNumber, $shopId)
    {
        $shop = Shop::find($shopId);
        $this->accNumber->shop()->associate($shop);

        $this->accNumber->number = $newAccountNumber['number'];
        $this->accNumber->channel = $newAccountNumber['channel'];

        $this->accNumber->save($newAccountNumber);
        return $this->accNumber;

    }

    public function updateById($newAccountNumber, $id)
    {
        return $this->accNumber->where('id', $id)->update($newAccountNumber);
    }
    public function delete($id)
    {
        return $this->accNumber->where('id', $id)->delete();
    }
}
