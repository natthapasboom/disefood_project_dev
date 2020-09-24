<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run()
    {
        DB::table('users')->insert(
          [
              'id'          => 1,
              'username'    =>  'admin-tester-1',
              'password'    => Hash::make(123456789),
              'email'       => 'tester.tr@gmail.com',
              'role'        =>  'admin'
          ]
        );
    }
}
