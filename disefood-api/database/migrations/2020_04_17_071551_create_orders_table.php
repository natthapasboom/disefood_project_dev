<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->increments('order_id');
            $table->integer('shop_id')->unsigned();
            $table->integer('user_id')->unsigned();
            $table->integer('total_price');
            $table->integer('total_quantity');
            $table->enum('status', ['กำลังทำ', 'เสร็จสิ้น', 'ยังไม่ได้รับออเดอร์']);
            $table->string('proof_payment');
            $table->string('payment_method');
            $table->timestamps();

            $table->foreign('shop_id')->references('shop_id')->on('shops');
            $table->foreign('user_id')->references('user_id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('orders');
    }
}
