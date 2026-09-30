{# Cart subtotals for cart popup #}

{% set has_free_shipping = cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price %}
{% set has_free_shipping_bar = has_free_shipping and cart.free_shipping.min_price_free_shipping.min_price_raw > 0 %}

{% set gift_progress_parameters = {
  progress_bar_icon_svg_id: 'gift',
  show_check: false,
  progress_bar_classes: {
    container: 'progress-bar',
    title_container: 'progress-bar-title-container',
    title: 'progress-bar-title',
    icon: 'progress-bar-icon icon-inline svg-icon-accent icon-lg',
    subtitle: 'progress-bar-subtitle opacity-50',
    track: 'bar-progress',
    fill: 'bar-progress-active transition-soft',
  }
} %}

{% if not cart_page %}

  <div class="cart-progress-card mx-neg-3 mb-3">
    {# Gift promotion progress bar #}
    {{ component('gift-promotion-progress', gift_progress_parameters) }}

      {% if has_free_shipping_bar %}
        {# Free shipping progress bar #}
        {% include "snipplets/shipping/shipping-free-rest.tpl" %}
      {% endif %}
  </div>

  {# Cart shipping and pickup #}

  {% include "snipplets/cart/cart-fulfillment.tpl" %}

{% endif %}

{# Coupon input #}
{% if settings.cart_coupon %}
  <div class="js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
    {{ component('coupon-input', {
      label_svg_id: 'tag',
      toggle_inactive_svg_id: 'plus',
      toggle_active_svg_id: 'minus',
      spinner_svg_id: 'spinner-third',
      container_classes: {
        container: 'pb-4 bottom-line mb-4',
        content: 'pt-2',
        toggle: 'd-flex align-items-center justify-content-between w-100',
        toggle_icon: 'icon-inline',
        toggle_label: 'd-flex align-items-center font-medium',
        label_icon: 'icon-inline mr-2',
        actions: 'mt-2',
        applied_row: 'd-flex align-items-center justify-content-between',
        applied_code: 'mr-4 font-medium',
        remove_button: 'btn btn-link font-small',
        form: 'form-group mb-0',
        input_wrapper: 'input-append mb-1',
        input: 'form-control',
        apply_button: 'btn btn-inline',
        spinner_icon: 'icon-inline icon-spin svg-icon-text',
        spinner: 'ml-2',
        error: 'alert alert-danger mb-0 mt-2',
      }
    }) }}
  </div>
{% endif %}

{% if cart_page %}
  <div id="cart-sticky-summary" class="position-sticky-md cart-page-totals">

    {# Gift promotion progress bar + free shipping progress bar #}
    <div class="d-none d-md-flex cart-progress-card mb-3">
      {{ component('gift-promotion-progress', gift_progress_parameters) }}

      {% if has_free_shipping_bar %}
        {% include "snipplets/shipping/shipping-free-rest.tpl" %}
      {% endif %}
    </div>

{% endif %}

    {# Cart totals #}

    {% set show_cart_fulfillment = settings.shipping_calculator_cart_page and (store.has_shipping or store.branches) %}

    {{ component('cart-totals', {
        shipping_enabled: show_cart_fulfillment,
        shipping_discount_row_enabled: true,
        payment_discount_price_enabled: settings.payment_discount_price,
        installments_enabled: not settings.payment_discount_price,
        totals_divider: false,
        container_classes: {
          subtotals: 'pb-2',
        },
        text_classes: {
          subtotals_row: 'd-grid grid-1-auto mb-2',
          subtotals_prices: 'text-right',
          subtotal: 'font-big',
          price_without_taxes: 'd-grid grid-1-auto mb-2 font-small opacity-60',
          price_without_taxes_price: 'text-right',
          promotions: 'font-big text-accent',
          discounts_row: 'font-big text-accent',
          shipping_costs: 'font-big',
          shipping_costs_price: 'opacity-40',
          shipping_costs_calculating: 'opacity-40',
          shipping_costs_empty: 'opacity-40',
          shipping_discount_row: 'd-grid grid-1-auto mb-2 font-big text-accent',
          shipping_discount_label: 'text-uppercase',
          shipping_discount_price: 'text-right',
          total: 'd-grid grid-1-auto mb-3 font-huge',
          total_price: 'text-right',
          payment_discount_and_installments: 'text-right',
          payment_discount_price: 'text-accent font-small font-weight-normal mt-1',
          installments: 'font-small font-weight-normal mt-1',
        },
      })
    }}

    {# Cart main CTA #}

    {% set cart_page_value = cart_page ? true : false %}

    {% include "snipplets/cart/cart-button.tpl" with {cart_page: cart_page_value} %}
    
{% if cart_page %}
  {# End of sticky module #}
  </div>
{% endif %}
