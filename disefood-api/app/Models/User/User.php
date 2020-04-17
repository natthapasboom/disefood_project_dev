<?php

namespace App\Models\User;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    protected $table = 'users';
    protected $primaryKey ='user_id';
    protected $fillable = [
        'username', 'password'
    ];
}
