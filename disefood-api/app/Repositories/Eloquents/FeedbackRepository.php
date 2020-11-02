<?php


namespace App\Repositories\Eloquents;


use App\Models\Shop\Feedback;
use App\Repositories\Interfaces\FeedbackRepositoryInterface;

class FeedbackRepository implements FeedbackRepositoryInterface
{
    private $feedbackRepo;

    public function __construct()
    {
        $this->feedbackRepo = new Feedback();
    }

    public function getAll()
    {
        return $this->feedbackRepo->all();
    }

    public function getById($id)
    {
        return $this->feedbackRepo->where('id', $id)->first();
    }

    public function getByShopId($shopId)
    {
        return $this->feedbackRepo->where('shop_id', $shopId)->get();
    }

    public function getByUserId($userId)
    {
        return $this->feedbackRepo->where('user_id', $userId)->get();
    }

    public function create($newFeedback)
    {
        return $this->feedbackRepo->create($newFeedback);
    }

    public function deleteById($id)
    {
        return $this->feedbackRepo->where('id', $id)->delete();
    }

    public function filterByRating($rating)
    {
        return $this->feedbackRepo->where('rating', $rating)->get();
    }
}
