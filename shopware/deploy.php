<?php

namespace Deployer;

require_once 'recipe/common.php';
require_once 'contrib/cachetool.php';
require 'contrib/rsync.php';


use Symfony\Component\Console\Output\OutputInterface;

set('verbosity', OutputInterface::VERBOSITY_QUIET); // controls output verbosity
set('bin/console', '{{bin/php}} {{release_or_current_path}}/bin/console');
set('cachetool', '/run/php/php-fpm.sock');
set('application', 'Shopware 6');
set('allow_anonymous_stats', false);
set('default_timeout', 3600); // Increase when tasks take longer than that.
set('rsync_src', dirname(__FILE__));

// Hosts
host('staging')
    ->setHostname('157.230.14.200')
    ->setLabels([
        'type' => 'web',
        'stage' => 'staging',
        'env' => 'prod',
    ])
    ->setRemoteUser('www-data')
    ->set('deploy_path', '/var/www/nirvana')
    ->set('http_user', 'www-data') // Not needed, if the `user` is the same, the webserver is running with
    ->set('writable_mode', 'chmod')
    ->set('keep_releases', 3) // Keeps 3 old releases for rollbacks (if no DB migrations were executed)
    ->set('php_version', '8.2');

// These files are shared among all releases.
set('shared_files', [
    '.env.local',
    'install.lock',
    'public/.htaccess',
    'public/.user.ini',
]);

// These directories are shared among all releases.
set('shared_dirs', [
    'config/jwt',
    'files',
    'var/log',
    'public/media',
    'public/thumbnail',
    'public/sitemap',
]);

// These directories are made writable (the definition of "writable" requires attention).
// Please note that the files in `config/jwt/*` receive special attention in the `sw:writable:jwt` task.
set('writable_dirs', [
    'config/jwt',
    'custom/plugins',
    'files',
    'public/bundles',
    'public/css',
    'public/fonts',
    'public/js',
    'public/media',
    'public/sitemap',
    'public/theme',
    'public/thumbnail',
    'var',
]);

task('sw:deployment:helper', static function () {
    run('cd {{release_path}} && vendor/bin/shopware-deployment-helper run');
});

task('sw:build:storefront', static function () {
    run('cd {{release_path}} && ./bin/build-storefront.sh');
});

task('sw:build:administration', static function () {
    run('cd {{release_path}} && ./bin/build-administration.sh');
});

task('sw:touch_install_lock', static function () {
    run('cd {{release_path}} && touch install.lock');
});

task('sw:health_checks', static function () {
    run('cd {{release_path}} && bin/console system:check --context=pre_rollout');
});

desc('Deploys Nirvana');
task('deploy', [
    'deploy:prepare',
    'deploy:clear_paths',
    'sw:deployment:helper',
    'sw:build:administration',
    'sw:build:storefront',
    "sw:touch_install_lock",
    'sw:health_checks',
    'deploy:publish',
]);

Deployer::get()->tasks->remove('deploy:update_code');
task('deploy:update_code', [
    'rsync',
]);

// Configure rsync settings
set('rsync', [
    'exclude' => [
        '.git',
        '.gitignore',
        'deploy.php',
        'ecs.php',
        '.eslintrc*',
        'phpstan.neon',
        '.stylelintrc*',
        '.babelrc*',
        'phpunit.dist.xml',
        'var/cache',
        'var/logs',
        'composer.lock',
        '.env.local',
        '.env.test',
        'tests/',
        'README.md',
    ],
    'exclude-file' => false,
    'include' => [],
    'include-file' => false,
    'filter' => [],
    'filter-file' => false,
    'filter-perdir' => false,
    'flags' => 'rzcEl',          // r=recursive, z=compress, c=checksum, E=preserve executability, l=copy symlinks
    'options' => ['delete', 'delete-after', 'force'], //Delete after successful transfer, delete even if deleted dir is not empty
    'timeout' => 600,            // 1 minute timeout
]);

task('deploy:update_code')->desc('Upload source code to remote server');

// Hooks
after('deploy:failed', 'deploy:unlock');
after('deploy:symlink', 'cachetool:clear:opcache');