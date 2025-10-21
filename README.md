Práctica 4: Desplegar una aplicación PHP + MySQL en Render

🚀 Guía: Desplegar una aplicación PHP + MySQL (previamente configurada con Docker Compose) en la plataforma en la nube Render.

🧩 Objetivo

Publicar en internet una aplicación web PHP + MySQL que ya funciona localmente o en un entorno como GitHub Codespaces, obteniendo una URL pública y permanente del tipo:
https://tu-app.onrender.com

🧰 Requisitos previos

Tener una cuenta gratuita en Render.

Tener el repositorio de tu aplicación en GitHub, con visibilidad pública.

El repositorio debe incluir:

Dockerfile (para el entorno de PHP).

El código de tu aplicación (por ejemplo, index.php, conexion.php, etc.).

🧱 Paso 1: Preparar los archivos

Render no utiliza directamente el archivo docker-compose.yml para desplegar servicios. En su lugar, se crea un servicio web principal y, si es necesario, una base de datos separada.

Tu Dockerfile debe estar preparado para construir la imagen del servidor web. Aquí tienes un ejemplo funcional:

# Usa una imagen oficial de PHP 8.2 con Apache
FROM php:8.2-apache

# Instala las extensiones de PHP necesarias para MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Copia los archivos del proyecto al directorio web de Apache
COPY . /var/www/html/

# Expone el puerto 80 para el tráfico web
EXPOSE 80


⚙️ Paso 2: Subir tu repositorio a GitHub

Asegúrate de que tu repositorio cumple con lo siguiente:

Es público.

El Dockerfile se encuentra en la raíz del proyecto.

🌐 Paso 3: Crear la base de datos MySQL en Render

Entra en tu panel de control: https://dashboard.render.com

Haz clic en New + → Database.

Elige MySQL.

Asigna un nombre único (ej: miapp-db) y selecciona la región.

Espera unos segundos mientras Render provisiona la base de datos.

Copia y guarda los datos de conexión que aparecen en la pestaña "Info". Necesitarás:

Hostname (Host)

Username (Usuario)

Password (Contraseña)

Database Name (Nombre de la base de datos)

Port (Puerto)

🧩 Paso 4: Crear el servicio web (PHP)

En el mismo panel de Render, haz clic en New + → Web Service.

Conecta tu cuenta de GitHub si no lo has hecho.

Selecciona el repositorio de tu proyecto.

Rellena los campos de configuración:

Name: Un nombre para tu servicio (ej: miapp-web).

Root directory: Déjalo en blanco (si el Dockerfile está en la raíz).

Environment: Selecciona Docker.

Build Command: Déjalo en blanco.

Start Command: Render lo infiere automáticamente del Dockerfile (apache2-foreground).

Haz clic en Create Web Service. La primera construcción puede tardar entre 3 y 5 minutos.

🧩 Paso 5: Configurar las variables de entorno

Para que tu aplicación PHP se conecte a la base de datos, debes pasarle los datos de conexión de forma segura.

En tu servicio web en Render, ve a la pestaña Environment.

En la sección Environment Variables, añade las siguientes claves y pega los valores que guardaste en el paso 3:

DB_HOST

DB_NAME

DB_USER

DB_PASSWORD

DB_PORT

Tu archivo conexion.php (o similar) debería leer estas variables para establecer la conexión:

<?php
// Lee las variables de entorno configuradas en Render
$host = getenv('DB_HOST');
$db   = getenv('DB_NAME');
$user = getenv('DB_USER');
$pass = getenv('DB_PASSWORD');
$port = getenv('DB_PORT');
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;port=$port;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $conn = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    // En un entorno de producción, sería mejor registrar el error que mostrarlo.
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
?>


🧠 Paso 6: Probar la aplicación

Una vez Render haya desplegado tu contenedor, aparecerá una URL pública en la parte superior del panel de tu servicio:
https://tu-app.onrender.com

Haz clic en ella. Deberías ver tu index.php funcionando y conectado correctamente a la base de datos MySQL.

🎉 ¡Tu aplicación está en línea permanentemente!

⚠️ Notas importantes

Modo de reposo: Render pone en reposo los servicios del plan gratuito si no reciben tráfico durante 15 minutos. Se reactivan automáticamente (con un pequeño retraso inicial) al acceder a la URL.

Logs: Puedes ver los logs del despliegue y de la aplicación en tiempo real en la pestaña Logs de tu servicio.

Actualizaciones: Si necesitas cambiar la contraseña o cualquier otro dato de la base de datos, solo tienes que actualizar las variables de entorno en Render.

🧾 Resumen del flujo

GitHub (repositorio público con Dockerfile)

↓

Render (importa el repositorio)

↓

Crea la base de datos MySQL.

Crea el Web Service desde el Dockerfile.

Configura las variables de entorno para conectar ambos.

↓

URL pública: https://tu-app.onrender.com
