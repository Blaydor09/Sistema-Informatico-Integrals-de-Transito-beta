<?php
require_once __DIR__ . '/../db.php';

class Usuario {
    public int    $usuario_id;
    public ?int   $persona_id;
    public string $username;
    public string $password_hash;
    public bool   $activo;

    /** Busca un usuario activo por username */
    public static function findByUsername(string $username): ?array {
        $sql = "SELECT usuario_id, persona_id, username, password_hash, activo
                FROM usuario
                WHERE username = ? AND activo = 1";
        $stmt = DB::getConnection()->prepare($sql);
        $stmt->execute([$username]);
        $u = $stmt->fetch();
        return $u === false ? null : $u;
    }

    /** Verifica credenciales */
    public static function authenticate(string $username, string $password): ?array {
        $user = self::findByUsername($username);
        if (!$user) {
            return null;
        }
        // Usamos bcrypt (hashes con $2y$12…) :contentReference[oaicite:0]{index=0} :contentReference[oaicite:1]{index=1}
        if (password_verify($password, $user['password_hash'])) {
            return $user;
        }
        return null;
    }
}
