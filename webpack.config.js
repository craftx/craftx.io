let webpack = require('webpack');

module.exports = {
    entry: {
        App: './src/js/App.js',
        Join: './src/js/Join.js',
        Index: './src/js/Index.js',
        Player: './src/js/Player.js'
    },
    output: {
        path: __dirname + '/web/webpack',
        filename: '[name].bundle.js'
    },
    externals: {
        stripe: 'Stripe'
    },
    resolve: {
        alias: {
            'vue$': 'vue/dist/vue.esm.js'
        }
    },
    module: {
        rules: [
            {test: /\.vue/, exclude: /node_modules/, use: 'vue-loader'},
            {test: /\.js/, exclude: /node_modules/, use: 'babel-loader'}
        ]
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                'NODE_ENV': JSON.stringify('production')
            }
        })
    ]
}
