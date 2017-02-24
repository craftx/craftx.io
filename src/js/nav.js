'use strict';

let Vue = require('vue/dist/vue.js');

let nav_vm = new Vue({
    el: '#nav',
    data: {
        mobileNavIsActive: false
    },
    methods: {
        toggleMobileNav() {
            this.mobileNavIsActive = !this.mobileNavIsActive;
        }
    }
});
