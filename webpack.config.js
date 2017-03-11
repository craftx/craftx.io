module.exports = {
    entry: {
        App: './src/js/App.js',
        Join: './src/js/Join.js',
        Homepage: './src/js/Homepage.js'
    },
    output: {
        path: './web/webpack',
        filename: '[name].bundle.js'
    },
    externals: {
        stripe: 'Stripe'
    },
    resolve: {
        alias: {
            'vue$': 'vue/dist/vue.js'
        }
    },
    module: {
        rules: [
            {test: /\.vue/, exclude: './node_modules', use: 'vue-loader'},
            {test: /\.js/, exclude: './node_modules', use: 'babel-loader'}
        ]
    }
}
