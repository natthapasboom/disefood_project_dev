<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

//Route::group([
//    'middleware' => 'api',
//    'prefix' => 'auth'
//], function () {
//
//    Route::post('login', 'AuthController@login');
//    Route::post('logout', 'AuthController@logout');
//    Route::post('refresh', 'AuthController@refresh');
//    Route::post('me', 'AuthController@me');
//
//});
//SHOP
//Route::get('shops', 'ShopController@getShopsList');
//Route::get('shop/user/{user_id}', 'ShopController@getShopByUserId');
//Route::post('shop/{shop_id}', 'ShopController@addFoodToShop');
//Route::post('shop','ShopController@create');
//Route::put('shop/{shop_id}', 'ShopController@updateShop');
//Route::put('food/{food_id}', 'FoodController@updateFoodByFoodId');
//Route::get('shops/{shop_id}', 'ShopController@findShopById');
//Route::get('foods', 'FoodController@getFoodsList');
//Route::get('shop/foods/{shop_id}', 'FoodController@getFoodsByShopId');
//Route::delete('shop/{shop_id}', 'ShopController@deleteByShopId');
//Route::delete('food/{food_id}', 'FoodController@deleteByFoodId');
//USER
//Route::get('users', 'Usercontroller@getAll');
//Route::post('user', 'UserController@register');
//Route::get('user/{user_id}', 'UserController@getUserById');
//Route::get('user/profile/{user_id}', 'UserController@getProfileById');
//Route::get('user/shop/{user_id}','UserController@getShopByUserId');
//Route::post('login', 'UserController@login');
//Route::delete('user/{user_id}', 'UserController@deleteById');
//ORDER
//Route::get('order/shop/{shop_id}', 'OrderController@getOrderBySeller');
//Route::get('order/user/{user_id}', 'OrderController@getOrderByUser');
//Route::get('order/detail/{order_id}', 'OrderController@getOrderDetailByOrderId');

Route::group([
    'prefix' => 'admin'
], function () {
    Route::get('/users', 'UserController@getAll');
    Route::put('/approved/{shopId}', 'ShopController@approved');
    Route::delete('/rejected/{shopId}', 'ShopController@rejected');
});

Route::group([
    'prefix' => 'auth'
], function () {
    Route::post('/register', 'AuthController@register');
    Route::post('/login', 'AuthController@login');

    Route::group([
        'middleware' => 'auth:api'
    ], function () {
        Route::get('/logout', 'AuthController@logout');
        Route::get('/detail', 'AuthController@detail');
    });
});

Route::group([
    'prefix' => 'user',
], function () {
    Route::get('/{userId}', 'UserController@getProfileById');
    Route::put('/{userId}', 'UserController@update');
});

Route::group([
    'prefix' => 'shop'
], function () {
    Route::get('/', 'ShopController@getShopsList');
    Route::get('/{shopId}/detail', 'ShopController@findShopById');
    Route::post('/','ShopController@create');
    Route::put('/{shopId}', 'ShopController@update');

    Route::group([
        'prefix' => 'owner',
        'middleware' => 'auth:api'
    ], function () {
        Route::get('/', 'ShopController@getShopByOwner');
    });

    Route::group([
        'prefix' => 'menu'
    ], function () {
       Route::get('/{shopId}', 'ShopController@getMenuByShopId');
       Route::post('/{shopId}', 'ShopController@addMenu');
    });
});

Route::group([
    'prefix' => 'food'
], function () {
   Route::get('/{foodId}', 'FoodController@getFoodById');
   Route::put('/{foodId}', 'FoodController@updateFoodByFoodId');
   Route::delete('/{foodId}', 'FoodController@deleteByFoodId');
});
