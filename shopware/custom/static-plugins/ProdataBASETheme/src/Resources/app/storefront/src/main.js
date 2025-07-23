import ProductSliderControl from './js/product-slider-controls/product-slider-controls.plugin';

console.log('base theme loaded');

PluginManager.register('ProductSliderControl', ProductSliderControl, '[data-product-slider-mod-control="true"]');

// Necessary for the webpack hot module reloading server
if (module.hot) {
    module.hot.accept();
}

