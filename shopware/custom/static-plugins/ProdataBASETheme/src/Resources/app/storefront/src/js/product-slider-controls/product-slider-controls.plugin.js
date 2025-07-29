import Plugin from 'src/plugin-system/plugin.class';

/**
 * This Plugin handles the
 * dynamic width of the product slider's control buttons
 */
export default class ProductSliderControls extends Plugin {
    init() {
        // ensure that this is fired every time  the slider is created, built or ready
        if (this.el.classList.contains('js-slider-initialized')) {
            this._initElements();
        } else {
            this.el.$emitter.subscribe('afterInitSlider', () => {
                this._initElements();
            });
        }
        // rebuild id fired by baseslider.plugin after viewport change event
        this.el.$emitter.subscribe('rebuild', () => {
            this._initElements();
        });
    }

    _initElements() {
        this.tnsNav = this.el.querySelector('.tns-nav');
        this.controls = this.el.querySelector('[data-product-slider-controls="true"]');

        if (this.tnsNav && this.controls) {
            if (this.tnsNav.style.display === 'none') {
                this.controls.style.display = 'none';
            } else {
                this.controls.style.display = 'inline-block';
                this.controls.style.position = 'relative';
                this._modifyWidth();
            }
        }
    }

    _modifyWidth() {
        const currentWidth = window.getComputedStyle(this.tnsNav).getPropertyValue('width');
        this.controls.style.width = `${parseInt(currentWidth, 10) + 30}px`;
    }
}

