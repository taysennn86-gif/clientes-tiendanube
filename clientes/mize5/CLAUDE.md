# Reglas del proyecto — mize5

- La carpeta local `tema/` es la ÚNICA fuente de verdad. Nunca editar en el servidor.
- Sandbox primero: todo cambio se prueba en la tienda de prueba antes de tocar producción (una vez que exista sandbox).
- Toda subida por FTP se verifica con `curl` contra la tienda en vivo (usar `/search/?q=` para saltar el caché de 3-10 min).
- Cero placeholders: datos de contacto, promos y textos comerciales salen del sitio real o se confirman con el cliente, nunca se inventan.
- Promos/cuotas/descuentos dinámicos: leer siempre de la config del panel (Twig), nunca hardcodear porcentajes o montos.
- Una subida por FTP que no está commiteada y pusheada no existe — commit + push en el mismo turno que el upload (ver skill `tiendanube-ftp-git-sync`).
- Estructura del tema distinta a Morelia/Rio (ver README.md) — no asumir que las recetas del playbook mapean 1:1 sin revisar antes.
