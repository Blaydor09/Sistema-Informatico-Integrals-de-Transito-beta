<?php
require_once __DIR__ . '/../db.php';

class Via {
    public int     $via_id;
    public ?string $tipo;
    public ?string $descripcion;

    public static function all(): array {
        $sql = "SELECT via_id, tipo, descripcion FROM via";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    public static function find(int $id): ?array {
        $stmt = DB::getConnection()
                  ->prepare("SELECT * FROM via WHERE via_id = ?");
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        return $row === false ? null : $row;
    }

    public static function create(array $attrs): int {
        $sql = "INSERT INTO via (tipo, descripcion) VALUES (?, ?)";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([
            $attrs['tipo'] ?? null,
            $attrs['descripcion'] ?? null
        ]);
        return DB::getConnection()->lastInsertId();
    }

    public static function update(int $id, array $attrs): bool {
        $sql = "UPDATE via SET
                tipo        = ?,
                descripcion = ?
                WHERE via_id = ?";
        $stmt = DB::getConnection()->prepare($sql);
        return $stmt->execute([
            $attrs['tipo'] ?? null,
            $attrs['descripcion'] ?? null,
            $id
        ]);
    }

    public static function delete(int $id): bool {
        $stmt = DB::getConnection()
                 ->prepare("DELETE FROM via WHERE via_id = ?");
        return $stmt->execute([$id]);
    }
}
