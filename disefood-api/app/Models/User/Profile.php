<?php

namespace App\Models\User;

use Illuminate\Database\Eloquent\Model;

class Profile extends Model
{
    protected $table = 'profiles';
    protected $fillable = [
        'user_id', 'first_name', 'last_name',
        'tel', 'profile_img', 'is_seller',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
