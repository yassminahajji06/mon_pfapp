<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing
    |--------------------------------------------------------------------------
    |
    | This local demo configuration lets Flutter Web call the Laravel API from
    | a browser during the PFE presentation. For a real deployment, replace "*"
    | with the final HTTPS frontend domain.
    |
    */

    'paths' => ['api/*'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['*'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,
];
