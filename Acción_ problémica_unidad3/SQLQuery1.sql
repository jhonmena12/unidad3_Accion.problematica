USE DivisionPolitica
GO

IF OBJECT_ID('Moneda', 'U') IS NOT NULL
	DROP TABLE Moneda
GO

CREATE TABLE Moneda(
	Id INT IDENTITY(1,1) NOT NULL,
	CONSTRAINT pkMoneda_Id PRIMARY KEY (Id),
	Nombre NVARCHAR(30) NOT NULL,
	Simbolo NVARCHAR(10) NULL
)
GO

/* 2️⃣ Agregar una columna temporal IdMoneda a la tabla Pais */
ALTER TABLE Pais
ADD IdMoneda INT NULL
GO

/* 3️⃣ Insertar las monedas existentes y relacionarlas con los países */
-- Insertar las monedas únicas que existían en la columna Pais.Moneda
INSERT INTO Moneda (Nombre)
SELECT DISTINCT Moneda
FROM Pais
WHERE Moneda IS NOT NULL
GO

-- Actualizar la relación en la tabla Pais
UPDATE P
SET P.IdMoneda = M.Id
FROM Pais P
JOIN Moneda M ON P.Moneda = M.Nombre
GO

/* 4️⃣ Eliminar la antigua columna Moneda */
ALTER TABLE Pais
DROP COLUMN Moneda
GO

/* 5️⃣ Crear la relación entre Pais y Moneda */
ALTER TABLE Pais
ADD CONSTRAINT fkPais_IdMoneda FOREIGN KEY (IdMoneda)
	REFERENCES Moneda(Id)
GO

/* 6️⃣ Agregar los campos para las imágenes del mapa y la bandera */
ALTER TABLE Pais
ADD Mapa VARBINARY(MAX) NULL,
	Bandera VARBINARY(MAX) NULL
GO

/* 7️⃣ Verificar los cambios */
SELECT P.Id, P.Nombre AS Pais, M.Nombre AS Moneda, P.Mapa, P.Bandera
FROM Pais P
LEFT JOIN Moneda M ON P.IdMoneda = M.Id
GO