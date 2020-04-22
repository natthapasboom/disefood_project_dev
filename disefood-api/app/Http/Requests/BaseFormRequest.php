<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Request;

abstract class BaseFormRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    abstract public function authorize();


    /**
     * Get the validation rules that apply to the request.
     *
     * @param Request $request
     * @return array
     */
    abstract public function rules(Request $request);

    protected function formatErrors($errors)
    {
        return $errors;
    }
}
