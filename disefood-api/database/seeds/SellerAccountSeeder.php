<?php

use Illuminate\Database\Seeder;
use App\Models\User;

class SellerAccountSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert([
           [
               'username' => 'azit',
               'password' => bcrypt('12345678')
           ]
        ]);
    }
}
