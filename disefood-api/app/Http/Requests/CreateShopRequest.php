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
            'name'          => 'required|string|max:50',
            'shop_slot'     => 'required|integer',
//            'cover_image'   => 'image',
            'user_id'       => 'required|integer'
        ];
    }
}
