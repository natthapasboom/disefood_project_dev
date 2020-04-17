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

Route::get('shops', 'ShopController@getShopsList');
Route::get('shops/{shop_id}', 'ShopController@findShopById');
Route::get('foods', 'FoodController@getFoodsList');
Route::get('shop/foods/{shop_id}', 'FoodController@getFoodsByShopId');

Route::get('user/{user_id}', 'UserController@getUserById');
Route::get('user/profile/{user_id}', 'UserController@getProfileById');

Route::get('order/shop/{shop_id}', 'OrderController@getOrderBySeller');
Route::get('order/user/{user_id}', 'OrderController@getOrderByUser');
Route::get('order/detail/{order_id}', 'OrderController@getOrderDetailByOrderId');
