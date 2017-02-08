var app = new Vue({
    el: '#app',
    data: {
        mobileNavIsActive: false
    },
    methods: {
        toggleMobileNav: function() {
            this.mobileNavIsActive = !this.mobileNavIsActive;
        }
    }
});
