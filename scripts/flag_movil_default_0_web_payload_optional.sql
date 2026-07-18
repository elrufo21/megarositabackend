IF COL_LENGTH('dbo.NotaPedido', 'FlagMovil') IS NULL
BEGIN
    ALTER TABLE dbo.NotaPedido
    ADD FlagMovil bit NOT NULL
        CONSTRAINT DF_NotaPedido_FlagMovil DEFAULT (0) WITH VALUES;
END;
GO

IF SCHEMA_ID('web') IS NULL
    EXEC('CREATE SCHEMA [web]');
GO

DECLARE @constraintName sysname;
DECLARE @sql nvarchar(max);

SELECT @constraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c ON c.default_object_id = dc.object_id
JOIN sys.tables t ON t.object_id = c.object_id
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name = 'dbo'
  AND t.name = 'NotaPedido'
  AND c.name = 'FlagMovil';

IF @constraintName IS NOT NULL
BEGIN
    SET @sql = N'ALTER TABLE dbo.NotaPedido DROP CONSTRAINT ' + QUOTENAME(@constraintName) + N';';
    EXEC sp_executesql @sql;
END;

ALTER TABLE dbo.NotaPedido
ADD CONSTRAINT DF_NotaPedido_FlagMovil DEFAULT (0) FOR FlagMovil;
GO

IF OBJECT_ID('web.uspinsertarNotaB_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspinsertarNotaB_web] AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE [web].[uspinsertarNotaB_web]
    @ListaOrden varchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @orden varchar(max);
    DECLARE @resultado TABLE (Valor varchar(max));
    DECLARE @valor varchar(max);
    DECLARE @sep int;
    DECLARE @notaTexto varchar(50);
    DECLARE @notaId numeric(38,0);
    DECLARE @flagMovil bit;
    DECLARE @pos int;
    DECLARE @next int;
    DECLARE @fieldIndex int;
    DECLARE @field varchar(max);
    DECLARE @listaOrdenLegacy varchar(max);
    DECLARE @detalleGuia varchar(max);

    SET @orden = SUBSTRING(@ListaOrden, 1, CHARINDEX('[', @ListaOrden + '[') - 1);
    SET @pos = 0;
    SET @fieldIndex = 1;

    WHILE @fieldIndex <= 34
    BEGIN
        SET @next = CHARINDEX('|', @orden, @pos + 1);
        IF @next = 0 SET @next = LEN(@orden) + 1;

        SET @field = SUBSTRING(@orden, @pos + 1, @next - @pos - 1);

        IF @fieldIndex = 34 AND ISNUMERIC(@field) = 1
            SET @flagMovil = CASE WHEN CONVERT(int, @field) = 1 THEN 1 ELSE 0 END;

        SET @pos = @next;
        SET @fieldIndex = @fieldIndex + 1;
        IF @pos > LEN(@orden) BREAK;
    END;

    SET @detalleGuia = SUBSTRING(@ListaOrden, CHARINDEX('[', @ListaOrden + '['), LEN(@ListaOrden));
    IF @flagMovil IS NOT NULL
        SET @listaOrdenLegacy = LEFT(@orden, @pos - LEN(@field) - 2) + @detalleGuia;
    ELSE
        SET @listaOrdenLegacy = @ListaOrden;

    INSERT INTO @resultado (Valor)
    EXEC dbo.uspinsertarNotaB @ListaOrden = @listaOrdenLegacy;

    SELECT TOP 1 @valor = Valor FROM @resultado;
    SET @sep = CHARINDEX('¬', @valor + '¬');
    SET @notaTexto = LEFT(@valor, @sep - 1);

    IF ISNUMERIC(@notaTexto) = 1
        SET @notaId = CONVERT(numeric(38,0), @notaTexto);

    IF @notaId IS NOT NULL AND @flagMovil IS NOT NULL
    BEGIN
        UPDATE dbo.NotaPedido
        SET FlagMovil = @flagMovil
        WHERE NotaId = @notaId;
    END;

    SELECT @valor;
END;
GO
