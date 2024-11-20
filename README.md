# Formatting and Linting config

## Install dprint on your machine.

Install using one of the methods below.

- Shell (Mac, Linux, WSL):

```shell
curl -fsSL https://dprint.dev/install.sh | sh
```

- Homebrew (Mac):

```shell
brew install dprint
```

## Configure your IDE to use dprint as the default formatter.

Editor Extensions

- [IntelliJ](https://plugins.jetbrains.com/plugin/18192-dprint)
- [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=dprint.dprint)

## Use the provided dprint.json config.

```json
{
  "extends": [
    "https://raw.githubusercontent.com/m-pot/lint/refs/heads/master/dprint.json"
  ]
}
```

## Install the necessary packages for linting.

- npm

```shell
npm install eslint@^8.57.0 eslint-config-airbnb@^19.0.4 eslint-config-airbnb-typescript@^18.0.0 eslint-config-prettier@^9.1.0 eslint-plugin-import@^2.29.1 eslint-plugin-jsx-a11y@^6.9.0 eslint-plugin-prettier@^5.2.1 eslint-plugin-react@^7.35.0 eslint-plugin-react-hooks@^4.6.2 eslint-plugin-react-refresh@^0.4.9 -D
```

- pnpm

```shell
pnpm add eslint@^8.57.0 eslint-config-airbnb@^19.0.4 eslint-config-airbnb-typescript@^18.0.0 eslint-config-prettier@^9.1.0 eslint-plugin-import@^2.29.1 eslint-plugin-jsx-a11y@^6.9.0 eslint-plugin-prettier@^5.2.1 eslint-plugin-react@^7.35.0 eslint-plugin-react-hooks@^4.6.2 eslint-plugin-react-refresh@^0.4.9 -D
```

## Use the provided .eslintrc.cjs config file.

```javascript
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
    project: ["./tsconfig.json"],
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
```

## Add these scripts to your package.json to lint and format your code.

```json5
{
  "scripts": {
    // ... Rest of your scripts
    
    "lint:fix": "eslint --fix ./src",
    "lint:check": "eslint ./src",
    "format": "dprint fmt"
  }
}
```
