-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-06-2025 a las 16:29:49
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gestion_incidentes`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

CREATE TABLE `bitacora` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` int(10) UNSIGNED DEFAULT NULL,
  `tabla_nombre` varchar(50) DEFAULT NULL,
  `operacion` enum('INSERT','UPDATE','DELETE','SELECT') DEFAULT NULL,
  `registro_id` varchar(100) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT current_timestamp(),
  `detalles` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conductor`
--

CREATE TABLE `conductor` (
  `persona_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `conductor`
--

INSERT INTO `conductor` (`persona_id`) VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conductor_seguro`
--

CREATE TABLE `conductor_seguro` (
  `persona_id` int(10) UNSIGNED NOT NULL,
  `seguro_id` int(10) UNSIGNED NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `conductor_seguro`
--

INSERT INTO `conductor_seguro` (`persona_id`, `seguro_id`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 1, '2024-01-01', NULL),
(2, 2, '2023-05-01', NULL),
(3, 1, '2024-11-10', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `danio`
--

CREATE TABLE `danio` (
  `danio_id` int(10) UNSIGNED NOT NULL,
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `tipo` enum('MATERIAL','ORNATO','HUMANO') NOT NULL,
  `descripcion` text DEFAULT NULL,
  `costo_estimado` decimal(12,2) DEFAULT NULL,
  `lesion_id` int(10) UNSIGNED DEFAULT NULL,
  `fallecido` tinyint(1) DEFAULT NULL,
  `num_victimas` int(11) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `danio`
--

INSERT INTO `danio` (`danio_id`, `incidente_id`, `tipo`, `descripcion`, `costo_estimado`, `lesion_id`, `fallecido`, `num_victimas`, `creado_en`) VALUES
(1, 2, 'MATERIAL', 'Daño frontal Toyota Corolla', 1200.00, NULL, 0, NULL, '2025-06-29 10:19:44'),
(2, 2, 'MATERIAL', 'Poste alumbrado público destruido', 900.00, NULL, 0, NULL, '2025-06-29 10:19:44'),
(3, 2, 'HUMANO', 'Fractura conductor Nissan', NULL, 2, 0, 1, '2025-06-29 10:19:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `distrito_policial`
--

CREATE TABLE `distrito_policial` (
  `distrito_id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `jurisdiccion` varchar(100) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  `modificado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `distrito_policial`
--

INSERT INTO `distrito_policial` (`distrito_id`, `nombre`, `jurisdiccion`, `creado_en`, `modificado_en`, `creado_por`) VALUES
(1, 'DP-Centro', '1.er Anillo', '2025-06-29 10:15:25', '2025-06-29 10:15:25', 'admin'),
(2, 'DP-Norte', 'Radial 17½', '2025-06-29 10:15:25', '2025-06-29 10:15:25', 'admin'),
(3, 'DP-Sur', 'Doble Vía La Guardia', '2025-06-29 10:15:25', '2025-06-29 10:15:25', 'admin');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidente`
--

