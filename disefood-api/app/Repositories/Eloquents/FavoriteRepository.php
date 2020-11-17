<?php


namespace App\Repositories\Eloquents;

use App\Models\User\Favorite;
use App\Repositories\Interfaces\FavoriteRepositoryInterface;

class FavoriteRepository implements FavoriteRepositoryInterface
{
    private $favRepo;

    public function __construct()
    {
        $this->favRepo = new Favorite();
    }

    public function getAll()
    {
        return $this->favRepo->all();
    }

    public function getById($fId)
    {
        return $this->favRepo->where('id', $fId)->get();
    }

    public function getByUserId($userId)
    {
        $favorites = $this->favRepo->where('user_id', $userId)->get();
        foreach ($favorites as $favorite) {
            $fId = $favorite->id;
            $favorite->find($fId)->get();
            $favorite->shop->makeHidden('user_id', 'approved', 'created_at', 'updated_at', 'deleted_at');
        }
        return $favorites;
    }

    public function create($newF)
    {
        return $this->favRepo->create($newF);
    }

    public function delete($fId)
    {
        return $this->favRepo->where('id', $fId)->delete();
    }
}
