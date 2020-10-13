<?php

namespace App\Models\Shop;

use App\Models\Order\Order;
use App\Models\User\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;
use Illuminate\Database\Eloquent\SoftDeletes;

class Shop extends Model
{
    use SoftDeletes;

    protected $table = 'shops';
    protected $primaryKey = 'id';
    protected $fillable = [
        'name', 'shop_slot', 'cover_img', 'user_id', 'approved'
    ];
    /**
     * @var mixed
     */
    private $path;

    protected $hidden = [
        'document_img'
    ];

    public function getUrlAttribute()
    {
        return Storage::disk('s3')->url($this->path);
    }

    public function foods()
    {
        return $this->hasMany(Food::class, 'shop_id', 'id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function feedbacks()
    {
        return $this->hasMany(Feedback::class, 'shop_id', 'id');
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'shop_id', 'id');
    }

    public function shopTypes()
    {
        return $this->hasMany(ShopsShopType::class, 'shop_id', 'id');
    }

    public function accountNumbers()
    {
        return $this->hasMany(AccountNumber::class, 'shop_id', 'id');
    }
}
