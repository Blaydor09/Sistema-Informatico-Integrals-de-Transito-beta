<?php
require_once __DIR__ . '/../db.php';

class Persona {
    public int    $persona_id;
    public string $ci;
    public string $nombre;
    public string $apellidos;
    public ?string $fecha_nac;
    public ?string $direccion;
    public ?string $telefono;
    public ?string $email;
    public bool   $activo;

    public static function all(): array {
        $sql = "SELECT * FROM persona WHERE activo = 1";
        return DB::getConnection()->query($sql)->fetchAll();
    }

    public static function find(int $id): ?array {
        $stmt = DB::getConnection()
                  ->prepare("SELECT * FROM persona WHERE persona_id = ?");
        $stmt->execute([$id]);
        $data = $stmt->fetch();
        return $data === false ? null : $data;
    }

    public static function create(array $attrs): int {
        $sql = "INSERT INTO persona
                (ci,nombre,apellidos,fecha_nac,direccion,telefono,email,activo)
                VALUES (?,?,?,?,?,?,?,1)";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([
            $attrs['ci'],
            $attrs['nombre'],
            $attrs['apellidos'],
            $attrs['fecha_nac'] ?? null,
            $attrs['direccion'] ?? null,
            $attrs['telefono'] ?? null,
            $attrs['email'] ?? null
        ]);
        return DB::getConnection()->lastInsertId();
    }

    public static function update(int $id, array $attrs): bool {
        $sql = "UPDATE persona SET
                ci = ?, nombre = ?, apellidos = ?, fecha_nac = ?,
                direccion = ?, telefono = ?, email = ?
                WHERE persona_id = ?";
        $stmt = DB::getConnection()->prepare($sql);
        return $stmt->execute([
            $attrs['ci'],
            $attrs['nombre'],
            $attrs['apellidos'],
            $attrs['fecha_nac'] ?? null,
            $attrs['direccion'] ?? null,
            $attrs['telefono'] ?? null,
            $attrs['email'] ?? null,
            $id
        ]);
    }

    public static function delete(int $id): bool {
        // Borrado lógico
        $stmt = DB::getConnection()
                 ->prepare("UPDATE persona SET activo = 0 WHERE persona_id = ?");
        return $stmt->execute([$id]);
    }
}
