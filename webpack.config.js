const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

const cssExtractor = new ExtractTextPlugin('styles.css');
const htmlExtractor = new ExtractTextPlugin('index.html');
const bowerResolver = new webpack.ResolverPlugin(new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin('.bower.json', ['main']));

module.exports = {

  context: path.resolve('source'),

  entry: {
    app: './app/index.js',
  },

  output: {
    path: path.resolve('dist'),
    publicPath: '/assets',
    filename: 'app.js',
  },

  plugins: [
    cssExtractor,
    htmlExtractor,
    bowerResolver,
  ],

  devServer: {
    contentBase: './source/',
  },

  module: {
    preLoaders: [
      {
        test: /\.js$/,
        loader: 'eslint-loader',
        exclude: /node_modules|bower_components/,
      },
    ],
    loaders: [
      {
        test: /\.css$/,
        exclude: /node_modules|bower_components/,
        loader: cssExtractor.extract('style', 'css'),
      },
      {
        test: /\.scss$/,
        exclude: /node_modules|bower_components/,
        loader: cssExtractor.extract('style-loader', 'css-loader!sass-loader'),
      },
      {
        test: /\.html$/,
        exclude: /node_modules|bower_components/,
        loader: htmlExtractor.extract('html-loader!html-minify-loader'),
      },
      {
        test: /\.js$/,
        exclude: /node_modules|bower_components/,
        loader: 'babel-loader',
      },
      {
        test: /\.(png|jpg)$/,
        exclude: /node_modules|bower_components/,
        loader: 'file-loader',
      },
      {
        test: /\.(woff2|woff)$/,
        loader: 'url-loader?limit=100000',
      },
      {
        test: /\.(ttf|eot|svg)$/,
        loader: 'file-loader',
      },
      {
        test: /bower_components(\/|\\)(PreloadJS|SoundJS|EaselJS|TweenJS)(\/|\\).*\.js$/,
        loader: 'imports?this=>window!exports?window.createjs',
      },
    ],
  },

  resolve: {
    extensions: ['', '.css', '.scss', '.html', '.js'],
    modulesDirectories: ['node_modules', 'bower_components'],
  },

  eslint: {
    configFile: '.eslintrc',
  },

};
