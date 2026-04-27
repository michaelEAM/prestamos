<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require 'config.php';

$action = $_GET['action'] ?? '';

switch ($action) {
    case 'listar':
        listar($pdo);
        break;
    case 'guardar':
        guardar($pdo);
        break;
    case 'abonar':
        abonar($pdo);
        break;
    case 'eliminar':
        eliminar($pdo);
        break;
    default:
        echo json_encode(['error' => 'Acción no válida']);
        break;
}

function listar($pdo) {
    $stmt = $pdo->query("SELECT * FROM prestamos ORDER BY id DESC");
    $prestamos = $stmt->fetchAll();

    foreach ($prestamos as &$p) {
        $p['id'] = (int)$p['id'];
        $p['monto'] = (float)$p['monto'];
        $p['cuotas'] = (int)$p['cuotas'];
        $p['valor_cuota'] = (float)$p['valor_cuota'];

        $stmt2 = $pdo->prepare("SELECT * FROM abonos WHERE prestamo_id = ? ORDER BY id ASC");
        $stmt2->execute([$p['id']]);
        $abonos = $stmt2->fetchAll();
        foreach ($abonos as &$a) {
            $a['id'] = (int)$a['id'];
            $a['prestamo_id'] = (int)$a['prestamo_id'];
            $a['cantidad_cuotas'] = (int)$a['cantidad_cuotas'];
        }
        $p['abonos'] = $abonos;
    }

    echo json_encode(['prestamos' => $prestamos]);
}

function guardar($pdo) {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!$data) {
        echo json_encode(['error' => 'Datos inválidos']);
        return;
    }

    $sql = "INSERT INTO prestamos (nombre, cedula, fecha_prestamo, monto, cuotas, valor_cuota, motivo) 
            VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        $data['nombre'],
        $data['cedula'],
        $data['fecha_prestamo'],
        $data['monto'],
        $data['cuotas'],
        $data['valor_cuota'],
        $data['motivo']
    ]);

    echo json_encode(['success' => true, 'id' => (int)$pdo->lastInsertId()]);
}

function abonar($pdo) {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!$data) {
        echo json_encode(['error' => 'Datos inválidos']);
        return;
    }

    $sql = "INSERT INTO abonos (prestamo_id, fecha_abono, cantidad_cuotas) VALUES (?, ?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        $data['prestamo_id'],
        $data['fecha_abono'],
        $data['cantidad_cuotas']
    ]);

    echo json_encode(['success' => true, 'id' => (int)$pdo->lastInsertId()]);
}

function eliminar($pdo) {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!$data || !isset($data['id'])) {
        echo json_encode(['error' => 'ID requerido']);
        return;
    }

    $stmt = $pdo->prepare("DELETE FROM prestamos WHERE id = ?");
    $stmt->execute([$data['id']]);

    echo json_encode(['success' => true]);
}

