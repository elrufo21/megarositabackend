SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

IF COL_LENGTH('dbo.Compania', 'Descuento') IS NULL
BEGIN
    ALTER TABLE dbo.Compania
        ADD Descuento DECIMAL(18, 2) NULL;
END;

UPDATE dbo.Compania
SET Descuento = ISNULL(Descuento, DescuentoMax)
WHERE Descuento IS NULL;

COMMIT TRANSACTION;
GO

IF OBJECT_ID('dbo.uspValidaUsuarioWeb', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.uspValidaUsuarioWeb AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE [dbo].[uspValidaUsuarioWeb]
    @Data VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @p1 INT, @p2 INT;
    DECLARE @Usuario VARCHAR(150), @Clave VARCHAR(150);

    SET @Data = LTRIM(RTRIM(@Data));
    SET @p1 = CHARINDEX('|', @Data, 0);
    SET @p2 = LEN(@Data) + 1;

    SET @Usuario = SUBSTRING(@Data, 1, @p1 - 1);
    SET @Clave   = SUBSTRING(@Data, @p1 + 1, @p2 - @p1 - 1);

    SELECT
    ISNULL((
        SELECT STUFF((
            SELECT TOP 1
                '¬' +
                CONVERT(VARCHAR, U.UsuarioID) + '|' +
                CONVERT(VARCHAR, p.PersonalId) + '|' +
                ISNULL(a.AreaNombre, '') + '|' +
                (
                    ISNULL(SUBSTRING(p.PersonalNombres + ' ', 1, CHARINDEX(' ', p.PersonalNombres + ' ') - 1), '') + ' ' +
                    ISNULL(SUBSTRING(p.PersonalApellidos + ' ', 1, CHARINDEX(' ', p.PersonalApellidos + ' ') - 1), '')
                ) + '|' +
                CONVERT(VARCHAR, p.CompaniaId) + '|' +
                ISNULL(c.CompaniaRazonSocial, '') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.DescuentoMax), '0') + '|' +
                ISNULL(c.CompaniaRUC, '') + '|' +
                ISNULL(c.CompaniaNomUBG, '') + '|' +
                ISNULL(c.CompaniaComercial, '') + '|' +
                ISNULL(c.CompaniaDirecSunat, '') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.EfectivoMax), '0') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.TarjetaPorcentaje), '0') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.ICBPER), '0') + '|' +
                ISNULL(CONVERT(VARCHAR(1), c.BoletaPorLote), '0') + '|' +
                ISNULL(c.CorreoSGO, '') + '|' +
                ISNULL(c.PasswordCorreo, '') + '|' +
                ISNULL(c.CorreosAdmin, '') + '|' +
                ISNULL(c.logoCompania, '') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.Descuento), ISNULL(CONVERT(VARCHAR(20), c.DescuentoMax), '0'))
            FROM Usuarios U
            INNER JOIN Personal p ON p.PersonalId = U.PersonalId
            INNER JOIN Area a ON a.AreaId = p.AreaId
            INNER JOIN Compania c ON c.CompaniaId = p.CompaniaId
            WHERE U.UsuarioAlias = @Usuario
              AND dbo.desincrectar(U.UsuarioClave) = @Clave
              AND U.UsuarioEstado = 'ACTIVO'
              AND p.PersonalEstado = 'ACTIVO'
            FOR XML PATH('')
        ), 1, 1, '')
    ), '~');
END;
GO

