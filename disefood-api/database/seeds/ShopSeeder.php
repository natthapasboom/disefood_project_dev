<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
class ShopSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('shops')->insert([
            ['name' => 'ร้านป้าสมจิตร', 'shop_slot' => 1],
            ['name' => 'ร้านก๋วยเตี๋ยวลุงเล็ก', 'shop_slot' => 2],
            ['name' => 'ร้านหนุ่ยบะหมี่เกี๊ยว', 'shop_slot' => 4],
            ['name' => 'ร้านอาหารอิสลาม อาบูดาบี', 'shop_slot' => 8,],
            ['name' => 'ครัวคุณอุ๊', 'shop_slot' => 10]
        ]);
    }
}
