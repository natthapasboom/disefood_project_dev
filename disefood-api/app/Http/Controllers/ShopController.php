<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\ShopRepositoryInterface;
// use Illuminate\Http\Request;

class ShopController extends Controller
{
    public function __construct(ShopRepositoryInterface $shopRepository)
    {
        $this->shopRepository = $shopRepository;
    }

    public function getShopsList()
    {
        $shopsList = $this->shopRepository->get();
        return $shopsList;
    }

    public function findShopById($shop_id)
    {
        $shop = $this->shopRepository->findById($shop_id);
        if($shop == null) {
            return response()->json(['error' => 'Shop not found'], 404);
        }
        return $shop;
    }
}
