FROM php:8.2-apache

# Instala PostgreSQL (libpq-dev) y el driver de PHP (pdo_pgsql)
RUN apt-get update \
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && docker-php-ext-enable pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# === CORRECCIONES CRÍTICAS DE APACHE ===
# 1. Corrige la Advertencia AH00558 (ServerName)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 2. Configura Permisos y Directorios (Corrige 403 / DirectoryIndex no encontrado)
# - Permite el uso de '.htaccess' (AllowOverride All).
# - Activa el módulo de reescritura (mod_rewrite).
# - Asegura que el directorio tiene las 'Options' correctas (FollowSymLinks).
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && a2enmod rewrite \
    && sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/apache2/apache2.conf

# 3. Configura 'index.php' como archivo predeterminado.
RUN echo "DirectoryIndex index.php" > /etc/apache2/conf-available/dir.conf

# === FIN DE LAS CORRECCIONES DE APACHE ===

# 4. COPIA FINAL: Copia SOLO el contenido de src/ a la raíz del servidor web
# Esto es CRÍTICO porque index.php está dentro de src/
COPY src/ /var/www/html/

EXPOSE 80
