<?php


namespace App\Models\User;

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
}
