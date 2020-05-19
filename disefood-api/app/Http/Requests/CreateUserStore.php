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
            'username'          => 'required|string',
            'password'          => 'required|string',
            'first_name'        => 'required|string',
            'last_name'         => 'required|string',
            'tel'               => 'required|string',
            'profile_img'       => 'image',
            'is_seller'         => 'required|boolean',
        ];
    }
}
