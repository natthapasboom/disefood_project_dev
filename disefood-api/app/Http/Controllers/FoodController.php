<?php

namespace App\Http\Controllers;

use App\Repositories\Interfaces\FoodRepositoryInterface;
use App\Http\Requests\UpdateFoodInShop;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

class FoodController extends Controller
{
    private $foodRepo;

    public function __construct(FoodRepositoryInterface $foodRepo)
    {
        $this->foodRepo = $foodRepo;
    }

    public function getFoodsList()
    {
        return $this->foodRepo->get();
    }

    public function getFoodById($foodId)
    {
        $food = $this->foodRepo->findByFoodId($foodId);
        if(!$food) {
            return  response()->json(['msg' => 'Food Not Found', 'status' => 404]);
        } else {
            return response()->json(['data' => $food]);
        }
    }

    public function updateFoodByFoodId(UpdateFoodInShop $request, $foodId)
    {
        $food = $this->foodRepo->findByFoodId($foodId);
        if(!$food) {
            return response()->json(['data' => $food, 'msg' => 'Food Not Found', 'status' => 404]);
        } else {
            $req = $request->validated();
            if(!isset($req['cover_img'])) {
                $this->foodRepo->update($req, $foodId);
                $food = $this->foodRepo->findByFoodId($foodId);
                return response()->json(['data' => $food, 'msg' => 'Updated Success', 'status' => 200]);
            } else {
                $oldPath = $food['cover_img'];
                Storage::disk('s3')->delete($oldPath);
                $newPath = Storage::disk('s3')->put('images/shop/food/cover_img', $request->file('cover_img'), 'public');
                $req['cover_img'] = $newPath;
                $this->foodRepo->update($req, $foodId);
                $food = $this->foodRepo->findByFoodId($foodId);
                return response()->json(['data' => $food, 'msg' => 'Updated with Image Success']);
            }
        }
    }

    public function deleteByFoodId($foodId)
    {
        $food = $this->foodRepo->findByFoodId($foodId);
        if(!$food) {
            return response()->json(['data' => $food, 'msg' => 'Food Not Found', 'status' => 404]);
        } else {
            $oldPath = $food['cover_img'];
            Storage::disk('s3')->delete($oldPath);
            $food = $this->foodRepo->delete($foodId);
            return response()->json(['data' => $food, 'msg' => 'Remove Food Success', 'status' => 200]);
        }
    }
}
