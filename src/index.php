<?php
require_once 'conexion.php';

try {
    $stmt = $conn->query("SELECT * FROM alumnos");
    $alumnos = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Error en la consulta: " . $e->getMessage());
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Listado de Alumnos</title>
</head>
<body>
  <h1>Listado de Alumnos</h1>
  <?php if ($alumnos): ?>
    <ul>
      <?php foreach ($alumnos as $alumno): ?>
        <li><?= htmlspecialchars($alumno['nombre']) ?> (<?= htmlspecialchars($alumno['email']) ?>)</li>
      <?php endforeach; ?>
    </ul>
  <?php else: ?>
    <p>No hay alumnos.</p>
  <?php endif; ?>
</body>
</html>
