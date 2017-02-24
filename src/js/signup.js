'use strict';

let Axios = require('axios');
let Vue = require('vue/dist/vue.js');

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
        name: '',
        email: '',
        username: '',
        firstName: 'Jack',
        lastName: '',
        signingUp: false,
    },
    methods: {
        onNameChange() {
            if (this.name !== '') {
                let name = this.name.split(' ');

                this.firstName = name.slice(0, -1).join(' ');
                this.lastName = name.slice(-1).join(' ');
            }
        },
        validateUsername() {
            console.log('Invalid');
        }
    }
});
