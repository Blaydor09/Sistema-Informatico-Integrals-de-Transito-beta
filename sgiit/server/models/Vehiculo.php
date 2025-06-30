<?php
require_once __DIR__ . '/../db.php';

class Vehiculo {
    public int    $vehiculo_id;
    public string $placa;
    public ?string $marca;
    public ?string $modelo;
    public ?int    $anio;
    public ?string $color;
    public bool   $activo;

    public static function all(): array {
        $sql = "SELECT * FROM vehiculo WHERE activo = 1";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    public static function find(int $id): ?array {
        $stmt = DB::getConnection()
                  ->prepare("SELECT * FROM vehiculo WHERE vehiculo_id = ?");
        $stmt->execute([$id]);
        $r = $stmt->fetch();
        return $r === false ? null : $r;
    }

    public static function create(array $a): int {
        $sql = "INSERT INTO vehiculo
                (placa,marca,modelo,anio,color,activo,creado_por)
                VALUES (?,?,?,?,?,1,?)";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([
            $a['placa'],
            $a['marca'] ?? null,
            $a['modelo'] ?? null,
            $a['anio'] ?? null,
            $a['color'] ?? null,
            $a['creado_por'] ?? 'system'
        ]);
        return DB::getConnection()->lastInsertId();
    }

    public static function update(int $id, array $a): bool {
        $sql = "UPDATE vehiculo SET
                placa = ?, marca = ?, modelo = ?, anio = ?, color = ?
                WHERE vehiculo_id = ?";
        $stmt = DB::getConnection()->prepare($sql);
        return $stmt->execute([
            $a['placa'],
            $a['marca'] ?? null,
            $a['modelo'] ?? null,
            $a['anio'] ?? null,
            $a['color'] ?? null,
            $id
        ]);
    }

    public static function delete(int $id): bool {
        $stmt = DB::getConnection()
                 ->prepare("UPDATE vehiculo SET activo = 0 WHERE vehiculo_id = ?");
        return $stmt->execute([$id]);
    }
}
