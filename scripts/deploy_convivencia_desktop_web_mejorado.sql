-- ============================================================================
-- Script mejorado: Convivencia Desktop + Web sin tocar SP base
-- Fecha: 2026-04-25
-- Objetivo:
--   1) Mantener funcionamiento de escritorio.
--   2) Habilitar backend con SP web.*_web y wrappers web.*.
--   3) Evitar errores por columnas opcionales faltantes en NotaPedido.
-- ============================================================================
SET NOCOUNT ON;

PRINT '[1/6] Creando esquema [web] si no existe...';
IF SCHEMA_ID('web') IS NULL
BEGIN
    EXEC('CREATE SCHEMA [web] AUTHORIZATION [dbo];');
END
GO

PRINT '[2/6] Evaluando seguridad para cambios de tabla...';
DECLARE @SafeAlterNotaPedido bit;
DECLARE @SafeAlterCompania bit;

;WITH Modulos AS
(
    SELECT
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(m.definition), CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), ' ', ''), '[', ''), ']', '') AS DefCompact
    FROM sys.sql_modules m
)
SELECT
    @SafeAlterNotaPedido = CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM Modulos
            WHERE DefCompact LIKE '%insertintonotapedidovalues(%'
               OR DefCompact LIKE '%insertintodbo.notapedidovalues(%'
        ) THEN 0 ELSE 1 END,
    @SafeAlterCompania = CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM Modulos
            WHERE DefCompact LIKE '%insertintocompaniavalues(%'
               OR DefCompact LIKE '%insertintodbo.companiavalues(%'
        ) THEN 0 ELSE 1 END;

IF @SafeAlterCompania = 1
BEGIN
    IF COL_LENGTH('dbo.Compania', 'BoletaPorLote') IS NULL
        ALTER TABLE dbo.Compania ADD BoletaPorLote bit NULL;
END
ELSE
BEGIN
    PRINT 'WARN: Se detecto INSERT ... VALUES sobre Compania. Se omite agregar BoletaPorLote para no romper legacy.';
END

IF @SafeAlterNotaPedido = 1
BEGIN
    PRINT 'INFO: NotaPedido se mantiene con esquema desktop (sin columnas adicionales de pago bancario).';
END
ELSE
BEGIN
    PRINT 'WARN: Se detecto INSERT ... VALUES sobre NotaPedido. No se realizan cambios de columnas (compatibilidad desktop).';
END
GO

PRINT '[3/6] Creando SP web._web de login/registro/edicion...';

