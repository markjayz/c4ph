<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Address extends Model
{
    /**
     * @var string
     */
    protected $table = 'addresses';

    /**
     * @var bool
     */
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [ 
        'party_id', 
        'type',
        'street',
        'district',
        'city',
        'state',
        'postal_code',
        'region',
        'country_id'
    ];
}
