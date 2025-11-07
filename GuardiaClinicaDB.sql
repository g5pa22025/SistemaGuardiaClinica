-- Crear base de datos
CREATE DATABASE GuardiaClinicaDB;
GO

USE GuardiaClinicaDB;
GO

-- Tabla de Roles
CREATE TABLE Roles (
    Id INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(100)
);

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    Id INT PRIMARY KEY IDENTITY,
    DNI NVARCHAR(10) UNIQUE NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    RolId INT NOT NULL FOREIGN KEY REFERENCES Roles(Id),
    Especialidad NVARCHAR(50) NULL,
    Activo BIT DEFAULT 1
);

-- Tabla de Pacientes
CREATE TABLE Pacientes (
    Id INT PRIMARY KEY IDENTITY,
    DNI NVARCHAR(10) UNIQUE NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Genero NVARCHAR(10) NOT NULL,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(200),
    ObraSocial NVARCHAR(100),
    NumeroAfiliado NVARCHAR(50),
    Prioridad INT NOT NULL CHECK (Prioridad BETWEEN 1 AND 5),
    Estado NVARCHAR(20) DEFAULT 'Espera'
);

-- Tabla de Guardias
CREATE TABLE Guardias (
    Id INT PRIMARY KEY IDENTITY,
    PacienteId INT NOT NULL FOREIGN KEY REFERENCES Pacientes(Id),
    FechaIngreso DATETIME NOT NULL,
    RecepcionistaId INT NOT NULL FOREIGN KEY REFERENCES Usuarios(Id),
    EnfermeroId INT NULL FOREIGN KEY REFERENCES Usuarios(Id),
    MedicoId INT NULL FOREIGN KEY REFERENCES Usuarios(Id),
    EspecialidadRequerida NVARCHAR(50),
    Sintomas NVARCHAR(500),
    ObservacionesEnfermero NVARCHAR(500),
    DiagnosticoMedico NVARCHAR(1000),
    Medicamentos NVARCHAR(500),
    Estado NVARCHAR(20) DEFAULT 'Espera',
    PrioridadFinal INT NULL CHECK (PrioridadFinal BETWEEN 1 AND 5)
);

-- Insertar datos iniciales
INSERT INTO Roles (Nombre, Descripcion) VALUES 
('Recepcionista', 'Registra pacientes y asigna a guardia'),
('Enfermero', 'Realiza triaje y deriva a especialistas'),
('Medico', 'Atiende pacientes y genera diagnósticos');

INSERT INTO Usuarios (DNI, Nombre, Apellido, Email, Password, RolId, Especialidad) VALUES 
('30123456', 'Carlos', 'Lopez', 'recepcion@clinica.com', '123456', 1, NULL),
('30234567', 'Ana', 'Gomez', 'enfermeria@clinica.com', '123456', 2, NULL),
('30345678', 'Dr. Juan', 'Perez', 'cardio@clinica.com', '123456', 3, 'Cardiología'),
('30456789', 'Dra. Maria', 'Rodriguez', 'trauma@clinica.com', '123456', 3, 'Traumatología'),
('30567890', 'Dr. Roberto', 'Silva', 'pediatria@clinica.com', '123456', 3, 'Pediatría');

-- Insertar algunos pacientes de ejemplo
INSERT INTO Pacientes (DNI, Nombre, Apellido, FechaNacimiento, Genero, Telefono, Email, Direccion, ObraSocial, NumeroAfiliado, Prioridad, Estado) VALUES 
('40123456', 'Luis', 'Garcia', '1985-03-15', 'Masculino', '1156789012', 'luis.garcia@email.com', 'Av. Siempre Viva 123', 'OSDE', '12345678', 2, 'Espera'),
('40234567', 'Maria', 'Lopez', '1978-07-22', 'Femenino', '1167890123', 'maria.lopez@email.com', 'Calle Falsa 456', 'Swiss Medical', '87654321', 3, 'Espera'),
('40345678', 'Pedro', 'Martinez', '1990-12-05', 'Masculino', '1145678901', 'pedro.martinez@email.com', 'Av. Libertador 789', 'Galeno', '11223344', 1, 'Espera');

-- Insertar algunas guardias de ejemplo
INSERT INTO Guardias (PacienteId, FechaIngreso, RecepcionistaId, Sintomas, Estado) VALUES 
(1, GETDATE(), 1, 'Dolor de cabeza y fiebre', 'Espera'),
(2, GETDATE(), 1, 'Dolor abdominal intenso', 'Espera'),
(3, GETDATE(), 1, 'Control rutinario', 'Espera');

PRINT 'Base de datos creada exitosamente!';