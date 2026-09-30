<div id="shoppingCartPage" data-minimum="{{ settings.cart_minimum_value }}" data-store="cart-page" class="container">
    {% embed "snipplets/page-header.tpl" %}
        {% block page_header_text %}{{ "Carrito de compras" | translate }}{% endblock page_header_text %}
    {% endembed %}
    
    <form action="{{ store.cart_url }}" method="post" class="visible-when-content-ready mb-5" data-store="cart-form" data-component="cart">

        {# Cart alerts #}

        {% if error.add %}
            {{ component('alert', {
                'type': 'warning',
                'message': 'our_components.cart.error_messages.' ~ error.add
            }) }}
        {% endif %}
        {% for error in error.update %}
            {% if error.error_code == 'out_of_stock' %}
                <div class="alert alert-warning">{{ "No podemos ofrecerte {1} unidades de {2}. Solamente tenemos {3} unidades." | translate(error.requested, error.item.name, error.stock) }}</div>
            {% else %}
                {{ component('alert', {
                    'type': 'warning',
                    'message': 'our_components.cart.error_messages.' ~ error.error_code
                }) }}
            {% endif %}
        {% endfor %}
        {% if cart.items %}
            <div class="cart-page-content">
                <div class="cart-page-products">
                    
                    {# Cart table header #}
            
                    <div class="cart-page-table-header pb-3 mb-3 font-medium bottom-line d-none d-md-grid">
                        <div>{{ 'Productos' | translate }}</div>
                        <div class="cart-page-table-header-totals">
                            <div>{{ 'Cantidad' | translate }}</div>
                            <div>{{ 'Precio' | translate }}</div>
                            <div>{{ 'Subtotal' | translate }}</div>
                        </div>
                    </div>

                    {# Cart table items #}

                    {{ component('nubesdk-slot', { type: "before_line_items" }) }}

                    <div class="js-ajax-cart-list mb-4">
                        {% if cart.items %}
                          {% for item in cart.items %}
                            {% include "snipplets/cart-item-ajax.tpl" with {'cart_page': true} %}
                          {% endfor %}
                        {% endif %}
                    </div>

                    {{ component('nubesdk-slot', { type: "after_line_items" }) }}

                    <div class="cart-page-fulfillment">

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

                        {# Gift promotion progress bar + free shipping progress bar #}
                        <div class="d-md-none cart-progress-card mb-3">
                          {{ component('gift-promotion-progress', gift_progress_parameters) }}
                          {% include "snipplets/shipping/shipping-free-rest.tpl" %}
                        </div>

                        {# Cart shipping and pickup #}

                        {% include "snipplets/cart/cart-fulfillment.tpl" %}
                    </div>
                </div>
                <div class="cart-page-summary">
                    {% include "snipplets/cart/cart-summary.tpl" with {cart_page: true} %}
                </div>
            </div>
        {% else %}

            {#  Empty cart  #}

            {% if not error %}
                {{ component('alert', {
                    'type': 'info',
                    'message': ('El carrito de compras está vacío.' | translate),
                    'class': 'text-center',
                }) }}
            {% endif %}
        {% endif %}
        <div id="error-ajax-stock" class="alert alert-warning mb-3" style="display: none;"> 
            {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1 font-small">{{ "ver otros acá" | translate }}</a>
        </div>
    </form>
    <div id="store-curr" class="hidden">{{ cart.currency }}</div>
</div>

