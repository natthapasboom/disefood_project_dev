<?php


namespace App\Models\Payment;

use App\Models\Order\Order;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $table = 'payments';
    protected $primaryKey = 'transaction_id';
    protected $fillable = [
      'amount', 'date', 'order_id'
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
