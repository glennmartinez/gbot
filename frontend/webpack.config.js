var packageJSON = require('./package.json');
var path = require('path');
var webpack = require('webpack');

const PATHS = {
    build: path.join(__dirname, 'target', 'classes', 'META-INF', 'resources', 'webjars', packageJSON.name, packageJSON.version)
};

const FILENAME = process.env.NODE_ENV === 'development' ? '../public/js/bundle.js' : '../public/js/bundle.js';

module.exports = {
    entry: './index.js',

    output: {
        path: __dirname,
        filename: FILENAME
    },

    module: {
        loaders: [
            {
                test: path.join(__dirname, '.'),
                exclude: /(node_modules)/,
                loader: 'babel-loader',
                query: {
                    cacheDirectory: true,
                    presets: ['es2015', 'react']
                }
            },
            { test: /\.scss$/,loaders: ["style", "css", "sass"]},
            { test: /\.css$/, loader: "style-loader!css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]" },
            { test: /\.png$/, loader: "url-loader?limit=100000" },
            { test: /\.jpg$/, loader: "file-loader" }
        ]

    }
};