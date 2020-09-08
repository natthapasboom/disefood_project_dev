<?php

namespace App\Http\Requests;

use Illuminate\Http\Request;

class CreateShopRequest extends BaseFormRequest
{

    public function authorize()
    {
        return true;
    }

    public function rules(Request $request)
    {
        return [
            'name'          => 'required|string|max:50|unique:shops,name',
            'shop_slot'     => 'required|integer|unique:shops,shop_slot',
            'cover_img'   => 'image',
            'document_img'=> 'required|image',
        ];
    }
}
