#!/bin/bash

# Function to check if package.json exists
check_package_json() {
  if [ ! -f "package.json" ]; then
    echo "Error: package.json not found! Please run this script in the root of a Node.js project."
    exit 1
  fi
}

# Function to check if jq is installed
check_jq_installed() {
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq and try again."
    exit 1
  fi
}

# Function to install the required packages using npm or pnpm
install_linter_packages() {
  if command -v pnpm &> /dev/null; then
    echo "Installing packages with pnpm..."
    pnpm add eslint@^8.57.0 eslint-config-airbnb@^19.0.4 eslint-config-airbnb-typescript@^18.0.0 eslint-config-prettier@^9.1.0 eslint-plugin-import@^2.29.1 eslint-plugin-jsx-a11y@^6.9.0 eslint-plugin-prettier@^5.2.1 eslint-plugin-react@^7.35.0 eslint-plugin-react-hooks@^4.6.2 eslint-plugin-react-refresh@^0.4.9 -D
  elif command -v npm &> /dev/null; then
    echo "Installing packages with npm..."
    npm install eslint@^8.57.0 eslint-config-airbnb@^19.0.4 eslint-config-airbnb-typescript@^18.0.0 eslint-config-prettier@^9.1.0 eslint-plugin-import@^2.29.1 eslint-plugin-jsx-a11y@^6.9.0 eslint-plugin-prettier@^5.2.1 eslint-plugin-react@^7.35.0 eslint-plugin-react-hooks@^4.6.2 eslint-plugin-react-refresh@^0.4.9 -D
  else
    echo "Error: Neither npm nor pnpm is installed."
    exit 1
  fi
}

# Function to create the .eslintrc.cjs file
create_eslintrc_config() {
  echo "Creating .eslintrc.cjs..."
  cat <<'EOF' > .eslintrc.cjs
const a11yOff = Object.keys(require("eslint-plugin-jsx-a11y").rules).reduce(
  (acc, rule) => {
    acc[`jsx-a11y/${rule}`] = "off";
    return acc;
  },
  {},
);
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    "airbnb",
    "airbnb-typescript",
    "airbnb/hooks",
    "plugin:@typescript-eslint/recommended",
    "prettier",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaFeatures: { jsx: true },
    ecmaVersion: 13,
    sourceType: "module",
    tsconfigRootDir: __dirname,
    project: ["./tsconfig.json", "./tsconfig.app.json", "./tsconfig.node.json"],
  },
  plugins: ["react-refresh", "@typescript-eslint"],
  ignorePatterns: [".eslintrc.*", "vite.config.*"],
  rules: {
    ...a11yOff,
    "import/no-extraneous-dependencies": ["error", { devDependencies: true }],
    "no-plusplus": ["error", { allowForLoopAfterthoughts: true }],
    "symbol-description": "off",
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "react/button-has-type": "off",
    "react/function-component-definition": "off",
    "react/no-unescaped-entities": "off",
    "react/require-default-props": "off",
    "consistent-return": "off",
    "guard-for-in": "off",
    "no-restricted-syntax": "off",
    "padding-line-between-statements": ["error", {
      blankLine: "always",
      prev: "*",
      next: [
        "if",
        "for",
        "return",
        "block-like",
        "multiline-const",
        "multiline-expression",
        "export",
      ],
    }, {
      blankLine: "never",
      prev: ["singleline-const", "singleline-let", "singleline-var"],
      next: ["singleline-const", "singleline-let", "singleline-var"],
    }, {
      blankLine: "always",
      prev: [
        "multiline-const",
        "multiline-let",
        "multiline-var",
        "multiline-expression",
      ],
      next: "*",
    }],
  },
};
EOF
}

# Function to rename all files containing "eslint" in the name to .lod
rename_eslint_files() {
  echo "Renaming all files with 'eslint' in the name to .lod..."
  find . -maxdepth 1 -type f -iname "*eslint*" ! -iname ".eslintrc.cjs" \
    -exec sh -c 'mv "$1" "$1.old"' _ {} \;
  echo "Renamed all ESLint-related files."
}

# Function to add linting and formatting scripts to package.json
add_scripts_to_package_json() {
  echo "Adding linting and formatting scripts to package.json..."
  jq '.scripts += {
    "lint:fix": "eslint --fix ./src",
    "lint:check": "eslint ./src",
    "format": "dprint fmt"
  }' package.json > package.json.tmp && mv package.json.tmp package.json
  echo "Scripts added to package.json."
}

# Main script execution
main() {
  check_package_json
  check_jq_installed
  install_linter_packages
  create_eslintrc_config
  rename_eslint_files
  add_scripts_to_package_json
  echo "Linting setup complete."
}

# Run the main function
main
