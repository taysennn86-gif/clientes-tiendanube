{# Cart totals used on cart-summary.tpl #}

{# Price without taxes classes #}

{% set price_without_taxes_container_classes = "d-grid grid-1-auto mb-2 font-small opacity-60" %}
{% set price_without_taxes_price_classes = "text-right" %}

{# Cart subtotal #}

{% if cart_subtotal %}
  <div class="js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %} data-store="cart-subtotal">
    <div class="d-grid grid-1-auto mb-2 font-big">
      <span>
        {{ "Subtotal" | translate }}
        
        <span class="js-subtotal-shipping-wording" {% if not (cart.has_shippable_products or show_calculator_on_cart) %}style="display: none"{% endif %}>{{ " (sin envío)" | translate }}</span>
        :
      </span>
      <span class="js-ajax-cart-total js-cart-subtotal text-right" data-priceraw="{{ cart.subtotal }}" data-component="cart.subtotal" data-component-value={{ cart.subtotal }}>{{ cart.subtotal | money }}</span>
    </div>
  </div>

  {# Price without taxes #}

  {{ component('price-without-taxes', {
      location: 'cart',
      container_classes: price_without_taxes_container_classes,
      text_classes: {
        price: price_without_taxes_price_classes,
      },
    })
  }}
{% endif %}


{# Cart promotions #}

{% if cart_promotions %}
  <div class="js-total-promotions font-big text-accent">
    <span class="js-promo-discount" style="display:none;"> {{ "Descuento" | translate }}</span>
    <span class="js-promo-in" style="display:none;">{{ "en" | translate }}</span>
    <span class="js-promo-all" style="display:none;">{{ "todos los productos" | translate }}</span>
    <span class="js-promo-buying" style="display:none;"> {{ "comprando" | translate }}</span>
    <span class="js-promo-units-or-more" style="display:none;"> {{ "o más" | translate }}</span>
    <span class="js-cart-discount-automatic" style="display:none;">{{ "Descuento" | translate }}</span>
    <span class="js-cart-discount-with-coupon" style="display:none;">{{ "Descuento del cupón" | translate }}</span>
    {% for promotion in cart.promotional_discount.promotions_applied %}
      {% if not promotion.is_subscription_promotion %}
        {% if(promotion.scope_value_id) %}
          {% set id = promotion.scope_value_id %}
        {% else %}
          {% set id = 'all' %}
        {% endif %}
          <span class="js-total-promotions-detail-row d-grid grid-1-auto mb-2" id="{{ id }}">
            <span>
              {% if promotion.discount_script_type != "custom" %}
                {% if promotion.discount_script_type == "NAtX%off" %}
                  {{ promotion.selected_threshold.discount_decimal_percentage * 100 }}% OFF
                {% elseif promotion.isBuyXPayY %}
                  {{ promotion.buy }}x{{ promotion.pay }}
                {% elseif promotion.isCrossSelling %}
                  {{ "Descuento" | translate }}
                {% elseif promotion.isCartDiscount %}
                  {% if promotion.coupon_activated %}{{ "Descuento del cupón" | translate }}{% else %}{{ "Descuento" | translate }}{% endif %}
                  {% if promotion.cart_discount.isPercentage %}{{ promotion.cart_discount.value | round }}%{% else %}{{ promotion.total_discount_amount_short }}{% endif %}
                {% else %}
                  {{ promotion.discount_script_type }}
                {% endif %}

                {% if not promotion.isCartDiscount %}
                  {{ "en" | translate }} {% if id == 'all' %}{{ "todos los productos" | translate }}{% else %}{{ promotion.scope_value_name }}{% endif %}
                {% endif %}

                {% if promotion.discount_script_type == "NAtX%off" %}
                  <span>{{ "Comprando {1} o más" | translate(promotion.selected_threshold.quantity) }}</span>
                {% endif %}
              {% else %}
                {{ promotion.scope_value_name }}
              {% endif %}
              :
            </span>
            <span class="text-right">-{{ promotion.total_discount_amount_short }}</span>
          </span>
      {% endif %}
    {% endfor %}
  </div>
{% endif %}



{# Cart shipping costs #}

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
      total: 'd-grid grid-1-auto mb-3 font-huge',
      total_price: 'text-right',
      payment_discount_and_installments: 'text-right',
      payment_discount_price: 'text-accent font-small font-weight-normal mt-1',
      installments: 'font-small font-weight-normal mt-1',
    },
  })
}}
