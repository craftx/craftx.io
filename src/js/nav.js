'use strict';

let Vue = require('vue/dist/vue.min.js');

let navVM = new Vue({
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
