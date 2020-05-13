<?php

namespace App\Http\Requests;

use Illuminate\Http\Request;

class LoginRequest extends BaseFormRequest
{

    public function authorize()
    {
        return true;
    }

    public function rules(Request $request)
    {
        return [
            'username' => 'required|string',
            'password' => 'required|string'
        ];
    }
}
