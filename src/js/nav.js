'use strict';

import Vue from 'vue';

export default new Vue({
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
