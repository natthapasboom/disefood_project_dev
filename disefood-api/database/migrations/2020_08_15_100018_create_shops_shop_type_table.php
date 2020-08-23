<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShopsShopTypeTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shops_shop_type', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('shop_type_id')->unsigned();
            $table->integer('shop_id')->unsigned();
            $table->timestamps();

            $table->foreign('shop_type_id')->references('id')->on('shop_types');
            $table->foreign('shop_id')->references('id')->on('shops');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('shops_shop_type');
    }
}
