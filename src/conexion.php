<?php
// Lee las variables de entorno de Render
$host = getenv('DB_HOST');
$db   = getenv('DB_NAME');
$user = getenv('DB_USER');
$pass = getenv('DB_PASSWORD');
$port = getenv('DB_PORT'); // Para PostgreSQL, Render usa el puerto 5432

// Define el "Data Source Name" (DSN) para PostgreSQL
// CAMBIO: "mysql:" se convierte en "pgsql:" y se quita el charset
$dsn = "pgsql:host=$host;port=$port;dbname=$db";

try {
    // Crea la conexión PDO
    $conn = new PDO($dsn, $user, $pass);
    
    // Configura PDO para que lance excepciones en caso de error
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    // Si la conexión falla, detiene el script y muestra el error
    die("❌ Error de conexión a la base de datos: " . $e->getMessage());
}
?>
