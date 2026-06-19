USE [MEGAROSITAB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'dbo.uspEditarNotaPedidowEB', N'P') IS NULL
BEGIN
    EXEC ('CREATE PROCEDURE dbo.uspEditarNotaPedidowEB AS BEGIN SET NOCOUNT ON; SELECT ''UPDATED''; END');
END
GO
ALTER PROCEDURE [dbo].[uspEditarNotaPedidowEB]  
@Data VARCHAR(MAX)  
AS  
BEGIN  
  
SET NOCOUNT ON;  
  
BEGIN TRY  
BEGIN TRAN  
  
DECLARE   
@pos1 INT,  
@pos2 INT,  
@Cabecera VARCHAR(MAX),  
@Detalle VARCHAR(MAX),  
@NotaId INT,
@NotaDocuNueva VARCHAR(60),
@ClienteIdNuevo INT,
@NotaFechaNueva DATETIME,
@NotaUsuarioNuevo VARCHAR(60),
@NotaFormaPagoNueva VARCHAR(60),
@NotaCondicionNueva VARCHAR(60),
@NotaDocuActual VARCHAR(60),
@NotaSerieActual VARCHAR(60),
@NotaNumeroActual VARCHAR(60),
@CompaniaIdActual INT,
@SerieObjetivo VARCHAR(60),
@NumeroObjetivo VARCHAR(60),
@MaxDocuNumero INT,
@MaxNotaNumero INT,
@NextNumero INT
  
SET @pos1 = CHARINDEX('[',@Data,0)  
SET @pos2 = LEN(@Data)+1  
  
SET @Cabecera = SUBSTRING(@Data,1,@pos1-1)  
SET @Detalle  = SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1)  
  
DECLARE  
@p1 INT,@p2 INT,@p3 INT,@p4 INT,@p5 INT,@p6 INT,@p7 INT  
  
SET @p1 = CHARINDEX('|',@Cabecera,0)  
SET @p2 = CHARINDEX('|',@Cabecera,@p1+1)  
SET @p3 = CHARINDEX('|',@Cabecera,@p2+1)  
SET @p4 = CHARINDEX('|',@Cabecera,@p3+1)  
SET @p5 = CHARINDEX('|',@Cabecera,@p4+1)  
SET @p6 = CHARINDEX('|',@Cabecera,@p5+1)  
SET @p7 = LEN(@Cabecera)+1  
  
SET @NotaId = CONVERT(INT,SUBSTRING(@Cabecera,1,@p1-1))  
SET @NotaDocuNueva = UPPER(LTRIM(RTRIM(SUBSTRING(@Cabecera,@p1+1,@p2-@p1-1))))
SET @ClienteIdNuevo = CONVERT(INT,SUBSTRING(@Cabecera,@p2+1,@p3-@p2-1))
SET @NotaFechaNueva = CONVERT(DATETIME,SUBSTRING(@Cabecera,@p3+1,@p4-@p3-1))
SET @NotaUsuarioNuevo = SUBSTRING(@Cabecera,@p4+1,@p5-@p4-1)
SET @NotaFormaPagoNueva = SUBSTRING(@Cabecera,@p5+1,@p6-@p5-1)
SET @NotaCondicionNueva = SUBSTRING(@Cabecera,@p6+1,@p7-@p6-1)

SELECT TOP 1
    @NotaDocuActual = UPPER(LTRIM(RTRIM(ISNULL(NotaDocu, '')))),
    @NotaSerieActual = LTRIM(RTRIM(ISNULL(NotaSerie, ''))),
    @NotaNumeroActual = LTRIM(RTRIM(ISNULL(NotaNumero, ''))),
    @CompaniaIdActual = ISNULL(CompaniaId, 0)
FROM NotaPedido
WHERE NotaId = @NotaId;

SET @SerieObjetivo = @NotaSerieActual;
SET @NumeroObjetivo = @NotaNumeroActual;

