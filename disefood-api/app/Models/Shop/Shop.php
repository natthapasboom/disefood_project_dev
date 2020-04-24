<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Shop extends Model
{
    protected $table = 'shops';
    protected $primaryKey = 'shop_id';
    protected $fillable = [
        'name', 'shop_slot', 'cover_image'
    ];

//    public $appends = ['url', 'upload_time', 'size_in_kb'];

    public function getUrlAttribute()
    {
        return Storage::disk('s3')->url($this->path);
    }
//
//    public function getUploadedTimeAttribute()
//    {
//        return $this->created_at->diffForHumans();
//    }
//
//    public function getSizeInKbAttribute()
//    {
//        return round($this->size / 1024, 2);
//    }

    public function foods()
    {
        return $this->hasMany('App\Models\Shop\Food', 'food_id', 'food_id');
    }
}
