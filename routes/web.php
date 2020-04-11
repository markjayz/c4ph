<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});

$router->group(['prefix'=>'api/v1'], function() use($router){
    $router->get('/addresses', 'AddressController@index');
    $router->post('/address', 'AddressController@create');
    $router->get('/address/{id}', 'AddressController@show');
    $router->put('/address/{id}', 'AddressController@update');
    $router->delete('/address/{id}', 'AddressController@destroy');
});
