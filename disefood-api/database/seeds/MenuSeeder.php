<?php

use Illuminate\Database\Seeder;

class MenuSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $menus = [
            ['shop_id' => 1, 'name' => 'HOT SPICY CHICKEN',         'price' => 39,  'status' => true, 'cover_img' => 'forSeeder/Shops/menu/1_39_Hot_Spicy_Chicken.png'],
            ['shop_id' => 1, 'name' => 'TENDER CHICKEN',            'price' => 39,  'status' => true, 'cover_img' => 'forSeeder/Shops/menu/2_39_Tender_Chk.png'],
            ['shop_id' => 1, 'name' => 'SPICY CHICKEN RICE BOWL',   'price' => 59,  'status' => true, 'cover_img' => 'forSeeder/Shops/menu/3_59_SPICY_CHICKEN_RICE_BOWL.png'],
            ['shop_id' => 1, 'name' => 'ZINGER BURGER',             'price' => 65,  'status' => true, 'cover_img' => 'forSeeder/Shops/menu/4_65_Zinger_Burger.png'],
            ['shop_id' => 1, 'name' => 'DOUBLE CHEESE BURGER',      'price' => 85,  'status' => true, 'cover_img' => 'forSeeder/Shops/menu/5_85_Double_Cheese_Burger.png'],
            ['shop_id' => 1, 'name' => 'CHICKEN ZAB x 3',           'price' => 55,  'status' => true, 'cover_img' => 'forSeeder/Shops/menu/6_55_Chk_Zab_3.png'],
            ['shop_id' => 1, 'name' => 'EGG TART',                  'price' => 100, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/7_25_EggTart_1pc.png'],

            ['shop_id' => 2, 'name' => 'SPICY EBI',             'price' => 190, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/1_190_Spicy-Ebi.jpg'],
            ['shop_id' => 2, 'name' => 'KARAKE LARB',           'price' => 79, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/2_79_Karake_Larb.jpg'],
            ['shop_id' => 2, 'name' => 'SABA w SAUCE SET',      'price' => 199, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/3_199_Saba-w-Sauce-Set.jpg'],
            ['shop_id' => 2, 'name' => 'SALMON DONBURI SET',    'price' => 195, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/4_195_Salmon-Donburi-Set.jpg'],
            ['shop_id' => 2, 'name' => 'SAKANA BENTO',          'price' => 219, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/5_219_Sakana-Bento.jpg'],
            ['shop_id' => 2, 'name' => 'COOL NOODLE SOBA',      'price' => 119, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/6_119_Cool-Noodle-Soba+.jpg'],
            ['shop_id' => 2, 'name' => 'FIRE GARILIC',          'price' => 40, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/7_40_Fire-Garlic-Rice.jpg'],

            ['shop_id' => 3, 'name' => 'RICE MEAT',                     'price' => 199, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/1_199_RICE_MEAT.jpg'],
            ['shop_id' => 3, 'name' => 'GRILLED SALMON BELLY',          'price' => 79, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/2_79_Grilled+Salmon+Belly.jpg'],
            ['shop_id' => 3, 'name' => 'COLD NOODLE x TEMPURA',         'price' => 180, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/3_180_Cold_noodle_x_Tepura.jpg'],
            ['shop_id' => 3, 'name' => 'GRILLED SALMON IN SOY SAUCE',   'price' => 239, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/4_239_Grilled_Salmon_in_Soy_Sauce.jpg'],
            ['shop_id' => 3, 'name' => 'SALMON SALAD',                  'price' => 99, 'status' => true, 'cover_img' => 'forSeeder/Shops/menu/5_99_Salmon_Salad.jpg'],
        ];
        DB::table('foods')->insert($menus);
    }
}
