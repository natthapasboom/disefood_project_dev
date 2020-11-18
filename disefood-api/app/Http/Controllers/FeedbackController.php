<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateFeedbackRequest;
use App\Repositories\Interfaces\FeedbackRepositoryInterface;
use App\Repositories\Interfaces\ShopRepositoryInterface;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FeedbackController extends Controller
{
    private $feedbackRepo;
    private $shopRepo;

    public function __construct
    (
        FeedbackRepositoryInterface $feedbackRepo,
        ShopRepositoryInterface $shopRepo
    )
    {
        $this->feedbackRepo = $feedbackRepo;
        $this->shopRepo = $shopRepo;
    }

    public function getAll()
    {
        $feedbacks = $this->feedbackRepo->getAll();
        return response()->json(['data' => $feedbacks], 200);
    }

    public function getById($id)
    {
        $feedback = $this->feedbackRepo->getById($id);
        return response()->json(['data' => $feedback], 200);
    }

    public function getByShopId($shopId)
    {
        $seller = $this->isSeller();
        $sellerId = $seller['id'];
        $isOwner = $this->isOwner($sellerId, $shopId);
        if($isOwner) {
            $feedbacks = $this->feedbackRepo->getByShopId($shopId);

            foreach ($feedbacks as $feedback) {
                $feedback->user;
            }

            if (isset($_GET["rating"])) {
                $rating = $_GET["rating"];
                $feedbacks = $this->feedbackRepo->shopFilterByRating($rating, $shopId);

                foreach ($feedbacks as $feedback) {
                    $feedback->user;
                }

                return  response()->json(['data' => $feedbacks], 200);
            } else {
                return response()->json(['data' => $feedbacks], 200);
            }

        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    public function getByMe()
    {
        $user = Auth::user();
        $userId = $user->id;
        $feedbacks = $this->feedbackRepo->getByUserId($userId);
        return response()->json(['data' => $feedbacks], 200);
    }

    public function create(CreateFeedbackRequest $request, $shopId)
    {
        $user = Auth::user();
        $userId = $user->id;
        $shop = $this->shopRepo->findById($shopId);
        $shopId = $shop->id;

        $req = $request->validated();

        if(!$req) return response()->json(['msg' => 'Failed Validation'], 422);

        $req['user_id'] = $userId;
        $req['shop_id'] = $shopId;
        $newFeedback = $this->feedbackRepo->create($req);

        return response()->json(['data' => $newFeedback, 'msg' => 'Created feedback success'],200);
    }

    public function deleteById($id)
    {
        $feedback = $this->feedbackRepo->getById($id);
        $user = Auth::user();
        $userId = $user->id;
        $feedbackUserId = $feedback->user_id;
        if($userId == $feedbackUserId)
        {
            $this->feedbackRepo->deleteById($id);
            $feedbacks = $this->feedbackRepo->getByUserId($userId);
            return response()->json(['data' => $feedbacks, 'msg' => 'Remove success'], 200);
        } else {
            return response()->json(['msg' => 'No Permission'], 401);
        }
    }

    private function isSeller()
    {
        $user = Auth::user();
        $role = $user['role'];
        if($role == 'seller')
            return $user;
    }

    private function isOwner($userId, $shopId)
    {
        $isOwner = null;
        $shop = $this->shopRepo->findById($shopId);
        if( $shop['user_id'] == $userId ){
            $isOwner = true;
        } else {
            $isOwner = false;
        }
        return $isOwner;
    }
}
