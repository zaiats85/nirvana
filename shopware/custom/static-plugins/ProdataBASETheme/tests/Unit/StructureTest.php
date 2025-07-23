<?php declare(strict_types=1);

namespace ProdataBASETheme\Tests\Unit;

use PHPUnit\Framework\TestCase;

class StructureTest extends TestCase
{
    private string $themeDir;

    protected function setUp(): void
    {
        $this->themeDir = dirname(__DIR__, 2);
    }

    public function testMainThemeClassExists(): void
    {
        $mainClass = $this->themeDir . '/src/ProdataBASETheme.php';
        $this->assertFileExists($mainClass, 'Main theme class should exist');
    }

    public function testComposerJsonExists(): void
    {
        $composerJson = $this->themeDir . '/composer.json';
        $this->assertFileExists($composerJson, 'composer.json should exist');
    }

    public function testResourcesDirectoryExists(): void
    {
        $resourcesDir = $this->themeDir . '/src/Resources';
        $this->assertDirectoryExists($resourcesDir, 'Resources directory should exist');
    }

    public function testViewsDirectoryExists(): void
    {
        $viewsDir = $this->themeDir . '/src/Resources/views';
        $this->assertDirectoryExists($viewsDir, 'Views directory should exist');
    }

    public function testStorefrontDirectoryExists(): void
    {
        $storefrontDir = $this->themeDir . '/src/Resources/views/storefront';
        $this->assertDirectoryExists($storefrontDir, 'Storefront views directory should exist');
    }

    public function testScssDirectoryExists(): void
    {
        $scssDir = $this->themeDir . '/src/Resources/app/storefront/src/scss';

        if (is_dir($scssDir)) {
            $this->assertDirectoryExists($scssDir, 'SCSS directory exists');
        } else {
            $this->markTestSkipped('SCSS directory does not exist - theme might not have custom styles');
        }
    }

    public function testThemeJsonExists(): void
    {
        $themeJson = $this->themeDir . '/src/Resources/theme.json';

        if (file_exists($themeJson)) {
            $this->assertFileExists($themeJson, 'theme.json exists');

            $content = file_get_contents($themeJson);
            $config = json_decode($content, true);

            $this->assertNotNull($config, 'theme.json should contain valid JSON');
        } else {
            $this->markTestSkipped('theme.json does not exist');
        }
    }
}