<?php

use Illuminate\Database\Seeder;

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
            ['name' => 'ร้านป้าสมจิตร'],
            ['name' => 'ร้านก๋วยเตี๋ยวลุงเล็ก'],
            ['name' => 'ร้านหนุ่ยบะหมี่เกี๊ยว'],
            ['name' => 'ร้านอาหารอิสลาม อาบูดาบี'],
            ['name' => 'ครัวคุณอุ๊']
    ]);
    }
}
