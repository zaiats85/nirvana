<?php declare(strict_types=1);

namespace ProdataBASETheme;

use Shopware\Core\Framework\Plugin;
use Shopware\Storefront\Framework\ThemeInterface;

class ProdataBASETheme extends Plugin implements ThemeInterface
{
    public const PLUGIN_CONFIG = 'ProdataBASETheme.config.';

    public function getThemeConfigPath(): string
    {
        return 'theme.json';
    }
}
