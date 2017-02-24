'use strict';

let Axios = require('axios');
let Vue = require('vue/dist/vue.js');

let axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue
    }
};

let style = {
  base: {
    color: '#32325d',
    lineHeight: '24px',
    fontFamily: 'Helvetica Neue',
    fontSmoothing: 'antialiased',
    fontSize: '16px',
    '::placeholder': {
      color: '#aab7c4'
    }
  },
  invalid: {
    color: '#fa755a',
    iconColor: '#fa755a'
  }
};

let signup_vm = new Vue({
    el: '#signup',
    delimiters: ['@{', '}'],
    data: {
        email: '',
        username: '',
        firstName: '',
        lastName: '',
        signingUp: false,
    },
    methods: {
        submitForm() {
            this.stripe.createToken(card).then(function(result) {
                if (result.error) {
                // Inform the user if there was an error
                var errorElement = document.getElementById('card-errors');
                errorElement.textContent = result.error.message;
                } else {
                // Send the token to your server
                stripeTokenHandler(result.token);
                }
            });
        },
        validateUsername() {
            console.log('Invalid');
        }
    }
});


var stripe = Stripe('pk_test_6pRNASCoBOKtIshFeQd4XMUh');

// Create an instance of Elements
var elements = stripe.elements();

// Custom styling can be passed to options when creating an Element.
// (Note that this demo uses a wider set of styles than the guide below.)

// Create an instance of the card Element
var card = elements.create('card', {style: style});

// Add an instance of the card Element into the `card-element` <div>
card.mount('#card-element');

// Handle real-time validation errors from the card Element.
card.addEventListener('change', function(event) {
  const displayError = document.getElementById('card-errors');
  if (event.error) {
    displayError.textContent = event.error.message;
  } else {
    displayError.textContent = '';
  }
});
