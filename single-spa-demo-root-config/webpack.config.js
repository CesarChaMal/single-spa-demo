const path = require("path");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = env => ({
  entry: path.resolve(__dirname, "src/root-config"),
  output: {
    filename: "root-config.js",
    libraryTarget: "system",
    path: path.resolve(__dirname, "dist")
  },
  devtool: "source-map",
  module: {
    rules: [
      { parser: { system: false } },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [{ loader: "babel-loader" }]
      }
    ]
  },
  devServer: {
    historyApiFallback: true,
    headers: {
      "Access-Control-Allow-Origin": "*"
    },
    allowedHosts: "all"
  },
  plugins: [
    new HtmlWebpackPlugin({
      inject: false,
      template: "src/index.ejs",
      templateParameters: {
        isLocal: env && env.isLocal === "true",
        importmapUrl: process.env.IMPORTMAP_URL || 'https://single-spa-demo-774145483743.s3.eu-central-1.amazonaws.com/@cesarchamal/importmap.json'
      }
    }),
    new CleanWebpackPlugin()
  ],
  externals: ["single-spa", /^@cesarchamal\/.+$/]
});
