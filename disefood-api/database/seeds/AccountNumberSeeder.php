<?php

use Illuminate\Database\Seeder;

class AccountNumberSeeder extends Seeder
{
    public function run()
    {
        $accountNumber = [
            [
                'number'    =>  '2020020202',
                'channel'   =>  'ธนาคารกรุงเทพ',
                'shop_id'   =>  1,
            ],
            [
                'number'    =>  '5162374893',
                'channel'   =>  'ธนาคารกรุงศรี',
                'shop_id'   =>  2,
            ],
            [
                'number'    =>  '0822552424',
                'channel'   =>  'พร้อมเพย์',
                'shop_id'   =>  3,
            ]
        ];

        DB::table('account_number')->insert($accountNumber);
    }
}
