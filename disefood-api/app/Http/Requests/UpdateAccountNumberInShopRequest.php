<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateAccountNumberInShopRequest extends FormRequest
{

    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'number' => 'string|unique:account_number,number',
            'channel' => 'string'
        ];
    }
}
