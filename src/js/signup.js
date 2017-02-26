'use strict';

let Axios = require('axios');
let Vue = require('vue/dist/vue.min.js');
let _ = require('lodash');

let axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue
    }
};

let stripeElementConfig = {
    hidePostalCode: true,
    iconStyle: 'solid',
    style: {
        base: {
            color: '#9642be',
            iconColor: '#9642be',
            fontFamily: '"Fira Sans", "Segoe UI", "Roboto", "Oxygen", -apple-system, BlinkMacSystemFont, "Ubuntu", "Cantarell", "Droid Sans", "Helvetica Neue", "Helvetica", "Arial", sans-serif',
            fontSize: '1.5rem'
        }
    }
};
let stripeElementFont = {
    fonts: [{
        family: 'Fira Sans',
        weight: 300,
        src: 'local("Fira Sans"), url("https://craftx.io/dist/fonts/firasans-regular.woff2") format("woff2"), url("https://craftx.io/dist/fonts/firasans-regular.woff") format("woff")',
    }],
}

let stripePublishableKey = 'pk_test_ivZFpjEGRxj38UYz4CYQUk4t';

let signupVM = new Vue({
    el: '#signup',
    delimiters: ['@{', '}'],
    data: {
        action: 'users/save-user',
        redirect: '/v1/confirm-your-email',
        email: 'userone@selvin.co',
        username: 'userone',
        firstName: 'User',
        lastName: 'One',
        address1: '123 One St',
        address2: '',
        city: 'Blaine',
        state: 'MN',
        zip: '55113',
        country: 'us',
        signingUp: false,
        errors: {},
        _token: {},
        _stripe: {},
        _card: {}
    },
    computed: {
        inUs() {
            return this.country.toLowerCase() === 'us';
        },
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
        this._stripe = Stripe(stripePublishableKey);
        this._card = this._stripe.elements(stripeElementFont).create('card', stripeElementConfig);

        this._card.mount('#card-element');

        window.addEventListener('resize', (e) => {
            this.updateCardStyle();
        });

        this.updateCardStyle();
    },
    methods: {
        updateCardStyle() {
            if (window.innerWidth <= 768) {
                this._card.update({style: {base: {fontSize: '1rem'}}});
            } else {
                this._card.update({style: {base: {fontSize: '1.75rem'}}});
            }
        },
        checkout() {
            let app = this;
            this.signingUp = true;
            this._stripe.createToken(this._card, {
                name: app.name,
                address_country: this.country,
                address_line1: this.address1,
                address_city: this.city,
                address_state: this.state,
                address_zip: this.zip
            }).then(function(result) {
                if (result.error) {
                    // Inform the user if there was an error
                    let errorElement = document.getElementById('card-errors');
                    errorElement.textContent = result.error.message;
                } else {
                    // Send the token to your server
                    app._token = result.token;
                    app.sendCheckoutForm();
                }
            });
        },
        sendCheckoutForm() {

        },
        validateEmail() {
            let app = this;
            let validate = _.debounce(() => {
                Axios.post('/actions/swipe/users/validate-email', {email: app.email}, axiosConfig)
                .then(
                    (response) => {
                        if (!response.data.success) {
                            app.error('email', response.data.message);
                        }

                        app.error('email', '');
                    },
                    (response) => {
                        app.error('email', 'Unable to validate email');
                    }
                );
            }, 500);

            return validate();
        },
        validateUsername() {
            let app = this;
            let validate = _.debounce(() => {
                if (this.username.len < 5) {
                    return;
                }
                Axios.post('/actions/swipe/users/validate-username', {username: app.username}, axiosConfig)
                .then(
                    (response) => {
                        if (!response.data.success) {
                            app.error('username', response.data.message);
                        }

                        app.error('username', '');
                    },
                    (response) => {
                        app.error('username', 'Unable to validate username');
                    }
                );
            }, 500);

            return validate();
        },
        error(field, error = '', remove = false) {
            if (error !== '') {
                this.$set(this.errors, field, error);
            } else if (remove !== false) {
                this.$delete(this.errors, field);
            } else {
                return (this.errors.hasOwnProperty(field) && this.errors[field] !== '');
            }
        },
        us(value, optional = '') {
            return this.country.toLowerCase() === 'us' ? value : optional;
        }
    }
});
