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
        Route::put('/profile', 'AuthController@updateProfile');
    });
});

Route::group([
    'prefix' => 'shop'
], function () {
    Route::get('/', 'ShopController@getShopsList');
    Route::get('/{shopId}/detail', 'ShopController@findShopById');
    Route::get('/search', 'ShopController@search');
    Route::get('/account-number', 'ShopController@getAccountNumbers');
    Route::get('/{shopId}/account-number', 'ShopController@getAccountNumberByShopId');

    Route::group([
       'prefix' => 'account-number',
       'middleware' => 'auth:api'
    ], function () {
        Route::post('/{shopId}', 'ShopController@addAccountNumber');
        Route::put('/update/{accNumberId}', 'ShopController@updateAccountNumberById');
        Route::delete('/delete/{accNumberId}', 'ShopController@deleteById');
    });

    Route::group([
        'prefix' => 'owner',
        'middleware' => 'auth:api'
    ], function () {
        Route::get('/', 'ShopController@getShopByOwner');
        Route::post('/','ShopController@create');
        Route::put('/{shopId}', 'ShopController@update');
        Route::get('/{shopId}/dataSum', 'ShopController@dataSummary');
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

Route::group([
   'prefix' => 'payment'
], function () {
    Route::get('/', 'PaymentController@getAllPayments');
    Route::get('/{paymentId}', 'PaymentController@getPaymentById');
    Route::get('/check/order/{orderId}', 'PaymentController@checkPayInFullAmount');
    Route::get('/confirmation/order/{orderId}','PaymentController@orderPaymentConfirmation');
});

Route::group([
    'prefix' => 'order'
], function () {

    Route::get('/', 'OrderController@getAll');

    Route::group([
        'prefix' => 'me',
        'middleware' => 'auth:api'
    ], function () {
        Route::get('/', 'OrderController@getOrderMe');
        Route::delete('/{orderId}', 'OrderController@rejectedOrder');
        Route::post('/{orderId}/payment', 'PaymentController@create');
        Route::get('/{orderId}/payment', 'PaymentController@getPaymentByOrderId');
    });

    Route::group([
        'prefix' => 'shop',
        'middleware' => 'auth:api'
    ], function () {
        Route::get('/{shopId}', 'OrderController@getByShopId');
        Route::post('/{shopId}', 'OrderController@createOrder');
        Route::put('/{orderId}', 'OrderController@updateStatus');
    });
});

Route::group([
    'prefix' => 'favorite'
], function () {

//    Route::get('/', 'FavoriteController@getAll');
//    Route::get('/{fId}', 'FavoriteController@getById');

    Route::group([
       'prefix' => 'me',
       'middleware' => 'auth:api'
    ], function () {
        Route::get('/', 'FavoriteController@getByMe');
        Route::post('/', 'FavoriteController@addFavoriteShop');
        Route::delete('/{fId}', 'FavoriteController@removeFavoriteShop');
    });
});

Route::group([
    'prefix' => 'feedback'
], function () {

//   Route::get('/', 'FeedbackController@getAll');
//   Route::get('/{id}', 'FeedbackController@getById');

   Route::group([
       'prefix' => 'me',
       'middleware' => 'auth:api'
   ], function () {
       Route::get('/', 'FeedbackController@getByMe');
       Route::post('/shop/{shopId}', 'FeedbackController@create');
       Route::delete('/{id}', 'FeedbackController@deleteById');
   });

   Route::group([
       'prefix' => 'shop',
       'middleware' => 'auth:api'
   ], function () {
       Route::get('/{shopId}', 'FeedbackController@getByShopId');
   });
});