IF OBJECT_ID('web.uspValidaUsuario_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspValidaUsuario_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspValidaUsuario_web]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dbo.uspValidaUsuario @Data = @Data;
END
GO

IF OBJECT_ID('web.uspinsertarNotaB_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspinsertarNotaB_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspinsertarNotaB_web]
    @ListaOrden varchar(Max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dbo.uspinsertarNotaB @ListaOrden = @ListaOrden;
END
GO

IF OBJECT_ID('web.uspEditarNotaPedidowEB_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspEditarNotaPedidowEB_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspEditarNotaPedidowEB_web]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('dbo.uspEditarNotaPedidowEB', 'P') IS NOT NULL
    BEGIN
        EXEC dbo.uspEditarNotaPedidowEB @Data = @Data;
        RETURN;
    END

    IF OBJECT_ID('dbo.uspEditarNotaPedido', 'P') IS NOT NULL
    BEGIN
        BEGIN TRY
            EXEC dbo.uspEditarNotaPedido @Data = @Data;
            RETURN;
        END TRY
        BEGIN CATCH
        END CATCH;

        BEGIN TRY
            EXEC dbo.uspEditarNotaPedido @ListaOrden = @Data;
            RETURN;
        END TRY
        BEGIN CATCH
            SELECT ERROR_MESSAGE() AS Error;
            RETURN;
        END CATCH;
    END

    RAISERROR('No existe SP de edicion de nota en dbo.', 16, 1);
END
GO

PRINT '[4/6] Creando SP web._web de lectura robustos (compatibles con columnas faltantes)...';

IF OBJECT_ID('web.listaNotaPedido_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[listaNotaPedido_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[listaNotaPedido_web]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @FechaInicio IS NULL OR @FechaFin IS NULL OR @FechaInicio > @FechaFin
    BEGIN
        SELECT '~' AS Resultado;
        RETURN;
    END;

    DECLARE @FechaFinExclusiva DATE;
    SET @FechaFinExclusiva = DATEADD(DAY, 1, @FechaFin);

    DECLARE @Sql NVARCHAR(MAX) = N'
    SELECT
        ISNULL(
            (
                SELECT STUFF(
                    (
                        SELECT
                            ''¬'' +
                            ISNULL(CONVERT(VARCHAR(50), n.NotaId), '''') + ''|'' +
                            ISNULL(n.NotaDocu, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), c.ClienteId), '''') + ''|'' +
                            ISNULL(c.ClienteRazon, '''') + ''|'' +
                            ISNULL(c.ClienteRuc, '''') + ''|'' +
                            ISNULL(c.ClienteDni, '''') + ''|'' +
                            ISNULL(c.ClienteDireccion, '''') + ''|'' +
                            ISNULL(c.ClienteTelefono, '''') + ''|'' +
                            ISNULL(c.ClienteCorreo, '''') + ''|'' +
                            ISNULL(c.ClienteEstado, '''') + ''|'' +
                            ISNULL(c.ClienteDespacho, '''') + ''|'' +
                            ISNULL(c.ClienteUsuario, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(10), c.ClienteFecha, 103), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(10), n.NotaFecha, 103), '''') + ''|'' +
                            ISNULL(n.NotaUsuario, '''') + ''|'' +
                            ISNULL(n.NotaFormaPago, '''') + ''|'' +
                            ISNULL(n.NotaCondicion, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(10), n.NotaFechaPago, 103), '''') + ''|'' +
                            ISNULL(n.NotaDireccion, '''') + ''|'' +
                            ISNULL(n.NotaTelefono, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaSubtotal AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaMovilidad AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaDescuento AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaTotal AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaAcuenta AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaSaldo AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaAdicional AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaTarjeta AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaPagar AS MONEY), 1), '''') + ''|'' +
                            ISNULL(n.NotaEstado, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), n.CompaniaId), '''') + ''|'' +
                            ISNULL(n.NotaEntrega, '''') + ''|'' +
                            ISNULL(n.ModificadoPor, '''') + ''|'' +
                            ISNULL(n.FechaEdita, '''') + ''|'' +
                            ISNULL(n.NotaConcepto, '''') + ''|'' +
                            ISNULL(n.NotaSerie, '''') + ''|'' +
                            ISNULL(n.NotaNumero, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaGanancia AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.ICBPER AS MONEY), 1), '''') + ''|'' +
                            ISNULL(n.CajaId, '''')
                        FROM dbo.NotaPedido n
                        LEFT JOIN dbo.Cliente c
                            ON c.ClienteId = n.ClienteId
                        WHERE n.NotaFecha >= @FechaInicio
                          AND n.NotaFecha < @FechaFinExclusiva
                        ORDER BY n.NotaId DESC
                        FOR XML PATH('''')
                    ),
                    1, 1, ''''
                )
            ),
            ''~''
        ) AS Resultado
    OPTION (RECOMPILE);';

    EXEC sp_executesql @Sql,
        N'@FechaInicio DATE, @FechaFinExclusiva DATE',
        @FechaInicio = @FechaInicio,
        @FechaFinExclusiva = @FechaFinExclusiva;
END
GO

IF OBJECT_ID('web.listarProductos_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[listarProductos_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[listarProductos_web]
    @Busqueda VARCHAR(250) = '',
    @Pagina INT = 1,
    @TamanoPagina INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @Pagina IS NULL OR @Pagina < 1 SET @Pagina = 1;
    IF @TamanoPagina IS NULL OR @TamanoPagina < 1 SET @TamanoPagina = 50;

    ;WITH ProductosBase AS
    (
        SELECT
            p.IdProducto,
            l.NombreLinea,
            s.NombreSublinea,
            p.ProductoCodigo,
            p.ProductoNombre,
            p.ProductoMarca,
            LTRIM(RTRIM(ISNULL(p.ProductoNombre, '') + ' ' + ISNULL(p.ProductoMarca, ''))) AS Descripcion,
            CONVERT(VARCHAR, CAST(p.ProductoCantidad AS MONEY), 1) AS ProductoCantidad,
            p.ProductoUM,
            CONVERT(VARCHAR, CAST(p.ProductoVenta AS MONEY), 1) AS ProductoVenta,
            CONVERT(VARCHAR, CAST(p.ProductoVentaB AS MONEY), 1) AS ProductoVentaB,
            p.ProductoCosto AS PrecioCosto,
            p.ProductoCostoDolar AS CostoDolar,
            p.ProductoTipoCambio AS TipoCambio,
            a.AlmacenNombre,
            p.ProductoUbicacion,
            '' AS ProductoObs,
            p.ProductoEstado,
            p.ProductoUsuario,
            CAST('1' AS VARCHAR(20)) AS ValorUM,
            p.ProductoImagen,
            p.ValorCritico,
            CAST(p.MaxCantVen AS VARCHAR(50)) AS MaxCantVen,
            p.AplicaINV
        FROM Producto p WITH (NOLOCK)
        INNER JOIN Sublinea s WITH (NOLOCK) ON p.IdSubLinea = s.IdSubLinea
        INNER JOIN Linea l WITH (NOLOCK) ON s.IdLinea = l.IdLinea
        INNER JOIN Almacen a WITH (NOLOCK) ON p.AlmacenId = a.AlmacenId
        WHERE p.ProductoEstado = 'BUENO' AND p.ProductoCantidad > 0

        UNION ALL

        SELECT
            p.IdProducto,
            l.NombreLinea,
            s.NombreSublinea,
            p.ProductoCodigo,
            p.ProductoNombre,
            p.ProductoMarca,
            LTRIM(RTRIM(ISNULL(p.ProductoNombre, '') + ' ' + ISNULL(p.ProductoMarca, ''))) AS Descripcion,
            CONVERT(VARCHAR, CAST((p.ProductoCantidad / NULLIF(u.ValorUM, 0)) AS MONEY), 1) AS ProductoCantidad,
            u.UMDescripcion AS ProductoUM,
            CONVERT(VARCHAR, CAST(u.PrecioVenta AS MONEY), 1) AS ProductoVenta,
            CONVERT(VARCHAR, CAST(u.PrecioVentaB AS MONEY), 1) AS ProductoVentaB,
            u.PrecioCosto AS PrecioCosto,
            '0' AS CostoDolar,
            '0' AS TipoCambio,
            a.AlmacenNombre,
            p.ProductoUbicacion,
            '' AS ProductoObs,
            p.ProductoEstado,
            p.ProductoUsuario,
            CAST(u.ValorUM AS VARCHAR(20)) AS ValorUM,
            p.ProductoImagen,
            p.ValorCritico,
            CONVERT(VARCHAR, CONVERT(DECIMAL(18,2), (CONVERT(DECIMAL(18,6), (1 / NULLIF(u.ValorUM, 0))) * p.MaxCantVen))) AS MaxCantVen,
            p.AplicaINV
        FROM UnidadMedida u WITH (NOLOCK)
        INNER JOIN Producto p WITH (NOLOCK) ON p.IdProducto = u.IdProducto
        INNER JOIN Sublinea s WITH (NOLOCK) ON p.IdSubLinea = s.IdSubLinea
        INNER JOIN Linea l WITH (NOLOCK) ON s.IdLinea = l.IdLinea
        INNER JOIN Almacen a WITH (NOLOCK) ON p.AlmacenId = a.AlmacenId
        WHERE p.ProductoEstado = 'BUENO' AND p.ProductoCantidad > 0
    ),
    ProductosFiltrados AS
    (
        SELECT *
        FROM ProductosBase
        WHERE ISNULL(@Busqueda, '') = ''
           OR Descripcion LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoCodigo, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoMarca, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoNombre, '') LIKE '%' + @Busqueda + '%'
    ),
    ProductosPaginados AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY Descripcion ASC, IdProducto ASC) AS RowNum,
            COUNT(*) OVER () AS TotalRegistros,
            IdProducto,
            NombreLinea,
            NombreSublinea,
            ProductoCodigo,
            ProductoNombre,
            ProductoMarca,
            Descripcion,
            ProductoCantidad,
            ProductoUM,
            ProductoVenta,
            ProductoVentaB,
            PrecioCosto,
            CostoDolar,
            TipoCambio,
            AlmacenNombre,
            ProductoUbicacion,
            ProductoObs,
            ProductoEstado,
            ProductoUsuario,
            ValorUM,
            ProductoImagen,
            ValorCritico,
            MaxCantVen,
            AplicaINV
        FROM ProductosFiltrados
    )
    SELECT
        TotalRegistros,
        IdProducto,
        NombreLinea,
        NombreSublinea,
        ProductoCodigo,
        ProductoNombre,
        ProductoMarca,
        Descripcion,
        ProductoCantidad,
        ProductoUM,
        ProductoVenta,
        ProductoVentaB,
        PrecioCosto,
        CostoDolar,
        TipoCambio,
        AlmacenNombre,
        ProductoUbicacion,
        ProductoObs,
        ProductoEstado,
        ProductoUsuario,
        ValorUM,
        ProductoImagen,
        ValorCritico,
        MaxCantVen,
        AplicaINV
    FROM ProductosPaginados
    WHERE RowNum BETWEEN ((@Pagina - 1) * @TamanoPagina + 1) AND (@Pagina * @TamanoPagina)
    ORDER BY RowNum;
END
GO

IF OBJECT_ID('web.uspObtenerNotaPedidoById_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspObtenerNotaPedidoById_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspObtenerNotaPedidoById_web]
    @Id NUMERIC(38,0)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX) = N'
    SELECT TOP (1)
        n.NotaId,
        n.NotaDocu,
        n.ClienteId,
        n.NotaFecha,
        n.NotaUsuario,
        n.NotaFormaPago,
        n.NotaCondicion,
        n.NotaFechaPago,
        n.NotaDireccion,
        n.NotaTelefono,
        n.NotaSubtotal,
        n.NotaMovilidad,
        n.NotaDescuento,
        n.NotaTotal,
        n.NotaAcuenta,
        n.NotaSaldo,
        n.NotaAdicional,
        n.NotaTarjeta,
        n.NotaPagar,
        n.NotaEstado,
        n.CompaniaId,
        n.NotaEntrega,
        n.ModificadoPor,
        n.FechaEdita,
        n.NotaConcepto,
        n.NotaSerie,
        n.NotaNumero,
        n.NotaGanancia,
        n.ICBPER,
        n.CajaId,
        (
            SELECT TOP (1) d.EstadoSunat
            FROM dbo.DocumentoVenta d WITH (NOLOCK)
            WHERE d.NotaId = n.NotaId
            ORDER BY d.DocuId DESC
        ) AS EstadoSunat
    FROM dbo.NotaPedido n WITH (NOLOCK)
    WHERE n.NotaId = @Id;';

    EXEC sp_executesql @Sql, N'@Id NUMERIC(38,0)', @Id = @Id;
END
GO

IF OBJECT_ID('web.uspObtenerNotaPedidoDetalles_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspObtenerNotaPedidoDetalles_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspObtenerNotaPedidoDetalles_web]
    @NotaId NUMERIC(38,0),
    @Page INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @Page < 1 SET @Page = 1;
    IF @PageSize < 1 SET @PageSize = 1;
    IF @PageSize > 100 SET @PageSize = 100;

    DECLARE @Offset INT;
    SET @Offset = (@Page - 1) * @PageSize;

    ;WITH D AS
    (
        SELECT
            d.DetalleId,
            d.NotaId,
            d.IdProducto,
            d.DetalleCantidad,
            d.DetalleUm,
            d.DetalleDescripcion,
            d.DetalleCosto,
            d.DetallePrecio,
            d.DetalleImporte,
            d.DetalleEstado,
            d.CantidadSaldo,
            d.ValorUM,
            ROW_NUMBER() OVER (ORDER BY d.DetalleId ASC) AS rn
        FROM dbo.DetallePedido d WITH (NOLOCK)
        WHERE d.NotaId = @NotaId
    )
    SELECT
        DetalleId,
        NotaId,
        IdProducto,
        DetalleCantidad,
        DetalleUm,
        DetalleDescripcion,
        DetalleCosto,
        DetallePrecio,
        DetalleImporte,
        DetalleEstado,
        CantidadSaldo,
        ValorUM
    FROM D
    WHERE rn BETWEEN (@Offset + 1) AND (@Offset + @PageSize)
    ORDER BY rn;
END
GO

PRINT '[5/6] Wrappers de compatibilidad en esquema [web] y dbo...';

IF OBJECT_ID('web.uspValidaUsuario', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspValidaUsuario] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspValidaUsuario]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspValidaUsuario_web] @Data = @Data;
END
GO

IF OBJECT_ID('web.uspinsertarNotaB', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspinsertarNotaB] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspinsertarNotaB]
    @ListaOrden varchar(Max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspinsertarNotaB_web] @ListaOrden = @ListaOrden;
END
GO

IF OBJECT_ID('web.uspEditarNotaPedidowEB', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspEditarNotaPedidowEB] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspEditarNotaPedidowEB]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspEditarNotaPedidowEB_web] @Data = @Data;
END
GO

IF OBJECT_ID('web.listaNotaPedido', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[listaNotaPedido] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[listaNotaPedido]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[listaNotaPedido_web] @FechaInicio = @FechaInicio, @FechaFin = @FechaFin;
END
GO

IF OBJECT_ID('web.listarProductos', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[listarProductos] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[listarProductos]
    @Busqueda VARCHAR(250) = '',
    @Pagina INT = 1,
    @TamanoPagina INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[listarProductos_web] @Busqueda = @Busqueda, @Pagina = @Pagina, @TamanoPagina = @TamanoPagina;
END
GO

IF OBJECT_ID('web.uspObtenerNotaPedidoById', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspObtenerNotaPedidoById] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspObtenerNotaPedidoById]
    @Id NUMERIC(38,0)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspObtenerNotaPedidoById_web] @Id = @Id;
END
GO

IF OBJECT_ID('web.uspObtenerNotaPedidoDetalles', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[uspObtenerNotaPedidoDetalles] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [web].[uspObtenerNotaPedidoDetalles]
    @NotaId NUMERIC(38,0),
    @Page INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspObtenerNotaPedidoDetalles_web] @NotaId = @NotaId, @Page = @Page, @PageSize = @PageSize;
END
GO

IF OBJECT_ID('dbo.uspinsertarNotaB_web', 'P') IS NULL
    EXEC('CREATE PROCEDURE [dbo].[uspinsertarNotaB_web] AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [dbo].[uspinsertarNotaB_web]
    @ListaOrden varchar(Max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspinsertarNotaB_web] @ListaOrden = @ListaOrden;
END
GO

PRINT '[6/6] Listo. Base legacy no alterada en SP base; backend habilitado con web.*_web.';
-- Pruebas sugeridas:
-- EXEC web.uspValidaUsuario_web @Data = 'USUARIO|CLAVE|MAQUINA';
-- EXEC web.listaNotaPedido_web @FechaInicio = '2026-01-01', @FechaFin = '2026-01-31';
-- EXEC web.listarProductos_web @Busqueda = '', @Pagina = 1, @TamanoPagina = 20;
