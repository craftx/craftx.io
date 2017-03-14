<template>
    <div class="is-control-container">
        <label class="label">Have a Coupon?</label>
        <div class="control is-grouped">
            <p class="control is-expanded">
                <input
                    type="text"
                    name="coupon"
                    class="input is-expanded is-large"
                    v-model="coupon"
                    placeholder="CRAFTXCOUPON"
                    autocomplete="off"
                    @keydown.enter="applyCoupon"
                    @keyup="setReady"
                >
                <span v-if="hint" class="help">{{ hint }}</span>
            </p>
            <p class="control">
                <button type="button" @click.prevent="applyCoupon" class="button is-primary" :class="{ 'is-loading': busy, 'is-disabled': !ready }">Apply</button>
            </p>
        </div>
    </div>
</template>

<script>
    import {postToController, debounce} from '../Utils';

    export default {
        props: ['value'],
        data() {
            return {
                ready: false,
                busy: false,
                hint: '',
                label: '',
                coupon: this.value
            }
        },
        methods: {
            setReady() {
                this.ready = !!this.coupon && this.coupon.length >= 5;
            },
            applyCoupon(event) {
                event.preventDefault();

                let vm = this;

                debounce(() => {
                    if (!!vm.coupon && vm.coupon.length < 5) {
                        vm.hint = 'Must be at least 5 characters long';
                        return;
                    }
                    if (!vm.busy) {
                        vm.busy = true;
                        postToController(
                            'swipe/plans/get-coupon',
                            {
                                coupon: vm.coupon
                            },
                            (response) => {
                                console.log(response.data.success ? 'Success' : 'Error');
                                vm.hint = response.data.message;
                                vm.busy = false;
                            },
                            (response) => {
                                console.log(response);
                                console.log('Error');
                                vm.hint = response.data.message;
                                vm.busy = false;
                            }
                        );
                    }
                }, 500)();
            }
        }
    }
</script>
