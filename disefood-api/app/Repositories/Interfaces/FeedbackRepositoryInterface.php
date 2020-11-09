<?php


namespace App\Repositories\Interfaces;


interface FeedbackRepositoryInterface
{
    public function getAll();
    public function getById($id);
    public function getByShopId($shopId);
    public function getByUserId($userId);
    public function create($newFeedback);
    public function deleteById($id);
    public function filterByRating($rating);
}
