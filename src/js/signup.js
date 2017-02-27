'use strict';

let Helpers = require('./helpers');
let Vue = require('vue/dist/vue.min.js');
let _ = require('lodash');

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
};

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
        planId: 'CRAFTXDEVMONTHLY',
        coupon: '',
        signingUp: false,
        applyingCoupon: false,
        hints: {},
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

        window.addEventListener('resize', () => {
            this.updateCardStyle();
        });

        this.updateCardStyle();
    },
    methods: {
        applyCoupon() {
            let app = this;
            if (this.coupon.length < 6) {
                return app.hint('coupon', 'Invalid coupon');
            }

            this.applyingCoupon = true;
            Helpers.__post(
                '/actions/swipe/plans/get-coupon',
                {coupon: app.coupon, plan: app.planId},
                (response) => {
                    this.applyingCoupon = false;
                    return app.hint('coupon', response.data.message);
                },
                (response) => {
                    console.log(response);
                    this.applyingCoupon = false;
                    return app.hint('coupon', 'Unable to verify the coupon');
                }
            );
        },
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
                Helpers.__post(
                    '/actions/swipe/users/validate-email',
                    {email: app.email},
                    (response) => {
                        if (!response.data.success) {
                            app.hint('email', response.data.message);
                        }

                        app.hint('email', '');
                    },
                    (response) => {
                        console.log(response);
                        app.hint('email', 'Unable to validate email');
                    }
                );
            }, 500);

            return validate();
        },
        validateUsername() {
            let app = this;
            let validate = _.debounce(() => {
                if (this.username.length < 5) {
                    return;
                }
                Helpers.__post(
                    '/actions/swipe/users/validate-username',
                    {username: app.username},
                    (response) => {
                        if (!response.data.success) {
                            app.hint('username', response.data.message);
                        }

                        app.hint('username', '');
                    },
                    (response) => {
                        console.log(response);
                        app.hint('username', 'Unable to validate username');
                    }
                );
            }, 500);

            return validate();
        },
        hint(field, error = '', remove = false) {
            if (error !== '') {
                this.$set(this.hints, field, error);
            } else if (remove !== false) {
                this.$delete(this.hints, field);
            } else {
                return (this.hints.hasOwnProperty(field) && this.hints[field] !== '');
            }
        },
        us(value, optional = '') {
            return this.country.toLowerCase() === 'us' ? value : optional;
        }
    }
});
