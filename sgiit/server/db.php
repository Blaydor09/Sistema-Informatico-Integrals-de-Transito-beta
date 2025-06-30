<?php
class DB {
    private static ?PDO $conn = null;

    public static function getConnection(): PDO {
        if (self::$conn === null) {
            $host   = '127.0.0.1';
            $db     = 'gestion_incidentes';
            $user   = 'root';
            $pass   = '';
            $charset= 'utf8mb4';

            $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
            $opts = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ];
            self::$conn = new PDO($dsn, $user, $pass, $opts);
        }
        return self::$conn;
    }
}
