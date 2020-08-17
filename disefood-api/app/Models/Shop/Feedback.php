<?php


namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;

class Feedback extends Model
{
    protected  $table = 'feedbacks';
    protected $primaryKey = 'id';
    protected $fillable = [
        'comment', 'rating', 'user_id', 'shop_id'
    ];

    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }
}
