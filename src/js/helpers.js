let Alert = require('sweetalert');

module.exports = {
    __yay(title, message) {
        Alert({
            title: title,
            text: message,
            type: "success",
            confirmButtonColor: '#00966c'
        });
    },
    __nay(title, message) {
        Alert({
            title: title,
            text: message,
            type: "error",
            confirmButtonColor: '#00966c'
        });
    }
}
