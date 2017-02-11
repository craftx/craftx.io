'use strict';

let Axios = require('axios');
let Alert = require('sweetalert');
let Vue = require('vue/dist/vue.min.js');
let axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue
    }
};

let stripe = function() {
    const handler = StripeCheckout.configure({
      key: 'pk_test_ivZFpjEGRxj38UYz4CYQUk4t',
      image: 'https://s3.amazonaws.com/stripe-uploads/acct_1iX7iJje6sWpbRPTIHapmerchant-icon-1486581383463-Craft%20X%20Mark%20Tiny.png',
      locale: 'auto',
      token: function(token) {
          /*
          Object
            card
            :
            Object
            client_ip
            :
            "50.188.56.107"
            created
            :
            1486798248
            email
            :
            "selvin@craftx.io"
            id
            :
            "tok_A67aQeIq2IQ16B"
            livemode
            :
            false
            object
            :
            "token"
            type
            :
            "card"
            used
            :
            false
            __proto__
            :
            Obje
           */
      }
    });

  handler.open({
    name: 'Craft X™',
    image: '/dist/images/CraftXSmall.png',
    description: 'Student Monthly Plan',
    zipCode: true,
    billingAddress: true,
    amount: 499
  });
};

let app = new Vue({
    el: '#app',
    data: {
        email: '',
        checkingOut: false,
        subscribing: false,
        mobileNavIsActive: false
    },
    methods: {
        clicked(e) {
            this.checkingOut = true;
            stripe();
        },
        toggleMobileNav() {
            this.mobileNavIsActive = !this.mobileNavIsActive;
        },
        subscribe() {
            var app = this;

            this.subscribing = true;

            if (!this.email)
            {
                this.__nay('Hey!', 'You should add your email address.');

                this.subscribing = false;

                return;
            }

            var body = {
                email: this.email
            };

            body[csrfTokenName] = csrfTokenValue;

            Axios.post('/actions/swipe/newsletter/subscribe', body, axiosConfig)
            .then(
                // OK
                (response) => {
                    if (response.data.success) {
                        app.__yay(response.data.title, response.data.message.replace('{email}', response.data.params.email));
                        app.email = '';
                    } else {
                        app.__nay(response.data.title, response.data.message);
                    }

                    app.subscribing = false;
                },
                // Error
                (response) => {
                    app.__nay('I\'m sorry!', 'Looks like I could not get you subscribed;(');

                    app.subscribing = false;
                }
            );
        },
        __yay(title, message) {
            Alert({
                title: title,
                text: message,
                type: "success",
                confirmButtonColor: '#00966c'
            });
        },
        __nay(title, message) {
            Alert({
                title: title,
                text: message,
                type: "error",
                confirmButtonColor: '#00966c'
            });
        }
    }
});
