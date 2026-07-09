IF SCHEMA_ID('web') IS NULL
    EXEC('CREATE SCHEMA [web]');
GO

IF OBJECT_ID('web.listarProductosAlmacen', 'P') IS NULL
    EXEC('CREATE PROCEDURE [web].[listarProductosAlmacen] AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE [web].[listarProductosAlmacen]
    @AlmacenId NUMERIC(20,0) = NULL,
    @Busqueda VARCHAR(250) = '',
    @Pagina INT = 1,
    @TamanoPagina INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @Pagina IS NULL OR @Pagina < 1 SET @Pagina = 1;
    IF @TamanoPagina IS NULL OR @TamanoPagina < 1 SET @TamanoPagina = 50;

    ;WITH ProductosAlmacen AS
    (
        SELECT
            s.IdStock,
            s.AlmacenId,
            a.AlmacenNombre,
            s.IdProducto,
            p.ProductoCodigo,
            p.ProductoNombre,
            p.ProductoMarca,
            LTRIM(RTRIM(ISNULL(p.ProductoNombre, '') + ' ' + ISNULL(p.ProductoMarca, ''))) AS Descripcion,
            s.Cantidad,
            p.ProductoUM,
            p.ProductoVenta,
            p.ProductoVentaB,
            p.ProductoCosto AS PrecioCosto,
            CAST(1 AS DECIMAL(18,4)) AS ValorUM,
            p.ValorCritico,
            p.ProductoImagen,
            p.ProductoUbicacion,
            s.Usuario,
            s.FechaEdicion,
            s.Cantidad * ISNULL(p.ProductoCosto, 0) AS Inversion,
            CAST(0 AS BIT) AS EsUnidadAlterna
        FROM Stock s WITH (NOLOCK)
        INNER JOIN Producto p WITH (NOLOCK) ON p.IdProducto = s.IdProducto
        INNER JOIN Almacen a WITH (NOLOCK) ON a.AlmacenId = s.AlmacenId
        WHERE s.Estado = 'BUENO'
          AND s.Cantidad > 0
          AND p.ProductoEstado = 'BUENO'
          AND (@AlmacenId IS NULL OR @AlmacenId <= 0 OR s.AlmacenId = @AlmacenId)

        UNION ALL

        SELECT
            s.IdStock,
            s.AlmacenId,
            a.AlmacenNombre,
            s.IdProducto,
            p.ProductoCodigo,
            p.ProductoNombre,
            p.ProductoMarca,
            LTRIM(RTRIM(ISNULL(p.ProductoNombre, '') + ' ' + ISNULL(p.ProductoMarca, ''))) AS Descripcion,
            s.Cantidad / NULLIF(u.ValorUM, 0) AS Cantidad,
            u.UMDescripcion AS ProductoUM,
            u.PrecioVenta AS ProductoVenta,
            u.PrecioVentaB AS ProductoVentaB,
            u.PrecioCosto,
            u.ValorUM,
            p.ValorCritico,
            p.ProductoImagen,
            p.ProductoUbicacion,
            s.Usuario,
            s.FechaEdicion,
            s.Cantidad * ISNULL(p.ProductoCosto, 0) AS Inversion,
            CAST(1 AS BIT) AS EsUnidadAlterna
        FROM Stock s WITH (NOLOCK)
        INNER JOIN Producto p WITH (NOLOCK) ON p.IdProducto = s.IdProducto
        INNER JOIN UnidadMedida u WITH (NOLOCK) ON u.IdProducto = p.IdProducto
        INNER JOIN Almacen a WITH (NOLOCK) ON a.AlmacenId = s.AlmacenId
        WHERE s.Estado = 'BUENO'
          AND s.Cantidad > 0
          AND p.ProductoEstado = 'BUENO'
          AND ISNULL(u.ValorUM, 0) > 0
          AND (@AlmacenId IS NULL OR @AlmacenId <= 0 OR s.AlmacenId = @AlmacenId)
    ),
    Filtrados AS
    (
        SELECT *
        FROM ProductosAlmacen
        WHERE ISNULL(@Busqueda, '') = ''
           OR Descripcion LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoCodigo, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoMarca, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoNombre, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(AlmacenNombre, '') LIKE '%' + @Busqueda + '%'
    ),
    Paginados AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY AlmacenNombre ASC, Descripcion ASC, ProductoUM ASC) AS RowNum,
            COUNT(*) OVER () AS TotalRegistros,
            *
        FROM Filtrados
    )
    SELECT
        TotalRegistros,
        IdStock,
        AlmacenId,
        AlmacenNombre,
        IdProducto,
        ProductoCodigo,
        ProductoNombre,
        ProductoMarca,
        Descripcion,
        Cantidad,
        ProductoUM,
        ProductoVenta,
        ProductoVentaB,
        PrecioCosto,
        ValorUM,
        ValorCritico,
        ProductoImagen,
        ProductoUbicacion,
        Usuario,
        FechaEdicion,
        Inversion,
        EsUnidadAlterna
    FROM Paginados
    WHERE RowNum BETWEEN ((@Pagina - 1) * @TamanoPagina + 1) AND (@Pagina * @TamanoPagina)
    ORDER BY RowNum;
END
GO
