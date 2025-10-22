FROM php:8.2-apache

# Instala las dependencias de sistema para PostgreSQL (libpq-dev)
# e instala las extensiones de PHP necesarias (pdo y pdo_pgsql)
RUN apt-get update \
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# === CORRECCIONES CRÍTICAS DE APACHE ===
# Estas líneas resuelven los errores AH00558, AH00037 y AH00035.

# 1. Corrige la Advertencia AH00558 (ServerName)
# Establece un nombre de servidor global para eliminar la advertencia.
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 2. Configura los Permisos y Redirecciones:
# - Permite el uso de '.htaccess' con 'AllowOverride All'. (Necesario para mod_rewrite)
# - Activa el módulo de reescritura (mod_rewrite) para manejar URLs amigables.
# - Asegura que el directorio tiene las 'Options' correctas (FollowSymLinks) para resolver el index.
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && a2enmod rewrite \
    && sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/apache2/apache2.conf

# 3. Configura 'index.php' como archivo predeterminado.
RUN echo "DirectoryIndex index.php" > /etc/apache2/conf-available/dir.conf

# === FIN DE LAS CORRECCIONES DE APACHE ===

# Copia tu aplicación al servidor web
COPY . /var/www/html/

EXPOSE 80
