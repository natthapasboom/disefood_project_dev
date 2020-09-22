<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class ShopSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('shops')->insert(
          [
              'user_id'     =>  '',
              'shop_slot'   =>  1,
              'name'        =>  Str::random(10),
              'cover_img'   =>  '',
              'approved'    =>  1
          ]
        );
    }
}
