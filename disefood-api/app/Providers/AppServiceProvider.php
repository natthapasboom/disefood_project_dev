<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $models = array(
            'User',
            'Shop',
            'Food',
            'Order',
            'OrderDetail',
            'Favorite',
            'AccountNumber',
            'Feedback'
        );
        foreach($models as $model) {
            $this->app->bind("App\Repositories\Interfaces\\{$model}RepositoryInterface", "App\Repositories\Eloquents\\{$model}Repository");
        }
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Schema::defaultStringLength(191);
    }
}
