<?php

namespace ProdataBASETheme\Tests\Unit;

use PHPUnit\Framework\TestCase;

class ComposerJsonTest extends TestCase
{
    private array $composerData;

    protected function setUp(): void
    {
        // project-root/
        //   ├── composer.json
        //   └── tests/Unit/ComposerJsonTest.php
        $composerJsonPath = __DIR__ . '/../../composer.json';

        $this->assertFileExists($composerJsonPath, 'composer.json file must exist');

        $composerContent = file_get_contents($composerJsonPath);
        $this->composerData = json_decode($composerContent, true);

        $this->assertIsArray($this->composerData, 'composer.json must contain valid JSON');
    }

    public function testComposerNameExists(): void
    {
        $this->assertArrayHasKey('name', $this->composerData, 'composer.json must have a "name" field');
        $this->assertNotEmpty($this->composerData['name'], 'composer.json "name" field cannot be empty');
        $this->assertIsString($this->composerData['name'], 'composer.json "name" must be a string');
    }

    public function testComposerDescriptionExists(): void
    {
        $this->assertArrayHasKey('description', $this->composerData, 'composer.json must have a "description" field');
        $this->assertNotEmpty($this->composerData['description'], 'composer.json "description" field cannot be empty');
        $this->assertIsString($this->composerData['description'], 'composer.json "description" must be a string');
    }

    public function testVersionExists(): void
    {
        $this->assertArrayHasKey('version', $this->composerData, 'composer.json must have a "version" field');
        $this->assertNotEmpty($this->composerData['version'], 'composer.json "version" field cannot be empty');
        $this->assertIsString($this->composerData['version'], 'composer.json "version" must be a string');

        // Optional: validate version format (semantic versioning)
        $this->assertMatchesRegularExpression(
            '/^\d+\.\d+\.\d+(-[a-zA-Z0-9\-]+)?(\+[a-zA-Z0-9\-]+)?$/',
            $this->composerData['version'],
            'Version must follow semantic versioning format (e.g., 1.0.0, 1.0.0-alpha, 1.0.0+build)'
        );
    }
}