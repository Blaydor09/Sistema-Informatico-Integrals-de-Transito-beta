<?php
// server/index.php

session_start();

// Cabeceras y CORS
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Autocarga de conexión y modelos
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/models/Persona.php';
require_once __DIR__ . '/models/Vehiculo.php';
require_once __DIR__ . '/models/Licencia.php';
require_once __DIR__ . '/models/Infraccion.php';
require_once __DIR__ . '/models/Distrito.php';
require_once __DIR__ . '/models/Via.php';
require_once __DIR__ . '/models/Incidente.php';
require_once __DIR__ . '/models/Usuario.php';  // para login

// Helpers
function input() {
    return json_decode(file_get_contents('php://input'), true);
}

function respond($data, $code = 200) {
    http_response_code($code);
    echo json_encode($data);
    exit;
}

// Parseo de la ruta: extraer solo "/api/xxx/..."
$script = $_SERVER['SCRIPT_NAME'];                       // e.g. "/sgiit/server/index.php"
$uri    = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH); 
$path   = substr($uri, strlen($script));                // e.g. "/api/personas/123"
$parts  = explode('/', trim($path, '/'));               // ["api","personas","123"]
$method   = $_SERVER['REQUEST_METHOD'];

if (count($parts) < 2 || $parts[0] !== 'api') {
    respond(['error' => 'Ruta inválida'], 404);
}

$resource = $parts[1];
$id       = $parts[2] ?? null;

// LOGIN
if ($method === 'POST' && $resource === 'login') {
    $creds = input();
    $user = Usuario::authenticate($creds['username'] ?? '', $creds['password'] ?? '');
    if ($user) {
        $_SESSION['user_id'] = $user['usuario_id'];
        respond(['ok' => true, 'usuario_id' => $user['usuario_id']], 200);
    }
    respond(['error' => 'Credenciales inválidas'], 401);
}

// LOGOUT
if ($method === 'POST' && $resource === 'logout') {
    session_unset();
    session_destroy();
    respond(['ok' => true]);
}

// Autorización: todo excepto login/logout requiere sesión iniciada
if (!in_array($resource, ['login','logout']) && empty($_SESSION['user_id'])) {
    respond(['error' => 'No autorizado'], 401);
}

// Enrutamiento genérico
switch ($resource) {
    case 'personas':
        switch ($method) {
            case 'GET':
                if ($id) {
                    $p = Persona::find((int)$id);
                    $p ? respond($p) : respond(['error'=>'No existe'], 404);
                } else {
                    respond(Persona::all());
                }
            case 'POST':
                $newId = Persona::create(input());
                respond(['persona_id'=>$newId], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Persona::update((int)$id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Persona::delete((int)$id);
                respond(['ok'=>true]);
        }
        break;

    case 'vehiculos':
        switch ($method) {
            case 'GET':
                $id 
                    ? respond(Vehiculo::find((int)$id) ?: ['error'=>'No existe'], $id?200:404)
                    : respond(Vehiculo::all());
            case 'POST':
                $newId = Vehiculo::create(input());
                respond(['vehiculo_id'=>$newId], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Vehiculo::update((int)$id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Vehiculo::delete((int)$id);
                respond(['ok'=>true]);
        }
        break;

    case 'licencias':
        switch ($method) {
            case 'GET':
                $id 
                    ? respond(Licencia::find((int)$id) ?: ['error'=>'No existe'], $id?200:404)
                    : respond(Licencia::all());
            case 'POST':
                $newId = Licencia::create(input());
                respond(['licencia_id'=>$newId], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Licencia::update((int)$id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Licencia::delete((int)$id);
                respond(['ok'=>true]);
        }
        break;

    case 'infracciones':
        switch ($method) {
            case 'GET':
                $id 
                    ? respond(Infraccion::find($id) ?: ['error'=>'No existe'], $id?200:404)
                    : respond(Infraccion::all());
            case 'POST':
                Infraccion::create(input());
                respond(['ok'=>true], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'Código requerido'], 400);
                Infraccion::update($id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'Código requerido'], 400);
                Infraccion::delete($id);
                respond(['ok'=>true]);
        }
        break;

    case 'distritos':
        switch ($method) {
            case 'GET':
                $id 
                    ? respond(Distrito::find((int)$id) ?: ['error'=>'No existe'], $id?200:404)
                    : respond(Distrito::all());
            case 'POST':
                $newId = Distrito::create(input());
                respond(['distrito_id'=>$newId], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Distrito::update((int)$id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Distrito::delete((int)$id);
                respond(['ok'=>true]);
        }
        break;

    case 'vias':
        switch ($method) {
            case 'GET':
                $id 
                    ? respond(Via::find((int)$id) ?: ['error'=>'No existe'], $id?200:404)
                    : respond(Via::all());
            case 'POST':
                $newId = Via::create(input());
                respond(['via_id'=>$newId], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Via::update((int)$id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Via::delete((int)$id);
                respond(['ok'=>true]);
        }
        break;

    case 'incidentes':
        switch ($method) {
            case 'GET':
                if ($id) {
                    $inc = Incidente::find((int)$id);
                    $inc ? respond($inc) : respond(['error'=>'No existe'], 404);
                } else {
                    $fi   = $_GET['fechaInicio'] ?? null;
                    $ff   = $_GET['fechaFin']    ?? null;
                    $tipo = $_GET['tipo']        ?? null;
                    respond(Incidente::filter($fi, $ff, $tipo));
                }
            case 'POST':
                $newId = Incidente::create(input());
                respond(['incidente_id'=>$newId], 201);
            case 'PUT':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Incidente::update((int)$id, input());
                respond(['ok'=>true]);
            case 'DELETE':
                if (!$id) respond(['error'=>'ID requerido'], 400);
                Incidente::delete((int)$id);
                respond(['ok'=>true]);
        }
        break;

    default:
        respond(['error'=>'Recurso no soportado'], 404);
}
