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

let app = new Vue({
    el: '#app',
    data: {
        email: '',
        subscribing: false,
        mobileNavIsActive: false
    },
    methods: {
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
