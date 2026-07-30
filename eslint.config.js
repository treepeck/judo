// Recommended JS rules from ESLint team.
import js from "@eslint/js"
// Global variables defined by browser so that ESLint can see them.
import globals from "globals"
// Disables ESLint rules that would conflict with Prettier code formatter.
import eslintConfigPrettier from "eslint-config-prettier"

export default [
  {
    ignores: [
      "node_modules/**"
    ]
  },

  js.configs.recommended,

  {
    languageOptions: {
      globals: {
        ...globals.browser
      }
    },
    // Custom rules.
    rules: {
      "eqeqeq": "error",       // Require === instead of ==.
      "curly": "error",        // Require braces around if/for/while.
      "no-var": "error",       // Require let/const.
      "prefer-const": "error"  // Use const when possible.
    }
  },

  eslintConfigPrettier
]
