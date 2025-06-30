<?php
require_once __DIR__ . '/../db.php';

class Infraccion {
    public string  $cod_infraccion;
    public string  $descripcion;
    public ?string $grado;
    public ?string $vigente_desde;
    public ?string $vigente_hasta;

    public static function all(): array {
        $sql = "SELECT cod_infraccion, descripcion, grado, vigente_desde, vigente_hasta
                FROM infraccion";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    public static function find(string $code): ?array {
        $stmt = DB::getConnection()
                  ->prepare("SELECT * FROM infraccion WHERE cod_infraccion = ?");
        $stmt->execute([$code]);
        $row = $stmt->fetch();
        return $row === false ? null : $row;
    }

    public static function create(array $attrs): int {
        $sql = "INSERT INTO infraccion
                (cod_infraccion, descripcion, grado, vigente_desde, vigente_hasta)
                VALUES (?, ?, ?, ?, ?)";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([
            $attrs['cod_infraccion'],
            $attrs['descripcion'],
            $attrs['grado'] ?? null,
            $attrs['vigente_desde'] ?? null,
            $attrs['vigente_hasta'] ?? null
        ]);
        return DB::getConnection()->lastInsertId();
    }

    public static function update(string $code, array $attrs): bool {
        $sql = "UPDATE infraccion SET
                descripcion    = ?,
                grado          = ?,
                vigente_desde  = ?,
                vigente_hasta  = ?
                WHERE cod_infraccion = ?";
        $stmt = DB::getConnection()->prepare($sql);
        return $stmt->execute([
            $attrs['descripcion'],
            $attrs['grado'] ?? null,
            $attrs['vigente_desde'] ?? null,
            $attrs['vigente_hasta'] ?? null,
            $code
        ]);
    }

    public static function delete(string $code): bool {
        $stmt = DB::getConnection()
                 ->prepare("DELETE FROM infraccion WHERE cod_infraccion = ?");
        return $stmt->execute([$code]);
    }
}
