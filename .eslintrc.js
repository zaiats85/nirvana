module.exports = {
    extends: ['@shopware-ag/eslint-config-base'],
    parserOptions: {
        requireConfigFile: false
    },
    settings: {
        'import/resolver': {
            alias: {
                map: [
                    ['src', './vendor/shopware/storefront/Resources/app/storefront/src'],
                    ['@storefront', './vendor/shopware/storefront/Resources/app/storefront/src']
                ],
                extensions: ['.js', '.json']
            }
        }
    },
    rules: {
        'import/no-unresolved': 'off',
        'import/no-import-module-exports': 'off',
        'no-console': 'off' // error to check
    },
    globals: {
        PluginManager: 'readonly',
        window: 'readonly'
    },
    ignorePatterns: [
        'vendor/**',
        'var/**',
        'node_modules/**',
        '**/dist/**',
        'custom/**/dist/**'
    ]
};