'use strict';

let Axios = require('axios');
let Vue = require('vue/dist/vue.js');
let _ = require('lodash');

let axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue
    }
};

let signup_vm = new Vue({
    el: '#signup',
    delimiters: ['@{', '}'],
    data: {
        action: 'users/save-user',
        redirect: '/v1/confirm-your-email',
        email: '',
        username: '',
        firstName: '',
        lastName: '',
        address1: '',
        address2: '',
        city: '',
        state: '',
        zip: '',
        country: 'us',
        signingUp: false,
        _token: {},
        _stripe: {},
        _card: {}
    },
    computed: {
        name() {
            return this.firstName + ' ' + this.lastName;
        }
    },
    watch: {
        email() {
            this.validateEmail();
        },
        username() {
            this.validateUsername();
        }
    },
    mounted() {
        this._stripe = Stripe('pk_test_ivZFpjEGRxj38UYz4CYQUk4t');
        this._card = this._stripe.elements().create('card', {
            hidePostalCode: true,
            style: {
                base: {
                    color: '#9642be',
                    fontFamily: 'monospace',
                    fontSmoothing: 'antialiased',
                    '::placeholder': {
                        color: '#ccc',
                    },
                },
                invalid: {
                    color: '#c00'
                }
            }
        });

        this._card.mount('#card-element');
    },
    methods: {
        checkout() {
            let app = this;
            console.log('Attempting to checkout');
            this._stripe.createToken(this._card, {
                name: app.name,
                address_line1: "60 97TH LN NE",
                address_city: "Blaine",
                address_state: "MN",
                address_zip: "55434"
            }).then(function(result) {
                if (result.error) {
                    // Inform the user if there was an error
                    let errorElement = document.getElementById('card-errors');
                    errorElement.textContent = result.error.message;
                    console.log(errorElement);
                } else {
                    // Send the token to your server
                    app._token = result.token;
                    console.log(result);
                }
            });
        },
        validateEmail() {
            let app = this;
            let validate = _.debounce(() => {
                Axios.post('/actions/swipe/users/validate-email', {email: app.email}, axiosConfig)
                .then(
                    (response) => {
                        if (!response.data.success) {
                            return console.log(response.data.message);
                        }

                        console.log(response.data.message);
                    },
                    (response) => {
                        console.log(response);
                    }
                );
            });

            return validate();
        },
        validateUsername() {
            let app = this;
            let validate = _.debounce(() => {
                Axios.post('/actions/swipe/users/validate-username', {username: app.username}, axiosConfig)
                .then(
                    (response) => {
                        if (!response.data.success) {
                            return console.log(response.data.message);
                        }

                        console.log('Great', response.data.message);
                    },
                    (response) => {
                        console.log(response);
                    }
                );
            });

            return validate();
        },
        us(value, optional = '') {
            return this.country.toLowerCase() === 'us' ? value : optional;
        }
    }
});
