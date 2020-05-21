<?php

namespace App\Http\Requests;

use Illuminate\Http\Request;

class UpdateFoodInShop extends BaseFormRequest
{

    public function authorize()
    {
        return true;
    }

    public function rules(Request $request)
    {
        return [
            'name' => 'string',
            'price' => 'integer',
            'status' => 'boolean',
//            'cover_image' => 'image'
        ];
    }
}
