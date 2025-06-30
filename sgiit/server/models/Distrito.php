<?php
require_once __DIR__ . '/../db.php';

class Distrito {
    public int     $distrito_id;
    public string  $nombre;
    public ?string $jurisdiccion;
    public string  $creado_en;
    public string  $modificado_en;
    public ?string $creado_por;

    public static function all(): array {
        $sql = "SELECT distrito_id, nombre, jurisdiccion, creado_en, modificado_en, creado_por
                FROM distrito_policial";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    public static function find(int $id): ?array {
        $stmt = DB::getConnection()
                  ->prepare("SELECT * FROM distrito_policial WHERE distrito_id = ?");
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row === false ? null : $row;
    }

    public static function create(array $attrs): int {
        $sql = "INSERT INTO distrito_policial
                (nombre, jurisdiccion, creado_por)
                VALUES (?, ?, ?)";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([
            $attrs['nombre'],
            $attrs['jurisdiccion'] ?? null,
            $attrs['creado_por'] ?? null
        ]);
        return DB::getConnection()->lastInsertId();
    }

    public static function update(int $id, array $attrs): bool {
        $sql = "UPDATE distrito_policial SET
                nombre       = ?,
                jurisdiccion = ?,
                creado_por   = ?
                WHERE distrito_id = ?";
        $stmt = DB::getConnection()->prepare($sql);
        return $stmt->execute([
            $attrs['nombre'],
            $attrs['jurisdiccion'] ?? null,
            $attrs['creado_por'] ?? null,
            $id
        ]);
    }

    public static function delete(int $id): bool {
        $stmt = DB::getConnection()
                 ->prepare("DELETE FROM distrito_policial WHERE distrito_id = ?");
        return $stmt->execute([$id]);
    }
}
