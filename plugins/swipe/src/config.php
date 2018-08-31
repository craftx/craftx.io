<?php

return [
    'stripeSecretKey'   => getenv('SWIPE_STRIPE_SECRET_KEY'),
    'stripePublicKey'   => getenv('SWIPE_STRIPE_PUBLIC_KEY'),
    'usernameBlacklist' => [],
];
