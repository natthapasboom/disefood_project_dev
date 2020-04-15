<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route::middleware('auth:api')->get('/user', function (Request $request) {
//     return $request->user();
// });

// Route::group([
//     'prefix' => 'shop',
//     'namespace' => 'Shop'
// ], function() {
//     Route::get('/', 'ShopController@getShops');
// });

// Route::prefix('shop')->group(function() {
//     Route::get('/','ShopController@getShops');
// });

// Route::get('/shops', 'ShopController@getShops');
// Route::get('shops', 'ShopController@getShops');
// use App\Models\Shop\Shop;
// Route::get('shops', function() {
//     return Shop::all();
// });

Route::get('shops', 'ShopController@getShopsList');
Route::get('shops/{shop_id}', 'ShopController@findShopById');
