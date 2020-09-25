<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class SellerSeeder extends Seeder
{
    public function run()
    {

        $seller = [
            [
                'id'          => 2,
                'username'    => 'seller-tester-1',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts1@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'id'          => 3,
                'username'    => 'seller-tester-2',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts2@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'id'          => 4,
                'username'    => 'seller-tester-3',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts3@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'id'          => 5,
                'username'    => 'seller-tester-4',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts4@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'id'          => 6,
                'username'    => 'seller-tester-5',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts5@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ]
        ];

        DB::table('users')->insert($seller);
    }
}
