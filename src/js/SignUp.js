'use strict';

import Stripe from 'stripe';
import Vue from 'vue';

import {postToController} from './Utils';

import CXEmailInput from './components/CXEmailInput.vue';
import CXCouponInput from './components/CXCouponInput.vue';
import CXUsernameInput from './components/CXUsernameInput.vue';

const stripeElementConfig = {
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

const stripeElementFont = {
    fonts: [{
        family: 'Fira Sans',
        weight: 300,
        src: 'local("Fira Sans"), url("https://craftx.io/dist/fonts/firasans-regular.woff2") format("woff2"), url("https://craftx.io/dist/fonts/firasans-regular.woff") format("woff")',
    }],
};

const stripePublishableKey = 'pk_test_ivZFpjEGRxj38UYz4CYQUk4t';

export default new Vue({
    el: '#signup',
    delimiters: ['@{', '}'],
    components: {
        cxEmail: CXEmailInput,
        cxUsername: CXUsernameInput,
        cxCoupon: CXCouponInput
    },
    data: {
        action: 'users/save-user',
        redirect: '/v1/confirm-your-email',
        email: '',
        username: '',
        password: '',
        firstName: '',
        lastName: '',
        address1: '',
        address2: '',
        city: '',
        state: '',
        zip: '',
        countryCode: 'us',
        planId: 'CRAFTXDEVMONTHLY',
        coupon: '',
        signingUp: false,
        applyingCoupon: false,
        hints: {},
        token: '{}',
        _stripe: {},
        _card: {}
    },
    computed: {
        inUs() {
            return this.countryCode.toLowerCase() === 'us';
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
        this.$nextTick(() => {
            this._stripe = Stripe(stripePublishableKey);
            this._card = this._stripe.elements(stripeElementFont).create('card', stripeElementConfig);

            this._card.mount('#card-element');

            window.addEventListener('resize', () => {
                this.updateCardStyle();
            });

            this.updateCardStyle();
        }, this);
    },
    methods: {
        applyCoupon() {
            let app = this;
            if (this.coupon.length < 6) {
                return app.hint('coupon', 'Invalid coupon');
            }

            this.applyingCoupon = true;
            postToController(
                'swipe/plans/get-coupon',
                {coupon: app.coupon, plan: app.planId},
                (response) => {
                    this.applyingCoupon = false;
                    return app.hint('coupon', response.data.message);
                },
                (response) => {
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
        checkout(ev) {
            let app = this;
            this.signingUp = true;
            this._stripe.createToken(this._card, {
                name: app.name,
                address_country: this.countryCode,
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
                    app.token = JSON.stringify(result.token);
                    ev.target.submit(); // app.sendCheckoutForm();
                }
            });
        },
        sendCheckoutForm() {
            let app = this;
            let params = {
                firstName: app.firstName,
                lastName: app.lastName,
                email: app.email,
                username: app.username,
                password: app.password,
                planId: app.planId,
                coupon: app.coupon,
                fields: {
                    billingEmail: app.email,
                    billingAddress1: app.address1,
                    billingAddress2: app.address2,
                    billingCity: app.city,
                    billingState: app.state,
                    billingCountryCode: app.countryCode,
                    billingZip: app.zip,
                    subscriptionJson: app.token
                }
            };

            let signUp = debounce(() => {
                postToController(
                    'swipe/users/save-user',
                    params,
                    (response) => {
                        // console.log(response.data);
                    },
                    (response) => {
                        // console.log(response.data);
                    }
                );
            }, 500);

            return signUp();
        },
        validateEmail() {
            let app = this;
            let validate = _.debounce(() => {
                postToController(
                    'swipe/users/validate-email',
                    {email: app.email},
                    (response) => {
                        if (!response.data.success) {
                            app.hint('email', response.data.message);
                        }

                        app.hint('email', '');
                    },
                    (response) => {
                        app.hint('email', 'Unable to validate email');
                    }
                );
            }, 500);

            return validate();
        },
        validateUsername() {
            let app = this;
            let validate = debounce(() => {
                if (this.username.length < 5) {
                    return;
                }
                postToController(
                    'swipe/users/validate-username',
                    {username: app.username},
                    (response) => {
                        if (!response.data.success) {
                            app.hint('username', response.data.message);
                        }

                        app.hint('username', '');
                    },
                    (response) => {
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
            return this.countryCode.toLowerCase() === 'us' ? value : optional;
        }
    }
});
