<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class SellerSeeder extends Seeder
{
    public function run()
    {
        DB::table('users')->insert(
            [
                'username'    => 'seller-tester-1',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts1@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'username'    => 'seller-tester-2',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts2@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'username'    => 'seller-tester-3',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts3@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'username'    => 'seller-tester-4',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts4@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ],
            [
                'username'    => 'seller-tester-5',
                'password'    => Hash::make(123456789),
                'email'       => 'seller.ts5@gmail.com',
                'role'        => 'seller',
                'first_name'  => Str::random(10),
                'last_name'   => Str::random(10)
            ]
        );
    }
}
