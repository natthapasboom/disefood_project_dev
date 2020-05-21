<?php

namespace App\Http\Requests;

use Illuminate\Http\Request;

class CreateFoodRequest extends BaseFormRequest
{

    public function authorize()
    {
        return true;
    }

    public function rules(Request $request)
    {
        return [
            'name'          => 'required|string|max:50',
            'price'         => 'required|integer',
            'status'        => 'required|boolean',
            // 'cover_image'   => 'image',
        ];
    }
}
