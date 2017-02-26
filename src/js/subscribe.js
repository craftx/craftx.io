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

let subscribe_vm = new Vue({
    el: '#newsletter',
    data: {
        email: '',
        subscribing: false
    },
    methods: {
        subscribeToNewsletter() {
            let app = this;

            this.subscribing = true;

            if (!this.email) {
                Helpers.__nay('Hey!', 'You should add your email address.');

                this.subscribing = false;

                return;
            }

            let body = {
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
                        console.log(response);

                        app.subscribing = false;
                    }
                );
        }
    }
});
