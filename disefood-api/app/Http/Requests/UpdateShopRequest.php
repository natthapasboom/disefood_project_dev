<?php

namespace App\Http\Requests;

use Illuminate\Http\Request;

class UpdateShopRequest extends BaseFormRequest
{

    public function authorize()
    {
       return true;
    }

    public function rules(Request $request)
    {
        return [
            'name'          => 'string',
            'shop_slot'     => 'integer',
            'cover_img'   => 'image',
        ];
    }
}
