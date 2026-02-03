import webpack from "webpack"
import { glob } from "node:fs/promises"
import MiniCssExtractPlugin from "mini-css-extract-plugin"

const scripts = []
for await (const entry of glob("./scripts/**/*.js")) {
	scripts.push("./" + entry)
}

const css = []
for await (const entry of glob("./css/**/*.css")) {
	css.push("./" + entry)
}

export default {
	mode: "development",
	entry: [...scripts, ...css],
	output: {
		path: "/app/bundles",
		filename: "bundle.js",
		publicPath: "/bundles",
	},
	module: {
		rules: [
			{
				test: /\.css$/i,
				use: [
					MiniCssExtractPlugin.loader,
					{
						loader: "css-loader",
						options: {
							url: false,
						},
					}
				],
			}
		],
	},
	plugins: [
		new MiniCssExtractPlugin({
			filename: "bundle.css",
		}),
		new webpack.DefinePlugin({
			"API_URL": JSON.stringify("http://localhost:3502"),
			"WS_URL": JSON.stringify("ws://localhost:3502"),
		}),
	],
}