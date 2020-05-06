<?php

namespace App\Http\Requests;

use Illuminate\Http\Request;

class CreateUserStore extends BaseFormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules(Request $request)
    {
        return [
            'username'          => 'required|string|max:50|min:4|unique:users,username',
            'password'          => 'required|string|max:50|min:6',
            'first_name'        => 'required|string|max:50',
            'last_name'         => 'required|string|max:50',
            'tel'               => 'required|string|max:10|min:10|unique:profiles,tel',
            'profile_img'       => 'image',
            'is_seller'         => 'required|boolean',
        ];
    }
}
