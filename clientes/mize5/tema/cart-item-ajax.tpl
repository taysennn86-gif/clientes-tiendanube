{% set item_type_classes = item.product.is_non_shippable ? 'js-cart-item-non-shippable' : 'js-cart-item-shippable' %}
{% set item_page_classes = cart_page ? 'cart-page-item align-items-md-center' %}
{% set compare_at_price = item.compare_at_price %}
{% set hide_compare_price_subtotal = not item.compare_at_price_subtotal or item.is_subscription_item %}
{% set discount_percentage = item.discount_percentage %}
{% set is_gift = item.is_gift %}

{{ component('nubesdk-slot', { type: "before_line_item", pick: item.id }) }}

<div class="js-cart-item {{ item_type_classes }} cart-item {{ item_page_classes }} mb-4" data-item-id="{{ item.id }}" data-gift="{{ is_gift ? 'true' : 'false' }}" data-store="cart-item-{{ item.product.id }}" data-component="cart.line-item">

    {# Cart item image #}

    <div class="cart-item-image-container">
        <a href="{{ item.url }}">
            {{ component(
                'image',{
                    image_name: item.featured_image,
                    image_classes: 'img-fluid cart-item-image',
                    image_alt: item.short_name,
                    product_image: true,
                })
            }}
        </a>
    </div>
    <div class="cart-item-info-container">
        <div class="cart-item-product-info">

                {# Cart item name #}

                <div class="cart-item-name-container mb-1" data-component="line-item.name">

                    <a href="{{ item.url }}" class="cart-item-name" data-component="name.short-name">
                        {{ item.short_name }}
                    </a>
                    <span class="cart-item-variant" data-component="name.short-variant-name">{{ item.short_variant_name }}</span>


                    {# Cart kit components #}

                    {% if item.is_kit and item.kit_components is not empty %}
                        {% set kit_modal_body %}
                            {{ component('cart-kit-components', {
                                kit_components: item.kit_components,
                                kit_quantity: item.quantity,
                                classes: {
                                    list: 'list-unstyled mb-0',
                                    item: 'd-flex align-items-center pt-2 pb-2',
                                    image_wrap: 'flex-shrink-0 mr-3',
                                    image: 'kit-products-item-img',
                                    text: 'flex-grow-1 min-w-0 font-small',
                                    name: 'kit-products-item-name font-medium mb-0',
                                }
                            }) }}
                        {% endset %}

                        <button type="button" class="js-modal-open-private btn btn-link font-small d-block" data-target="#cart-kit-modal-{{ item.id }}" data-component="line-item.kit-breakdown-link">
                            {{ "Ver contenido" | translate }}
                        </button>

                        {{ component(
                            'modal',{
                                modal_id: 'cart-kit-modal-' ~ item.id,
                                data_component: 'cart.kit-breakdown',
                                position: {
                                    appear_from: 'bottom',
                                },
                                layout: {
                                    width_desktop: 'small',
                                },
                                content: {
                                    title: item.short_name,
                                    title_data_component: 'cart.kit-breakdown.kit-name',
                                    body: kit_modal_body,
                                },
                                icons: {
                                    close_icon_id: 'times',
                                },
                                modal_classes: {
                                    modal: 'modal-body-scrollable-auto',
                                    close_icon: 'icon-inline icon-2x',
                                }
                            })
                        }}
                    {% endif %}
                    {{ component(
                        'cart-labels', {
                            group: true,
                            subscription_label: true,
                            shipping_icon: true,
                            shipping_svg_id: 'truck',
                            hide_percentage_off_label: true,
                            labels_classes: {
                                group: 'mt-2 mb-1',
                                shipping: 'text-accent cart-item-label d-flex align-items-center mb-2',
                                shipping_icon: 'icon-inline icon-lg svg-icon-accent mr-1',
                                promotion: 'label label-accent cart-item-small-label', 
                                subscription: 'font-smallest opacity-80 mt-1 mb-2',
                            },
                        })
                    }}
                    {% if is_gift %}
                        <div class="text-accent font-smallest font-weight-bold text-uppercase my-2">
                            {{ "Regalo" | translate }}
                        </div>
                    {% endif %}
                </div>

            {# Cart item delete #}

            {% if not is_gift %}
                <div class="cart-item-delete {% if cart_page %}d-md-none{% endif %}">
                    <button type="button" class="btn btn-link cart-item-delete-button" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
                        {{ "Eliminar" | translate }}
                    </button>
                </div>
            {% endif %}

        </div>
        <div class="cart-item-totals-container align-items-center">
        
            {# Cart item quantity #}

            <div class="cart-item-quantity" data-component="line-item.subtotal">
                {% embed "snipplets/forms/form-input.tpl" with{
                type_number: true, 
                input_value: item.quantity,
                input_name: 'quantity[' ~ item.id ~ ']',
                input_data_attr: 'item-id',
                input_data_val: item.id,
                input_custom_class: 'js-cart-quantity-input cart-quantity-input p-0',
                input_label: false,
                input_append_content: true,
                input_group_custom_class: 'js-quantity form-quantity small',
                input_disabled: is_gift,
                form_data_component: 'quantity.value',
                form_control_quantity: true,
                input_aria_label: 'Cambiar cantidad' | translate } %}
                    {% block input_prepend_content %}
                        <div class="grid grid-3-auto grid-no-gap align-items-center">
                            <span class="js-cart-quantity-btn btn icon-30px" onclick="LS.minusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.minus">
                                <svg class="icon-inline"><use xlink:href="#minus"/></svg>
                            </span>
                    {% endblock input_prepend_content %}
                    {% block input_append_content %}
                            <span class="js-cart-input-spinner cart-item-spinner" style="display: none;">
                                <svg class="icon-inline icon-spin svg-icon-text"><use xlink:href="#spinner-third"/></svg>
                            </span>
                            <span class="js-cart-quantity-btn btn icon-30px" onclick="LS.plusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.plus">
                                <svg class="icon-inline"><use xlink:href="#plus"/></svg>
                            </span>
                        </div>
                    {% endblock input_append_content %}
                {% endembed %}
            </div>

            {% set cart_page_price_class = 'cart-item-subtotal' %}

            {% if cart_page %}
                {# Cart item unit price #}
                <div class="cart-item-unit-price d-none d-md-block">
                    {% if is_gift %}
                        <div class="price-compare opacity-50">{{ item.compare_at_price | money }}</div>
                        <div class="{{ cart_page_price_class }}">{{ "Gratis" | translate }}</div>
                    {% else %}
                        <div class="js-cart-item-unit-price-compare-price-container cart-compare-price-container mb-1" data-line-item-id="{{ item.id }}"{% if not compare_at_price %} style="display: none"{% endif %}>
                            <span class="text-accent mr-1">-{{ discount_percentage }}%</span>
                            <span class="js-cart-item-unit-price-compare-price price-compare opacity-50" data-line-item-id="{{ item.id }}" data-component="compare_price.value" data-component-value='{{ compare_at_price | money }}'>{{ compare_at_price | money }}</span>
                        </div>
                        <div class="js-cart-item-unit-price {{ cart_page_price_class }}" data-line-item-id="{{ item.id }}">{{ item.unit_price | money }}</div>
                    {% endif %}
                </div>
            {% endif %}

            {# Cart item subtotal #}

            <div class="cart-item-subtotal text-right {% if cart_page %}text-md-left{% endif %}">
                {% if is_gift %}
                    <div class="price-compare opacity-50">{{ item.compare_at_price_subtotal | money }}</div>
                    <div>{{ "Gratis" | translate }}</div>
                {% else %}
                    <div class="js-cart-item-subtotal-compare-price-container cart-compare-price-container mb-1" data-line-item-id="{{ item.id }}"{% if hide_compare_price_subtotal %} style="display: none"{% endif %}>
                        <span class="text-accent mr-1">-{{ discount_percentage }}%</span>
                        <span class="js-cart-item-subtotal-compare-price price-compare opacity-50" data-line-item-id="{{ item.id }}" data-component="subtotal_compare_price.value" data-component-value='{{ item.compare_at_price_subtotal | money }}'>{{ item.compare_at_price_subtotal | money }}</span>
                    </div>
                    <div class="js-cart-item-subtotal" data-line-item-id="{{ item.id }}" data-component="subtotal.value" data-component-value='{{ item.subtotal | money }}'>{{ item.subtotal | money }}</div>
                {% endif %}
            </div>
        </div>

        {% if cart_page and not is_gift %}

            {# Cart page item delete #}

            <div class="cart-item-delete d-none d-md-block text-right">
                <button type="button" class="btn btn-link" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
                    {{ "Eliminar" | translate }}
                </button>
            </div>
        {% endif %}
    </div>
</div>
    