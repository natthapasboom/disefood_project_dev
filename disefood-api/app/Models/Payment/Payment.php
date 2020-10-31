<?php


namespace App\Models\Payment;

use App\Models\Order\Order;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $table = 'payments';
    protected $primaryKey = 'id';
    protected $fillable = [
      'transaction_id', 'amount', 'payment_date', 'order_id', 'payment_img'
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
