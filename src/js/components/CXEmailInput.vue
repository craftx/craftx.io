<template>
    <div class="is-control-container">
        <p class="control">
            <label class="label">Email</label>
            <input
                type="email"
                name="email"
                class="input is-medium"
                autocomplete="off"
                required
                :placeholder="placeholder"
                v-model="email"
                @keyup="validate"
            >
            <span class="help" v-if="hint">{{ hint }}</span>
        </p>
    </div>
</template>

<script>
    import {postToController, debounce} from '../Utils';

    export default {
        props: ['value', 'placeholder'],
        data() {
            return {
                busy: false,
                hint: '',
                label: '',
                email: this.value
            }
        },
        methods: {
            validate() {
                let vm = this;

                debounce(() => {
                    if (vm.email.length < 5) { return; }
                    if (!vm.busy) {
                        vm.busy = true;
                        postToController(
                            'swipe/users/validate-email',
                            {
                                email: vm.email
                            },
                            (response) => {
                                vm.hint = response.data.message;
                                vm.busy = false;
                            },
                            (response) => {
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
