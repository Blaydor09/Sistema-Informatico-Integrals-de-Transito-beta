<?php
require_once __DIR__ . '/../db.php';

class Incidente {
    public int     $incidente_id;
    public string  $tipo;
    public string  $fecha_hora;
    public ?string $direccion;
    public int     $distrito_id;
    public ?int    $via_id;
    public string  $creado_en;
    public string  $modificado_en;
    public ?string $creado_por;

    // Listado de todos los incidentes
    public static function all(): array {
        $sql = "SELECT * FROM incidente ORDER BY fecha_hora DESC";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    // Obtener un incidente con sus conductores e infracciones
    public static function find(int $id): ?array {
        $db = DB::getConnection();
        $stmt = $db->prepare("SELECT * FROM incidente WHERE incidente_id = ?");
        $stmt->execute([$id]);
        $inc = $stmt->fetch();
        if (!$inc) {
            return null;
        }
        // Conductores
        $cStmt = $db->prepare("SELECT persona_id FROM incidente_conductor WHERE incidente_id = ?");
        $cStmt->execute([$id]);
        $inc['conductores'] = $cStmt->fetchAll(PDO::FETCH_COLUMN);
        // Infracciones
        $iStmt = $db->prepare("SELECT cod_infraccion FROM incidente_infraccion WHERE incidente_id = ?");
        $iStmt->execute([$id]);
        $inc['infracciones'] = $iStmt->fetchAll(PDO::FETCH_COLUMN);
        return $inc;
    }

    // Crear incidente junto con conductores e infracciones
    public static function create(array $attrs): int {
        $db = DB::getConnection();
        $db->beginTransaction();
        // 1. Incidente principal
        $ins = $db->prepare(
            "INSERT INTO incidente
            (tipo, fecha_hora, direccion, distrito_id, via_id, creado_por)
            VALUES (?, ?, ?, ?, ?, ?)"
        );
        $ins->execute([
            $attrs['tipo'],
            $attrs['fecha_hora'],
            $attrs['direccion'] ?? null,
            $attrs['distrito_id'],
            $attrs['via_id'] ?? null,
            $attrs['creado_por'] ?? null
        ]);
        $id = (int)$db->lastInsertId();

        // 2. Conductores
        if (!empty($attrs['conductores'])) {
            $cIns = $db->prepare(
                "INSERT INTO incidente_conductor (incidente_id, persona_id) VALUES (?, ?)"
            );
            foreach ($attrs['conductores'] as $pid) {
                $cIns->execute([$id, $pid]);
            }
        }

        // 3. Infracciones
        if (!empty($attrs['infracciones'])) {
            $iIns = $db->prepare(
                "INSERT INTO incidente_infraccion (incidente_id, cod_infraccion) VALUES (?, ?)"
            );
            foreach ($attrs['infracciones'] as $code) {
                $iIns->execute([$id, $code]);
            }
        }

        $db->commit();
        return $id;
    }

    // Actualizar incidente y reestablecer asociaciones
    public static function update(int $id, array $attrs): bool {
        $db = DB::getConnection();
        $db->beginTransaction();
        // 1. Actualiza datos del incidente
        $upd = $db->prepare(
            "UPDATE incidente SET
             tipo = ?, fecha_hora = ?, direccion = ?, distrito_id = ?, via_id = ?, creado_por = ?
             WHERE incidente_id = ?"
        );
        $upd->execute([
            $attrs['tipo'],
            $attrs['fecha_hora'],
            $attrs['direccion'] ?? null,
            $attrs['distrito_id'],
            $attrs['via_id'] ?? null,
            $attrs['creado_por'] ?? null,
            $id
        ]);

        // 2. Reemplaza conductores
        $db->prepare("DELETE FROM incidente_conductor WHERE incidente_id = ?")
           ->execute([$id]);
        if (!empty($attrs['conductores'])) {
            $cIns = $db->prepare(
                "INSERT INTO incidente_conductor (incidente_id, persona_id) VALUES (?, ?)"
            );
            foreach ($attrs['conductores'] as $pid) {
                $cIns->execute([$id, $pid]);
            }
        }

        // 3. Reemplaza infracciones
        $db->prepare("DELETE FROM incidente_infraccion WHERE incidente_id = ?")
           ->execute([$id]);
        if (!empty($attrs['infracciones'])) {
            $iIns = $db->prepare(
                "INSERT INTO incidente_infraccion (incidente_id, cod_infraccion) VALUES (?, ?)"
            );
            foreach ($attrs['infracciones'] as $code) {
                $iIns->execute([$id, $code]);
            }
        }

        $db->commit();
        return true;
    }

    // Eliminar incidente (cascade en FK)
    public static function delete(int $id): bool {
        $stmt = DB::getConnection()
                 ->prepare("DELETE FROM incidente WHERE incidente_id = ?");
        return $stmt->execute([$id]);
    }

    // Filtrar por rango de fechas y/o tipo
    public static function filter(?string $fechaInicio, ?string $fechaFin, ?string $tipo): array {
        $conds = [];
        $params = [];
        if ($fechaInicio) {
            $conds[] = "fecha_hora >= ?";
            $params[] = $fechaInicio . " 00:00:00";
        }
        if ($fechaFin) {
            $conds[] = "fecha_hora <= ?";
            $params[] = $fechaFin . " 23:59:59";
        }
        if ($tipo) {
            $conds[] = "tipo = ?";
            $params[] = $tipo;
        }
        $where = $conds ? "WHERE " . implode(" AND ", $conds) : "";
        $sql = "SELECT * FROM incidente $where ORDER BY fecha_hora DESC";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }
}
