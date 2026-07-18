;WITH detalle AS (
  SELECT
    NotaId,
    CAST(ROUND(SUM(ISNULL(DetalleImporte, 0)), 2) AS decimal(18,2)) AS DetalleTotal
  FROM dbo.DetallePedido
  GROUP BY NotaId
)
UPDATE n
SET n.NotaSubtotal = d.DetalleTotal
FROM dbo.NotaPedido n
JOIN detalle d ON d.NotaId = n.NotaId
WHERE n.NotaFecha >= '20260717'
  AND ABS(ISNULL(n.NotaSubtotal, 0) - d.DetalleTotal) > 0.01;
GO

UPDATE d
SET d.DocuAdicional = ISNULL(n.NotaAdicional, 0),
    d.DocuSubTotal = ISNULL(n.NotaPagar, n.NotaTotal) / 1.18,
    d.DocuIgv = ISNULL(n.NotaPagar, n.NotaTotal) - (ISNULL(n.NotaPagar, n.NotaTotal) / 1.18),
    d.DocuTotal = ISNULL(n.NotaPagar, n.NotaTotal),
    d.DocuGravada = ISNULL(n.NotaSubtotal, 0) / 1.18,
    d.DocuDescuento = ISNULL(n.NotaDescuento, 0) / 1.18
FROM dbo.DocumentoVenta d
JOIN dbo.NotaPedido n ON n.NotaId = d.NotaId
WHERE d.TipoCodigo IN ('01', '03')
  AND n.NotaFecha >= '20260717'
  AND UPPER(LTRIM(RTRIM(ISNULL(n.NotaFormaPago, '')))) = 'TARJETA';
GO
