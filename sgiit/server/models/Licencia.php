<?php
require_once __DIR__ . '/../db.php';

class Licencia {
    public int    $licencia_id;
    public int    $persona_id;
    public string $categoria;
    public string $fecha_emision;
    public string $fecha_vencimiento;
    public string $estado;
    public string $creado_en;
    public string $modificado_en;
    public ?string $creado_por;

    public static function all(): array {
        $sql = "SELECT * FROM licencia";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    public static function find(int $id): ?array {
        $stmt = DB::getConnection()
                  ->prepare("SELECT * FROM licencia WHERE licencia_id = ?");
        $stmt->execute([$id]);
        $data = $stmt->fetch();
        return $data === false ? null : $data;
    }

    public static function create(array $attrs): int {
        $sql = "INSERT INTO licencia
                (persona_id, categoria, fecha_emision, fecha_vencimiento, estado, creado_por)
                VALUES (?, ?, ?, ?, ?, ?)";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([
            $attrs['persona_id'],
            $attrs['categoria'],
            $attrs['fecha_emision'],
            $attrs['fecha_vencimiento'],
            $attrs['estado'] ?? 'VIGENTE',
            $attrs['creado_por'] ?? null
        ]);
        return DB::getConnection()->lastInsertId();
    }

    public static function update(int $id, array $attrs): bool {
        $sql = "UPDATE licencia SET
                persona_id = ?, categoria = ?, fecha_emision = ?,
                fecha_vencimiento = ?, estado = ?, creado_por = ?
                WHERE licencia_id = ?";
        $stmt = DB::getConnection()->prepare($sql);
        return $stmt->execute([
            $attrs['persona_id'],
            $attrs['categoria'],
            $attrs['fecha_emision'],
            $attrs['fecha_vencimiento'],
            $attrs['estado'],
            $attrs['creado_por'] ?? null,
            $id
        ]);
    }

    public static function delete(int $id): bool {
        $stmt = DB::getConnection()
                 ->prepare("DELETE FROM licencia WHERE licencia_id = ?");
        return $stmt->execute([$id]);
    }
}
