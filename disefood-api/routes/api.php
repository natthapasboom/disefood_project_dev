<?php

use Illuminate\Support\Facades\Route;

Route::group([
    'prefix' => 'admin',
    'middleware' => 'auth:api'
], function () {
    Route::get('/users', 'UserController@getAll');
    Route::put('/approved/{shopId}', 'ShopController@approved');
    Route::delete('/rejected/{shopId}', 'ShopController@rejected');
});

Route::group([
    'prefix' => 'user',
], function () {
    Route::get('/{userId}', 'UserController@getProfileById');
    Route::put('/{userId}', 'UserController@update');
});

Route::group([
    'prefix' => 'food'
], function () {
    Route::get('/{foodId}', 'FoodController@getFoodById');
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
    'prefix' => 'shop'
], function () {
    Route::get('/', 'ShopController@getShopsList');
    Route::get('/{shopId}/detail', 'ShopController@findShopById');

    Route::group([
        'prefix' => 'owner',
        'middleware' => 'auth:api'
    ], function () {
        Route::get('/', 'ShopController@getShopByOwner');
        Route::post('/','ShopController@create');
        Route::put('/{shopId}', 'ShopController@update');
    });

    Route::group([
        'prefix' => 'menu',
    ], function () {
       Route::get('/{shopId}', 'ShopController@getMenuByShopId');

       Route::group([
           'middleware' => 'auth:api'
       ], function () {
           Route::post('/{shopId}', 'ShopController@addMenu');
           Route::put('/edit/{foodId}', 'ShopController@updateMenuByFoodId');
           Route::delete('/remove/{foodId}', 'ShopController@deleteMenuByFoodId');
       });
    });
});