CREATE TABLE `incidente` (
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `tipo` enum('INFRACCION','ACCIDENTE') NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `distrito_id` int(10) UNSIGNED NOT NULL,
  `via_id` int(10) UNSIGNED DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  `modificado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Evento de infracción o accidente';

--
-- Volcado de datos para la tabla `incidente`
--

INSERT INTO `incidente` (`incidente_id`, `tipo`, `fecha_hora`, `direccion`, `distrito_id`, `via_id`, `creado_en`, `modificado_en`, `creado_por`) VALUES
(1, 'INFRACCION', '2025-06-15 18:45:00', 'Av. Cristo Redentor 5.º anillo', 1, 1, '2025-06-29 10:18:37', '2025-06-29 10:18:37', 'lvargas'),
(2, 'ACCIDENTE', '2025-06-20 22:10:00', 'Autopista Norte km 14', 2, 3, '2025-06-29 10:19:12', '2025-06-29 10:19:12', 'dclaros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidente_conductor`
--

CREATE TABLE `incidente_conductor` (
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `persona_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `incidente_conductor`
--

INSERT INTO `incidente_conductor` (`incidente_id`, `persona_id`) VALUES
(1, 1),
(2, 2),
(2, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidente_infraccion`
--

CREATE TABLE `incidente_infraccion` (
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `cod_infraccion` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `incidente_infraccion`
--

INSERT INTO `incidente_infraccion` (`incidente_id`, `cod_infraccion`) VALUES
(1, 'B141'),
(2, 'C142');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidente_oficial`
--

CREATE TABLE `incidente_oficial` (
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `persona_id` int(10) UNSIGNED NOT NULL,
  `rol` enum('RESPONSABLE','COLABORADOR') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `incidente_oficial`
--

INSERT INTO `incidente_oficial` (`incidente_id`, `persona_id`, `rol`) VALUES
(1, 7, 'RESPONSABLE'),
(2, 7, 'COLABORADOR'),
(2, 8, 'RESPONSABLE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `infraccion`
--

CREATE TABLE `infraccion` (
  `cod_infraccion` varchar(20) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `grado` varchar(20) DEFAULT NULL,
  `vigente_desde` date DEFAULT NULL,
  `vigente_hasta` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `infraccion`
--

INSERT INTO `infraccion` (`cod_infraccion`, `descripcion`, `grado`, `vigente_desde`, `vigente_hasta`) VALUES
('A140', 'Circular con luz roja', 'LEVE', '2020-01-01', NULL),
('B141', 'Exceso de velocidad >20 km/h', 'GRAVE', '2020-01-01', NULL),
('C142', 'Conducir ebrio', 'MUY GRAVE', '2020-01-01', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `licencia`
--

CREATE TABLE `licencia` (
  `licencia_id` int(10) UNSIGNED NOT NULL,
  `persona_id` int(10) UNSIGNED NOT NULL,
  `categoria` varchar(10) NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `estado` enum('VIGENTE','SUSPENDIDA','VENCIDA') DEFAULT 'VIGENTE',
  `creado_en` datetime DEFAULT current_timestamp(),
  `modificado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `licencia`
--

INSERT INTO `licencia` (`licencia_id`, `persona_id`, `categoria`, `fecha_emision`, `fecha_vencimiento`, `estado`, `creado_en`, `modificado_en`, `creado_por`) VALUES
(1, 1, 'B', '2021-05-10', '2026-05-10', 'VIGENTE', '2025-06-29 10:18:23', '2025-06-29 10:18:23', 'sef'),
(2, 2, 'C', '2019-03-02', '2024-03-02', 'VENCIDA', '2025-06-29 10:18:23', '2025-06-29 10:18:23', 'sef'),
(3, 3, 'A', '2022-11-30', '2027-11-30', 'VIGENTE', '2025-06-29 10:18:23', '2025-06-29 10:18:23', 'sef');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `multa`
--

CREATE TABLE `multa` (
  `multa_id` int(10) UNSIGNED NOT NULL,
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PAGADA') DEFAULT 'PENDIENTE',
  `fecha_emision` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `multa`
--

INSERT INTO `multa` (`multa_id`, `incidente_id`, `monto`, `estado`, `fecha_emision`) VALUES
(1, 1, 350.00, 'PENDIENTE', '2025-06-16'),
(2, 2, 1200.00, 'PENDIENTE', '2025-06-21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oficial`
--

CREATE TABLE `oficial` (
  `persona_id` int(10) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `rango` varchar(50) DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `oficial`
--

INSERT INTO `oficial` (`persona_id`, `matricula`, `rango`, `fecha_ingreso`) VALUES
(7, 'OF-4587', 'Sgto. 1.º', '2010-05-12'),
(8, 'OF-4620', 'Cbo.', '2012-08-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_history`
--

CREATE TABLE `password_history` (
  `hist_id` int(10) UNSIGNED NOT NULL,
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `cambiado_en` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `persona_id` int(10) UNSIGNED NOT NULL,
  `ci` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `fecha_nac` date DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  `modificado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`persona_id`, `ci`, `nombre`, `apellidos`, `fecha_nac`, `direccion`, `telefono`, `email`, `creado_en`, `modificado_en`, `activo`) VALUES
(1, '1234567 SC', 'Juan', 'Flores Hurtado', '1985-03-21', 'Av. Alemania #1234', '70011122', 'juan.flores@email.com', '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(2, '3456789 SC', 'María', 'Rojas Vda. de Ruiz', '1976-11-05', 'C/ Aroma #78', '70022233', 'maria.rojas@email.com', '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(3, '5678901 SC', 'Carlos', 'Paz Zambrana', '1990-07-15', 'Av. Santos Dumont km 6', '70033344', 'cpaz@email.com', '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(4, '7890123 SC', 'Ana', 'Rivera Pinto', '1993-12-30', 'Condominio Las Palmas 3-B', '70044455', 'ana.rivera@email.com', '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(5, '9012345 SC', 'Bruno', 'Suárez Mérida', '1982-04-10', 'C/ Libertad #456', '70055566', 'bruno.suarez@email.com', '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(6, '1122334 SC', 'Elena', 'Gutiérrez Alanes', '1988-09-02', 'Barrio Equipetrol N-23', '70066677', 'elena.ga@email.com', '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(7, '9988776 SC', 'Of. Luis', 'Vargas Arauz', '1980-01-18', 'Unidad de Tránsito', '70077788', NULL, '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1),
(8, '8877665 SC', 'Of. Diego', 'Claros Serrano', '1978-06-09', 'Unidad de Tránsito', '70088899', NULL, '2025-06-29 10:15:02', '2025-06-29 10:15:02', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona_vehiculo`
--

CREATE TABLE `persona_vehiculo` (
  `persona_id` int(10) UNSIGNED NOT NULL,
  `vehiculo_id` int(10) UNSIGNED NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona_vehiculo`
--

INSERT INTO `persona_vehiculo` (`persona_id`, `vehiculo_id`, `fecha`) VALUES
(1, 1, '2020-02-14'),
(2, 2, '2021-06-20'),
(3, 3, '2023-01-08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `rol_id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `nombre`, `descripcion`) VALUES
(1, 'ADMINISTRADOR', 'Acceso total'),
(2, 'AUDITOR', 'Acceso a reportes y bitácora'),
(3, 'OPERADOR', 'Registra y actualiza incidentes'),
(4, 'CONSULTA', 'Sólo lectura');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seguro`
--

CREATE TABLE `seguro` (
  `seguro_id` int(10) UNSIGNED NOT NULL,
  `nombre_compania` varchar(100) NOT NULL,
  `poliza` varchar(100) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  `modificado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `seguro`
--

INSERT INTO `seguro` (`seguro_id`, `nombre_compania`, `poliza`, `creado_en`, `modificado_en`, `creado_por`) VALUES
(1, 'La Boliviana Ciacruz', 'LBC-PZ-2025-0001', '2025-06-29 10:16:24', '2025-06-29 10:16:24', 'admin'),
(2, 'Nacional Seguros', 'NS-2025-XZ-0009', '2025-06-29 10:16:24', '2025-06-29 10:16:24', 'admin');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testigo`
--

CREATE TABLE `testigo` (
  `testigo_id` int(10) UNSIGNED NOT NULL,
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `persona_id` int(10) UNSIGNED DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `declaracion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `testigo`
--

INSERT INTO `testigo` (`testigo_id`, `incidente_id`, `persona_id`, `nombre`, `telefono`, `declaracion`) VALUES
(1, 2, NULL, 'José Aguilar', '70099988', 'Observó que la camioneta invadió carril');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `test_alcoholemia`
--

CREATE TABLE `test_alcoholemia` (
  `test_id` int(10) UNSIGNED NOT NULL,
  `incidente_id` int(10) UNSIGNED NOT NULL,
  `oficial_id` int(10) UNSIGNED NOT NULL,
  `conductor_id` int(10) UNSIGNED NOT NULL,
  `nivel_alcohol` decimal(4,2) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `creado_en` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `test_alcoholemia`
--

INSERT INTO `test_alcoholemia` (`test_id`, `incidente_id`, `oficial_id`, `conductor_id`, `nivel_alcohol`, `fecha_hora`, `creado_en`) VALUES
(1, 2, 7, 2, 0.00, '2025-06-20 22:25:00', '2025-06-29 10:19:58'),
(2, 2, 7, 3, 0.45, '2025-06-20 22:30:00', '2025-06-29 10:19:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_lesion`
--

CREATE TABLE `tipo_lesion` (
  `lesion_id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `gravedad` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_lesion`
--

INSERT INTO `tipo_lesion` (`lesion_id`, `nombre`, `gravedad`) VALUES
(1, 'Contusión leve', 'BAJA'),
(2, 'Fractura expuesta', 'ALTA'),
(3, 'Fallecimiento', 'MORTAL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `persona_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `fecha_ultimo_cambio` datetime DEFAULT NULL,
  `fecha_expiracion` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`usuario_id`, `persona_id`, `username`, `password_hash`, `fecha_creacion`, `fecha_ultimo_cambio`, `fecha_expiracion`, `activo`) VALUES
(1, 7, 'lvargas', '$2y$12$9dQ1JRmA5skw1yy1lvargasHash', '2025-06-29 10:17:29', '2025-06-01 00:00:00', NULL, 1),
(2, 8, 'dclaros', '$2y$12$3hA2ZTUiHt.dclarosHash', '2025-06-29 10:17:29', '2025-06-01 00:00:00', NULL, 1),
(3, 1, 'jflores', '$2y$12$Tf7g..jfloresHash', '2025-06-29 10:17:29', '2025-06-10 00:00:00', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_rol`
--

CREATE TABLE `usuario_rol` (
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `rol_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_rol`
--

INSERT INTO `usuario_rol` (`usuario_id`, `rol_id`) VALUES
(1, 1),
(2, 3),
(3, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculo`
--

CREATE TABLE `vehiculo` (
  `vehiculo_id` int(10) UNSIGNED NOT NULL,
  `placa` varchar(20) NOT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `anio` smallint(6) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp(),
  `modificado_en` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  `creado_por` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vehiculo`
--

INSERT INTO `vehiculo` (`vehiculo_id`, `placa`, `marca`, `modelo`, `anio`, `color`, `creado_en`, `modificado_en`, `activo`, `creado_por`) VALUES
(1, '4565-ZTS', 'Toyota', 'Corolla', 2017, 'Gris Plata', '2025-06-29 10:17:55', '2025-06-29 10:17:55', 1, 'jflores'),
(2, '7788-LKE', 'Nissan', 'Frontier', 2019, 'Blanco', '2025-06-29 10:17:55', '2025-06-29 10:17:55', 1, 'msistema'),
(3, '9988-BHG', 'Suzuki', 'Vitara', 2021, 'Rojo', '2025-06-29 10:17:55', '2025-06-29 10:17:55', 1, 'msistema');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `via`
--

CREATE TABLE `via` (
  `via_id` int(10) UNSIGNED NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `via`
--

INSERT INTO `via` (`via_id`, `tipo`, `descripcion`) VALUES
(1, 'Avenida', 'Avenida Cristo Redentor'),
(2, 'Calle', 'Calle Libertad esq. Junín'),
(3, 'Autopista', 'Autopista al Norte, km 14');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `fk_bitacora_usuario` (`usuario_id`);

--
-- Indices de la tabla `conductor`
--
ALTER TABLE `conductor`
  ADD PRIMARY KEY (`persona_id`);

--
-- Indices de la tabla `conductor_seguro`
--
ALTER TABLE `conductor_seguro`
  ADD PRIMARY KEY (`persona_id`,`seguro_id`,`fecha_inicio`),
  ADD KEY `fk_cs_seguro` (`seguro_id`);

--
-- Indices de la tabla `danio`
--
ALTER TABLE `danio`
  ADD PRIMARY KEY (`danio_id`),
  ADD KEY `fk_danio_incidente` (`incidente_id`),
  ADD KEY `fk_danio_lesion` (`lesion_id`);

--
-- Indices de la tabla `distrito_policial`
--
ALTER TABLE `distrito_policial`
  ADD PRIMARY KEY (`distrito_id`);

--
-- Indices de la tabla `incidente`
--
ALTER TABLE `incidente`
  ADD PRIMARY KEY (`incidente_id`),
  ADD KEY `fk_inc_distrito` (`distrito_id`),
  ADD KEY `fk_inc_via` (`via_id`),
  ADD KEY `idx_incidente_tipo_fecha` (`tipo`,`fecha_hora`);

--
-- Indices de la tabla `incidente_conductor`
--
ALTER TABLE `incidente_conductor`
  ADD PRIMARY KEY (`incidente_id`,`persona_id`),
  ADD KEY `fk_ic_conductor` (`persona_id`);

--
-- Indices de la tabla `incidente_infraccion`
--
ALTER TABLE `incidente_infraccion`
  ADD PRIMARY KEY (`incidente_id`,`cod_infraccion`),
  ADD KEY `fk_ii_infraccion` (`cod_infraccion`);

--
-- Indices de la tabla `incidente_oficial`
--
ALTER TABLE `incidente_oficial`
  ADD PRIMARY KEY (`incidente_id`,`persona_id`),
  ADD KEY `fk_io_oficial` (`persona_id`);

--
-- Indices de la tabla `infraccion`
--
ALTER TABLE `infraccion`
  ADD PRIMARY KEY (`cod_infraccion`);

--
-- Indices de la tabla `licencia`
--
ALTER TABLE `licencia`
  ADD PRIMARY KEY (`licencia_id`),
  ADD UNIQUE KEY `uq_licencia_vigencia` (`persona_id`,`categoria`,`fecha_emision`);

--
-- Indices de la tabla `multa`
--
ALTER TABLE `multa`
  ADD PRIMARY KEY (`multa_id`),
  ADD KEY `fk_multa_incidente` (`incidente_id`);

--
-- Indices de la tabla `oficial`
--
ALTER TABLE `oficial`
  ADD PRIMARY KEY (`persona_id`),
  ADD UNIQUE KEY `matricula` (`matricula`);

--
-- Indices de la tabla `password_history`
--
ALTER TABLE `password_history`
  ADD PRIMARY KEY (`hist_id`),
  ADD KEY `fk_ph_usuario` (`usuario_id`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`persona_id`),
  ADD UNIQUE KEY `ci` (`ci`),
  ADD KEY `idx_persona_apellidos` (`apellidos`);

--
-- Indices de la tabla `persona_vehiculo`
--
ALTER TABLE `persona_vehiculo`
  ADD PRIMARY KEY (`persona_id`,`vehiculo_id`,`fecha`),
  ADD KEY `fk_pv_vehiculo` (`vehiculo_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`rol_id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `seguro`
--
ALTER TABLE `seguro`
  ADD PRIMARY KEY (`seguro_id`);

--
-- Indices de la tabla `testigo`
--
ALTER TABLE `testigo`
  ADD PRIMARY KEY (`testigo_id`),
  ADD KEY `fk_tg_incidente` (`incidente_id`),
  ADD KEY `fk_tg_persona` (`persona_id`);

--
-- Indices de la tabla `test_alcoholemia`
--
ALTER TABLE `test_alcoholemia`
  ADD PRIMARY KEY (`test_id`),
  ADD UNIQUE KEY `uq_test_inc_cond` (`incidente_id`,`conductor_id`),
  ADD KEY `fk_ta_oficial` (`oficial_id`),
  ADD KEY `fk_ta_conductor` (`conductor_id`);

--
-- Indices de la tabla `tipo_lesion`
--
ALTER TABLE `tipo_lesion`
  ADD PRIMARY KEY (`lesion_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`usuario_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_usuario_persona` (`persona_id`);

--
-- Indices de la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
  ADD PRIMARY KEY (`usuario_id`,`rol_id`),
  ADD KEY `fk_usrrol_rol` (`rol_id`);

--
-- Indices de la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  ADD PRIMARY KEY (`vehiculo_id`),
  ADD UNIQUE KEY `placa` (`placa`),
  ADD KEY `idx_vehiculo_marca_modelo` (`marca`,`modelo`);

--
-- Indices de la tabla `via`
--
ALTER TABLE `via`
  ADD PRIMARY KEY (`via_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bitacora`
--
ALTER TABLE `bitacora`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `danio`
--
ALTER TABLE `danio`
  MODIFY `danio_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `distrito_policial`
--
ALTER TABLE `distrito_policial`
  MODIFY `distrito_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `incidente`
--
ALTER TABLE `incidente`
  MODIFY `incidente_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `licencia`
--
ALTER TABLE `licencia`
  MODIFY `licencia_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `multa`
--
ALTER TABLE `multa`
  MODIFY `multa_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `password_history`
--
ALTER TABLE `password_history`
  MODIFY `hist_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `persona_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `rol_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `seguro`
--
ALTER TABLE `seguro`
  MODIFY `seguro_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `testigo`
--
ALTER TABLE `testigo`
  MODIFY `testigo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `test_alcoholemia`
--
ALTER TABLE `test_alcoholemia`
  MODIFY `test_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipo_lesion`
--
ALTER TABLE `tipo_lesion`
  MODIFY `lesion_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `usuario_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  MODIFY `vehiculo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `via`
--
ALTER TABLE `via`
  MODIFY `via_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD CONSTRAINT `fk_bitacora_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`usuario_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `conductor`
--
ALTER TABLE `conductor`
  ADD CONSTRAINT `fk_conductor_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`persona_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `conductor_seguro`
--
ALTER TABLE `conductor_seguro`
  ADD CONSTRAINT `fk_cs_conductor` FOREIGN KEY (`persona_id`) REFERENCES `conductor` (`persona_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cs_seguro` FOREIGN KEY (`seguro_id`) REFERENCES `seguro` (`seguro_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `danio`
--
ALTER TABLE `danio`
  ADD CONSTRAINT `fk_danio_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_danio_lesion` FOREIGN KEY (`lesion_id`) REFERENCES `tipo_lesion` (`lesion_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `incidente`
--
ALTER TABLE `incidente`
  ADD CONSTRAINT `fk_inc_distrito` FOREIGN KEY (`distrito_id`) REFERENCES `distrito_policial` (`distrito_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inc_via` FOREIGN KEY (`via_id`) REFERENCES `via` (`via_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `incidente_conductor`
--
ALTER TABLE `incidente_conductor`
  ADD CONSTRAINT `fk_ic_conductor` FOREIGN KEY (`persona_id`) REFERENCES `conductor` (`persona_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ic_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `incidente_infraccion`
--
ALTER TABLE `incidente_infraccion`
  ADD CONSTRAINT `fk_ii_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ii_infraccion` FOREIGN KEY (`cod_infraccion`) REFERENCES `infraccion` (`cod_infraccion`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `incidente_oficial`
--
ALTER TABLE `incidente_oficial`
  ADD CONSTRAINT `fk_io_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_io_oficial` FOREIGN KEY (`persona_id`) REFERENCES `oficial` (`persona_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `licencia`
--
ALTER TABLE `licencia`
  ADD CONSTRAINT `fk_licencia_conductor` FOREIGN KEY (`persona_id`) REFERENCES `conductor` (`persona_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `multa`
--
ALTER TABLE `multa`
  ADD CONSTRAINT `fk_multa_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `oficial`
--
ALTER TABLE `oficial`
  ADD CONSTRAINT `fk_oficial_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`persona_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `password_history`
--
ALTER TABLE `password_history`
  ADD CONSTRAINT `fk_ph_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`usuario_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `persona_vehiculo`
--
ALTER TABLE `persona_vehiculo`
  ADD CONSTRAINT `fk_pv_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`persona_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pv_vehiculo` FOREIGN KEY (`vehiculo_id`) REFERENCES `vehiculo` (`vehiculo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `testigo`
--
ALTER TABLE `testigo`
  ADD CONSTRAINT `fk_tg_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tg_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`persona_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `test_alcoholemia`
--
ALTER TABLE `test_alcoholemia`
  ADD CONSTRAINT `fk_ta_conductor` FOREIGN KEY (`conductor_id`) REFERENCES `conductor` (`persona_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ta_incidente` FOREIGN KEY (`incidente_id`) REFERENCES `incidente` (`incidente_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ta_oficial` FOREIGN KEY (`oficial_id`) REFERENCES `oficial` (`persona_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`persona_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
  ADD CONSTRAINT `fk_usrrol_rol` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usrrol_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`usuario_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