IF @NotaDocuNueva IN ('BOLETA', 'FACTURA')
BEGIN
    -- Regla de negocio: series fijas
    -- BOLETA => BA01, FACTURA => FA01
    SET @SerieObjetivo = CASE WHEN @NotaDocuNueva = 'BOLETA' THEN 'BA01' ELSE 'FA01' END;

    IF @NotaDocuActual LIKE 'PROFORMA%' OR @NotaDocuActual <> @NotaDocuNueva OR NULLIF(@NotaNumeroActual, '') IS NULL
    BEGIN
        SELECT
            @MaxDocuNumero = ISNULL(MAX(
                CASE
                    WHEN RIGHT(LTRIM(RTRIM(ISNULL(d.DocuNumero, ''))), 8) NOT LIKE '%[^0-9]%'
                         AND LEN(LTRIM(RTRIM(ISNULL(d.DocuNumero, '')))) > 0
                    THEN CONVERT(INT, RIGHT(LTRIM(RTRIM(ISNULL(d.DocuNumero, ''))), 8))
                    ELSE 0
                END
            ), 0)
        FROM DocumentoVenta d
        WHERE d.CompaniaId = @CompaniaIdActual
          AND UPPER(LTRIM(RTRIM(ISNULL(d.DocuDocumento, '')))) = @NotaDocuNueva
          AND LTRIM(RTRIM(ISNULL(d.DocuSerie, ''))) = LTRIM(RTRIM(@SerieObjetivo));

        SELECT
            @MaxNotaNumero = ISNULL(MAX(
                CASE
                    WHEN RIGHT(LTRIM(RTRIM(ISNULL(n.NotaNumero, ''))), 8) NOT LIKE '%[^0-9]%'
                         AND LEN(LTRIM(RTRIM(ISNULL(n.NotaNumero, '')))) > 0
                    THEN CONVERT(INT, RIGHT(LTRIM(RTRIM(ISNULL(n.NotaNumero, ''))), 8))
                    ELSE 0
                END
            ), 0)
        FROM NotaPedido n
        WHERE n.CompaniaId = @CompaniaIdActual
          AND UPPER(LTRIM(RTRIM(ISNULL(n.NotaDocu, '')))) = @NotaDocuNueva
          AND LTRIM(RTRIM(ISNULL(n.NotaSerie, ''))) = LTRIM(RTRIM(@SerieObjetivo))
          AND n.NotaId <> @NotaId;

        SET @NextNumero = (CASE WHEN ISNULL(@MaxDocuNumero, 0) > ISNULL(@MaxNotaNumero, 0)
                                THEN ISNULL(@MaxDocuNumero, 0)
                                ELSE ISNULL(@MaxNotaNumero, 0) END) + 1;
        SET @NumeroObjetivo = RIGHT('00000000' + CONVERT(VARCHAR(20), @NextNumero), 8);
    END
END
  
/* DEVOLVER STOCK ANTERIOR */  
  
UPDATE p  
SET p.ProductoCantidad = p.ProductoCantidad + (d.DetalleCantidad * ISNULL(NULLIF(d.ValorUM,0),1))  
FROM Producto p  
INNER JOIN DetallePedido d   
ON p.IdProducto = d.IdProducto  
WHERE d.NotaId = @NotaId  
  
  
/* ACTUALIZA CABECERA */  
  
UPDATE NotaPedido  
SET  
NotaDocu = @NotaDocuNueva,  
ClienteId = @ClienteIdNuevo,  
NotaFecha = @NotaFechaNueva,  
NotaUsuario = @NotaUsuarioNuevo,  
NotaFormaPago = @NotaFormaPagoNueva,  
NotaCondicion = @NotaCondicionNueva,
NotaSerie = CASE WHEN @NotaDocuNueva IN ('BOLETA', 'FACTURA') THEN @SerieObjetivo ELSE NotaSerie END,
NotaNumero = CASE WHEN @NotaDocuNueva IN ('BOLETA', 'FACTURA') THEN @NumeroObjetivo ELSE NotaNumero END
WHERE NotaId=@NotaId  
  
  
/* ELIMINA DETALLE ANTERIOR */  
  
DELETE FROM DetallePedido  
WHERE NotaId=@NotaId  
  
  
/* INSERTA NUEVO DETALLE */  
  
DECLARE  
@fila VARCHAR(MAX),  
@c1 INT,@c2 INT,@c3 INT,@c4 INT,@c5 INT,@c6 INT,@c7 INT,@c8 INT,@c9 INT,@c10 INT,  
@IdProducto NUMERIC(20),  
@Cantidad DECIMAL(18,2),  
@CantidadSaldo DECIMAL(18,2),
@NotaEntrega VARCHAR(40),
@ValorUM DECIMAL(18,6),  
@ValorUMSegment VARCHAR(60),
@Estado NVARCHAR(1)  
  
