/*
  Sincroniza objetos faltantes en Desktop respecto a BdActualWeb.
  Objetos incluidos:
  - dbo.uspObtenerPersonalPorCodigoResumen
  - dbo.uspValidaUsuarioWeb
*/

IF COL_LENGTH('dbo.Compania', 'TarjetaPorcentaje') IS NULL
BEGIN
    ALTER TABLE dbo.Compania
    ADD TarjetaPorcentaje decimal(8, 2) NULL;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF OBJECT_ID('dbo.uspObtenerPersonalPorCodigoResumen', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.uspObtenerPersonalPorCodigoResumen AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[uspObtenerPersonalPorCodigoResumen]
    @PersonalCodigo varchar(80)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        p.PersonalId,
        p.PersonalEstado,
        LTRIM(RTRIM(
            (CASE
                WHEN LTRIM(RTRIM(ISNULL(p.PersonalNombres, ''))) = '' THEN ''
                ELSE SUBSTRING(
                    LTRIM(RTRIM(ISNULL(p.PersonalNombres, ''))),
                    1,
                    CHARINDEX(' ', LTRIM(RTRIM(ISNULL(p.PersonalNombres, ''))) + ' ') - 1
                )
            END) + ' ' +
            (CASE
                WHEN LTRIM(RTRIM(ISNULL(p.PersonalApellidos, ''))) = '' THEN ''
                ELSE SUBSTRING(
                    LTRIM(RTRIM(ISNULL(p.PersonalApellidos, ''))),
                    1,
                    CHARINDEX(' ', LTRIM(RTRIM(ISNULL(p.PersonalApellidos, ''))) + ' ') - 1
                )
            END)
        )) AS NombreApellido
    FROM dbo.Personal p
    WHERE p.PersonalCodigo = @PersonalCodigo
    ORDER BY p.PersonalId DESC;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.uspValidaUsuarioWeb', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.uspValidaUsuarioWeb AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[uspValidaUsuarioWeb]
    @Data VARCHAR(MAX)
AS
BEGIN
    DECLARE @p1 INT, @p2 INT;
    DECLARE @Usuario VARCHAR(150), @Clave VARCHAR(150);

    SET @Data = LTRIM(RTRIM(@Data));
    SET @p1 = CHARINDEX('|', @Data, 0);
    SET @p2 = LEN(@Data) + 1;

    SET @Usuario = SUBSTRING(@Data, 1, @p1 - 1);
    SET @Clave   = SUBSTRING(@Data, @p1 + 1, @p2 - @p1 - 1);

    SELECT ISNULL((
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
                ISNULL(c.CorreosAdmin, '')
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
END
GO
