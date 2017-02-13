'use strict';

let Helpers = require('./helpers');
let Axios = require('axios');
let Vue = require('vue/dist/vue.min.js');

let axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue
    }
};

let vm = new Vue({
    el: '#root',
    data: {
        email: '',
        checkedOUt: false,
        checkingOut: false,
        subscribing: false,
        mobileNavIsActive: false
    },
    methods: {
        toggleMobileNav() {
            this.mobileNavIsActive = !this.mobileNavIsActive;
        },
        loadSubscriptionForm() {
            this.checkingOut = true;
            stripe();
        },
        unloadSubscriptionForm() {
            if (this.checkedOut) {
                // Finished subscribing
            } else {
                // Cancelled via form
                this.checkingOut = false;
            }
        },
        subscribeToPlan(token, args) {
            let app = this;
            Axios.post('/actions/swipe/plans/subscribe', {
                    token,
                    args
                }, axiosConfig)
                .then(
                    // OK
                    (response) => {
                        app.checkedOut = true;
                        console.log(response.data);
                        window.location = '/@selvinortiz';
                    },
                    // ERROR
                    (response) => {
                        app.checkedOut = true;
                        console.log(response.data);
                    }
                );
        },
        subscribeToNewsletter() {
            var app = this;

            this.subscribing = true;

            if (!this.email) {
                Helpers.__nay('Hey!', 'You should add your email address.');

                this.subscribing = false;

                return;
            }

            var body = {
                email: this.email
            };

            Axios.post('/actions/swipe/newsletter/subscribe', body, axiosConfig)
                .then(
                    // OK
                    (response) => {
                        if (response.data.success) {
                            Helpers.__yay(response.data.title, response.data.message.replace('{email}', response.data.params.email));
                            app.email = '';
                        } else {
                            Helpers.__nay(response.data.title, response.data.message);
                        }

                        app.subscribing = false;
                    },
                    // Error
                    (response) => {
                        Helpers.__nay('I\'m sorry!', 'Looks like I could not get you subscribed;(');

                        app.subscribing = false;
                    }
                );
        }
    }
});

let stripe = function() {
    const handler = StripeCheckout.configure({
        key: 'pk_test_ivZFpjEGRxj38UYz4CYQUk4t',
        image: '/dist/images/CraftXSmall.png',
        locale: 'auto',
        closed: vm.unloadSubscriptionForm,
        // Hand off to Vue instance
        token: vm.subscribeToPlan
            /*
              card: Object
              client_ip: "50.188.56.107"
              created: 1486798248
              email: "selvin@craftx.io"
              id: "tok_A67aQeIq2IQ16B"
              livemode: false
              object: "token"
              type: "card"
              used: false
              __proto__: Obje
             */
    });

    handler.open({
        name: 'Craft X',
        image: '/dist/images/CraftXSmall.png',
        description: 'Student Monthly Plan',
        zipCode: true,
        billingAddress: true,
        amount: 499
    });

    window.addEventListener('popstate', function() {
        handler.close();
    });
};
