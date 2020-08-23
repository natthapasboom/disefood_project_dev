<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'username'          => 'string|min:4|max:50|unique:users,username',
            'email'             => 'string|min:6|max:50|unique:users,email',
            'first_name'        => 'string|max:50',
            'last_name'         => 'string|max:50',
            'tel'               => 'string|min:10|max:10|unique:users,tel',
            'profile_img'       => 'image',
        ];
    }
}
