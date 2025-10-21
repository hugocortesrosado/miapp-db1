<?php
$dsn = 'mysql:host=db;dbname=miapp;charset=utf8mb4';
$username = 'root';
$password = 'example';

try {
    $conn= new PDO($dsn, $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die('❌ Error de conexión: ' . $e->getMessage());
}
?>
