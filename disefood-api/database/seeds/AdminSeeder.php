<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AdminSeeder extends Seeder
{
    public function run()
    {
        DB::table('users')->insert(
          [
              'username'    =>  'admin-tester-1',
              'password'    => Hash::make(123456789),
              'email'       => 'tester.tr@gmail.com',
              'role'        =>  'admin'
          ]
        );
    }
}
