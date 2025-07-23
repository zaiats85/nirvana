<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\ArrayNotation\ArraySyntaxFixer;
use PhpCsFixer\Fixer\Basic\EncodingFixer;
use PhpCsFixer\Fixer\Casing\ConstantCaseFixer;
use PhpCsFixer\Fixer\Casing\LowercaseKeywordsFixer;
use PhpCsFixer\Fixer\Casing\MagicConstantCasingFixer;
use PhpCsFixer\Fixer\CastNotation\CastSpacesFixer;
use PhpCsFixer\Fixer\CastNotation\LowercaseCastFixer;
use PhpCsFixer\Fixer\CastNotation\ModernizeTypesCastingFixer;
use PhpCsFixer\Fixer\CastNotation\ShortScalarCastFixer;
use PhpCsFixer\Fixer\ClassNotation\ClassAttributesSeparationFixer;
use PhpCsFixer\Fixer\ClassNotation\OrderedClassElementsFixer;
use PhpCsFixer\Fixer\ClassNotation\VisibilityRequiredFixer;
use PhpCsFixer\Fixer\ConstantNotation\NativeConstantInvocationFixer;
use PhpCsFixer\Fixer\ControlStructure\ElseifFixer;
use PhpCsFixer\Fixer\ControlStructure\NoUselessElseFixer;
use PhpCsFixer\Fixer\ControlStructure\TrailingCommaInMultilineFixer;
use PhpCsFixer\Fixer\FunctionNotation\CombineNestedDirnameFixer;
use PhpCsFixer\Fixer\FunctionNotation\FopenFlagsFixer;
use PhpCsFixer\Fixer\FunctionNotation\MethodArgumentSpaceFixer;
use PhpCsFixer\Fixer\FunctionNotation\NativeFunctionInvocationFixer;
use PhpCsFixer\Fixer\FunctionNotation\NullableTypeDeclarationForDefaultNullValueFixer;
use PhpCsFixer\Fixer\FunctionNotation\VoidReturnFixer;
use PhpCsFixer\Fixer\Import\NoLeadingImportSlashFixer;
use PhpCsFixer\Fixer\Import\NoUnusedImportsFixer;
use PhpCsFixer\Fixer\Import\OrderedImportsFixer;
use PhpCsFixer\Fixer\Import\SingleLineAfterImportsFixer;
use PhpCsFixer\Fixer\LanguageConstruct\DirConstantFixer;
use PhpCsFixer\Fixer\LanguageConstruct\FunctionToConstantFixer;
use PhpCsFixer\Fixer\LanguageConstruct\IsNullFixer;
use PhpCsFixer\Fixer\Operator\ConcatSpaceFixer;
use PhpCsFixer\Fixer\Operator\OperatorLinebreakFixer;
use PhpCsFixer\Fixer\Operator\StandardizeNotEqualsFixer;
use PhpCsFixer\Fixer\Phpdoc\GeneralPhpdocAnnotationRemoveFixer;
use PhpCsFixer\Fixer\Phpdoc\NoSuperfluousPhpdocTagsFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocLineSpanFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocOrderFixer;
use PhpCsFixer\Fixer\PhpTag\FullOpeningTagFixer;
use PhpCsFixer\Fixer\PhpTag\NoClosingTagFixer;
use PhpCsFixer\Fixer\PhpUnit\PhpUnitConstructFixer;
use PhpCsFixer\Fixer\PhpUnit\PhpUnitDedicateAssertFixer;
use PhpCsFixer\Fixer\PhpUnit\PhpUnitDedicateAssertInternalTypeFixer;
use PhpCsFixer\Fixer\PhpUnit\PhpUnitMockShortWillReturnFixer;
use PhpCsFixer\Fixer\ReturnNotation\NoUselessReturnFixer;
use PhpCsFixer\Fixer\Strict\DeclareStrictTypesFixer;
use PhpCsFixer\Fixer\Strict\StrictComparisonFixer;
use PhpCsFixer\Fixer\StringNotation\SingleQuoteFixer;
use PhpCsFixer\Fixer\Whitespace\BlankLineBeforeStatementFixer;
use PhpCsFixer\Fixer\Whitespace\CompactNullableTypehintFixer;
use Symplify\EasyCodingStandard\Config\ECSConfig;

return ECSConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/custom/static-plugins',
        __DIR__ . '/public/index.php',
        __DIR__ . '/bin/console',
    ])

    // Essential prepared sets
    ->withPreparedSets(
        psr12: true,
        arrays: true,
        controlStructures: true,
        strict: true,
        spaces: true,
        namespaces: true,
        docblocks: true,
    )

    // High-value rules only (30 instead of 120+)
    ->withRules([
        // Modern PHP essentials
        ArraySyntaxFixer::class,
        DeclareStrictTypesFixer::class,
        VoidReturnFixer::class,
        NullableTypeDeclarationForDefaultNullValueFixer::class,

        // Code quality
        NoUnusedImportsFixer::class,
        StrictComparisonFixer::class,
        StandardizeNotEqualsFixer::class,
        SingleQuoteFixer::class,
        NoUselessReturnFixer::class,
        NoUselessElseFixer::class,

        // Organization
        OrderedImportsFixer::class,
        OrderedClassElementsFixer::class,
        PhpdocOrderFixer::class,
        VisibilityRequiredFixer::class,

        // Performance
        NativeFunctionInvocationFixer::class,
        NativeConstantInvocationFixer::class,
        FunctionToConstantFixer::class,
        CombineNestedDirnameFixer::class,
        DirConstantFixer::class,

        // Modern features
        TrailingCommaInMultilineFixer::class,
        ModernizeTypesCastingFixer::class,
        IsNullFixer::class,

        // Consistency
        EncodingFixer::class,
        ConstantCaseFixer::class,
        LowercaseKeywordsFixer::class,
        MagicConstantCasingFixer::class,
        LowercaseCastFixer::class,
        ShortScalarCastFixer::class,
        ElseifFixer::class,

        // Security
        FopenFlagsFixer::class,

        // PHPUnit improvements
        PhpUnitConstructFixer::class,
        PhpUnitDedicateAssertFixer::class,
        PhpUnitDedicateAssertInternalTypeFixer::class,
        PhpUnitMockShortWillReturnFixer::class,

        // Import/namespace cleanup
        NoLeadingImportSlashFixer::class,
        SingleLineAfterImportsFixer::class,

        // Basic formatting
        FullOpeningTagFixer::class,
        NoClosingTagFixer::class,
    ])

    // Essential configurations
    ->withConfiguredRule(ArraySyntaxFixer::class, [
        'syntax' => 'short',
    ])
    ->withConfiguredRule(ConcatSpaceFixer::class, [
        'spacing' => 'one',
    ])
    ->withConfiguredRule(TrailingCommaInMultilineFixer::class, [
        'elements' => ['arrays', 'arguments', 'parameters'],
    ])
    ->withConfiguredRule(ClassAttributesSeparationFixer::class, [
        'elements' => ['property' => 'one', 'method' => 'one'],
    ])
    ->withConfiguredRule(MethodArgumentSpaceFixer::class, [
        'on_multiline' => 'ensure_fully_multiline',
    ])
    ->withConfiguredRule(NativeFunctionInvocationFixer::class, [
        'include' => [NativeFunctionInvocationFixer::SET_COMPILER_OPTIMIZED],
        'scope' => 'namespaced',
        'strict' => false,
    ])
    ->withConfiguredRule(OrderedImportsFixer::class, [
        'imports_order' => ['class', 'function', 'const'],
        'sort_algorithm' => 'alpha',
    ])
    ->withConfiguredRule(OrderedClassElementsFixer::class, [
        'order' => [
            'use_trait',
            'constant_public',
            'constant_protected',
            'constant_private',
            'property_public',
            'property_protected',
            'property_private',
            'construct',
            'destruct',
            'method_public',
            'method_protected',
            'method_private',
        ],
    ])
    ->withConfiguredRule(CastSpacesFixer::class, [
        'space' => 'none',
    ])
    ->withConfiguredRule(GeneralPhpdocAnnotationRemoveFixer::class, [
        'annotations' => ['copyright', 'category'],
    ])
    ->withConfiguredRule(NoSuperfluousPhpdocTagsFixer::class, [
        'allow_unused_params' => true,
    ])
    ->withConfiguredRule(PhpUnitDedicateAssertFixer::class, [
        'target' => 'newest',
    ])

    // Keep essential skips
    ->withSkip([
        'PhpCsFixer\Fixer\Import\SingleImportPerStatementFixer',
        'Symplify\CodingStandard\Fixer\ArrayNotation\ArrayOpenerAndCloserNewlineFixer',
        'Symplify\CodingStandard\Fixer\ArrayNotation\ArrayListItemNewlineFixer',
        'PhpCsFixer\Fixer\FunctionNotation\SingleLineThrowFixer',
        'PhpCsFixer\Fixer\ClassNotation\SelfAccessorFixer',
        'PhpCsFixer\Fixer\LanguageConstruct\ExplicitIndirectVariableFixer',
        'PhpCsFixer\Fixer\PhpTag\BlankLineAfterOpeningTagFixer',
        'PhpCsFixer\Fixer\Phpdoc\PhpdocSummaryFixer',
        'PhpCsFixer\Fixer\StringNotation\ExplicitStringVariableFixer',
        'Symplify\CodingStandard\Fixer\ArrayNotation\StandaloneLineInMultilineArrayFixer',

        // Skip specific files
        NoSuperfluousPhpdocTagsFixer::class => [
            __DIR__ . '/.gitlab-ci/tools/src/Service/ProcessBuilder.php',
        ],
    ]);