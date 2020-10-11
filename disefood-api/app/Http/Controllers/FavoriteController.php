<?php


namespace App\Http\Controllers;


use App\Repositories\Interfaces\FavoriteRepositoryInterface;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
    private $favRepo;

    public function __construct
    (
        FavoriteRepositoryInterface $favRepo
    )
    {
         $this->favRepo = $favRepo;
    }

    public function getAll()
    {
        $favorites = $this->favRepo->getAll();
        return response()->json(['data' => $favorites], 200);
    }

    public function getById($fId)
    {
        $favorite = $this->favRepo->getById($fId);
        if(!$favorite) return response()->json(['msg' => 'Favorite not found'], 404);
        return response()->json(['data' => $favorite], 200);
    }

    public function getByMe()
    {
        $user = Auth::user();
        $favorites = $this->favRepo->getByUserId($user->id);
        return response()->json(['data' => $favorites], 200);
    }

    public function addFavoriteShop(Request $request)
    {
        $user = Auth::user();
        $shopId = $request->shopId;
        $userId = $user->id;

        $req['user_id'] = $userId;
        $req['shop_id'] = $shopId;

        $newFav = $this->favRepo->create($req);

        return response()->json(['data' => $newFav, 'msg' => 'Add favorite shop success'], 200);
    }

    public function removeFavoriteShop($fId)
    {
        if(Auth::check()) {
            $user = Auth::user();
            $this->favRepo->delete($fId);
            $favorites = $this->favRepo->getByUserId($user->id);
            return response()->json(['data' => $favorites, 'msg' => 'Remove favorite shop success'], 200);
        }
    }
}
