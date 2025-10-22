FROM php:8.2-apache

# Instala las dependencias de sistema para PostgreSQL (libpq-dev)
RUN apt-get update \
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# === INICIO DE LAS CORRECCIONES DE APACHE ===

# Corrige la Advertencia AH00558 (ServerName)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Corrige el Bucle de Redireccionamiento (AH00037):
# 1. Permite el uso de .htaccess con 'AllowOverride All'.
# 2. Activa el módulo de reescritura (mod_rewrite).
# 3. Configura 'index.php' como archivo principal.
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && a2enmod rewrite \
    && echo "DirectoryIndex index.php" > /etc/apache2/conf-available/dir.conf

# === FIN DE LAS CORRECCIONES DE APACHE ===

# Copia todo desde la raíz del repo ('.') al servidor web
COPY . /var/www/html/

# Asegúrate de eliminar la línea anterior que creaba el .htaccess
# RUN echo "DirectoryIndex index.php" > /var/www/html/.htaccess

EXPOSE 80
