<?php

namespace App\Models\Shop;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Shop extends Model
{
    protected $table = 'shops';
    protected $primaryKey = 'shop_id';
    protected $fillable = [
        'name', 'shop_slot', 'cover_image', 'user_id', 'approved'
    ];
    /**
     * @var mixed
     */
    private $path;

    public function getUrlAttribute()
    {
        return Storage::disk('s3')->url($this->path);
    }

    public function foods()
    {
        return $this->hasMany(Food::class, 'shop_id', 'shop_id');
    }
}
