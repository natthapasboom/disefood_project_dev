<?php


namespace App\Models\User;

use App\Models\Shop\Shop;
use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    protected $table = 'favorites';
    protected $primaryKey = 'id';
    protected $fillable = [
        'user_id', 'shop_id'
    ];
    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function shop()
    {
        return $this->belongsTo(Shop::class);
    }
}