WHILE LEN(@Detalle)>0  
BEGIN  
  
SET @c1 = CHARINDEX(';',@Detalle)  
  
IF @c1=0  
BEGIN  
 SET @fila=@Detalle  
 SET @Detalle=''  
END  
ELSE  
BEGIN  
 SET @fila=SUBSTRING(@Detalle,1,@c1-1)  
 SET @Detalle=SUBSTRING(@Detalle,@c1+1,LEN(@Detalle))  
END  
  
  
SET @c1 = CHARINDEX('|',@fila,0)  
SET @c2 = CHARINDEX('|',@fila,@c1+1)  
SET @c3 = CHARINDEX('|',@fila,@c2+1)  
SET @c4 = CHARINDEX('|',@fila,@c3+1)  
SET @c5 = CHARINDEX('|',@fila,@c4+1)  
SET @c6 = CHARINDEX('|',@fila,@c5+1)  
SET @c7 = CHARINDEX('|',@fila,@c6+1)  
SET @c8 = CHARINDEX('|',@fila,@c7+1)  
IF @c8=0 SET @c8 = LEN(@fila)+1  
SET @c9 = CHARINDEX('|',@fila,@c8+1)  
IF @c9=0 SET @c9 = LEN(@fila)+1  
SET @c10 = CHARINDEX('|',@fila,@c9+1)  
IF @c10=0 SET @c10 = LEN(@fila)+1  
  
  
SET @IdProducto = CONVERT(NUMERIC,SUBSTRING(@fila,1,@c1-1))  
SET @Cantidad   = CONVERT(DECIMAL,SUBSTRING(@fila,@c1+1,@c2-@c1-1))  
SET @ValorUM = 1  
SET @ValorUMSegment = ''  
IF @c8 < LEN(@fila)  
BEGIN  
 SET @ValorUMSegment = LTRIM(RTRIM(SUBSTRING(@fila,@c8+1,@c9-@c8-1)))  
END  
IF ISNUMERIC(REPLACE(@ValorUMSegment,',','.')) = 1  
BEGIN  
 SET @ValorUM = CONVERT(DECIMAL(18,6), REPLACE(@ValorUMSegment,',','.'))  
 IF @ValorUM<=0 SET @ValorUM=1  
END  
SET @NotaEntrega = (
    SELECT TOP 1 ISNULL(NotaEntrega, '')
    FROM NotaPedido
    WHERE NotaId = @NotaId
)
IF UPPER(LTRIM(RTRIM(ISNULL(@NotaEntrega, '')))) = 'INMEDIATA'
BEGIN
 SET @CantidadSaldo = 0
END
ELSE
BEGIN
 SET @CantidadSaldo = @Cantidad
END
SET @Estado = 'E'
IF @c9 < LEN(@fila)
BEGIN
 SET @Estado = UPPER(LTRIM(RTRIM(SUBSTRING(@fila,@c9+1,@c10-@c9-1))))
 IF @Estado = '' SET @Estado = 'E'
END
  
  
INSERT INTO DetallePedido  
(  
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
ValorUM,
Estado
)  
VALUES  
(  
@NotaId,  
@IdProducto,  
@Cantidad,  
SUBSTRING(@fila,@c2+1,@c3-@c2-1),  
SUBSTRING(@fila,@c3+1,@c4-@c3-1),  
CONVERT(DECIMAL,SUBSTRING(@fila,@c4+1,@c5-@c4-1)),  
CONVERT(DECIMAL,SUBSTRING(@fila,@c5+1,@c6-@c5-1)),  
CONVERT(DECIMAL,SUBSTRING(@fila,@c6+1,@c7-@c6-1)),  
SUBSTRING(@fila,@c7+1,@c8-@c7-1),  
@CantidadSaldo,
@ValorUM,
@Estado
)  
  
  
/* DESCONTAR STOCK NUEVO */  
  
UPDATE Producto  
SET ProductoCantidad = ProductoCantidad - (@Cantidad * @ValorUM)  
WHERE IdProducto = @IdProducto  
  
  
END  
  
  
COMMIT TRAN  
  
SELECT 'UPDATED'  
  
END TRY  
BEGIN CATCH  
  
ROLLBACK TRAN  
  
SELECT ERROR_MESSAGE() AS Error  
  
END CATCH  
  
END  
GO

