<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FoodSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('foods')->insert([
            ['shop_id' => '1', 'name' => 'ข้าวราดไก่กระเทียม', 'price' => 30, 'status' => TRUE],
            ['shop_id' => '1', 'name' => 'ข้าวราดผัดหน่อไม้',  'price' => 40, 'status' => TRUE],
            ['shop_id' => '1', 'name' => 'ข้าวราดทอดมัน',  'price' => 45, 'status' => TRUE],
            ['shop_id' => '1', 'name' => 'ข้าวราดหมูกระเทียม',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '1', 'name' => 'ข้าวราดคะน้าหมูกรอบ',  'price' => 40, 'status' => TRUE],
            ['shop_id' => '2', 'name' => 'เส้นเล็กน้ำตก',  'price' => 30, 'status' => TRUE],
            ['shop_id' => '2', 'name' => 'เส้นใหญ่น้ำตก',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '2', 'name' => 'บะหมี่น้ำตก',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '2', 'name' => 'เส้นเล็กต้มยำ',  'price' => 40, 'status' => TRUE],
            ['shop_id' => '2', 'name' => 'เส้นใหญ่ต้มยำ',  'price' => 40, 'status' => TRUE],
            ['shop_id' => '3', 'name' => 'บะหมี่น้ำหมูแดง',  'price' => 50, 'status' => TRUE],
            ['shop_id' => '3', 'name' => 'บะหมี่น้ำหมูกรอบ',  'price' => 50, 'status' => TRUE],
            ['shop_id' => '3', 'name' => 'บะหมี่แห้งหมูกรอบ',  'price' => 50, 'status' => TRUE],
            ['shop_id' => '3', 'name' => 'บะหมี่แห้งหมูแดง',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '3', 'name' => 'บะหมี่เกี๊ยวน้ำ',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '4', 'name' => 'ข้าวหมกไก่ต้ม',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '4', 'name' => 'ข้าวหมกไก่ทอด',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '4', 'name' => 'ข้าวแกงมัสหมัน',  'price' => 40, 'status' => TRUE],
            ['shop_id' => '4', 'name' => 'ข้าวราดซุปหางวัว', 'price' => 45, 'status' => TRUE],
            ['shop_id' => '4', 'name' => 'ข้าวไก่ราดซอสน้ำแดง',  'price' => 50, 'status' => TRUE],
            ['shop_id' => '5', 'name' => 'ข้าวราดกะเพราะหมูสับ',  'price' => 45, 'status' => TRUE],
            ['shop_id' => '5', 'name' => 'ข้าวราดไก่ย่างน้ำจิ้มแจ่ว',  'price' => 30, 'status' => TRUE],
            ['shop_id' => '5', 'name' => 'ข้าวหมูทอดพริกไทยดำ',  'price' => 30, 'status' => TRUE],
            ['shop_id' => '5', 'name' => 'ข้าวราดปูผัดผงกะหรี่',  'price' => 35, 'status' => TRUE],
            ['shop_id' => '5', 'name' => 'ข้าวราดยำไข่ดาวกุ้งสด',  'price' => 30, 'status' => TRUE],
        ]);
    }
}
