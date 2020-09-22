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
                'user_id'     =>  2,
                'shop_slot'   =>  1,
                'name'        =>  'KFC',
                'cover_img'   =>  'https://disefood.s3-ap-southeast-1.amazonaws.com/forSeeder/Shops/KFC_shop_cover_img.png',
                'approved'    =>  1
            ],
            [
                'user_id'     =>  3,
                'shop_slot'   =>  2,
                'name'        =>  'YAYOI',
                'cover_img'   =>  'https://disefood.s3-ap-southeast-1.amazonaws.com/forSeeder/Shops/YAYOI_cover_img.png',
                'approved'    =>  1
            ],
            [
                'user_id'     =>  4,
                'shop_slot'   =>  3,
                'name'        =>  'BUN\'TOWN',
                'cover_img'   =>  'https://disefood.s3-ap-southeast-1.amazonaws.com/forSeeder/Shops/Bun_Town_shop_cover_img.jpg',
                'approved'    =>  1
            ],
            [
                'user_id'     =>  5,
                'shop_slot'   =>  4,
                'name'        =>  'FARM LUCK ฟาร์มรัก',
                'cover_img'   =>  '',
                'approved'    =>  0
            ],
            [
                'user_id'     =>  6,
                'shop_slot'   =>  5,
                'name'        =>  'พร นมสด',
                'cover_img'   =>  '',
                'approved'    =>  0
            ]
        );
    }
}
