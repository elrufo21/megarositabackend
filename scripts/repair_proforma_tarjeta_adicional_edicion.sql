;WITH detalle AS (
  SELECT
    NotaId,
    CAST(ROUND(SUM(ISNULL(DetalleImporte, 0)), 2) AS decimal(18,2)) AS DetalleTotal
  FROM dbo.DetallePedido
  GROUP BY NotaId
),
calculo AS (
  SELECT
    n.NotaId,
    d.DetalleTotal,
    CAST(ROUND(
      (d.DetalleTotal + ISNULL(n.NotaMovilidad, 0) - ISNULL(n.NotaDescuento, 0))
      * ISNULL(c.TarjetaPorcentaje, 0) / 100.0,
      2
    ) AS decimal(18,2)) AS Adicional,
    CAST(ROUND(
      d.DetalleTotal + ISNULL(n.NotaMovilidad, 0) - ISNULL(n.NotaDescuento, 0) +
      ((d.DetalleTotal + ISNULL(n.NotaMovilidad, 0) - ISNULL(n.NotaDescuento, 0))
       * ISNULL(c.TarjetaPorcentaje, 0) / 100.0),
      2
    ) AS decimal(18,2)) AS Total
  FROM dbo.NotaPedido n
  JOIN detalle d ON d.NotaId = n.NotaId
  LEFT JOIN dbo.Compania c ON c.CompaniaId = n.CompaniaId
  WHERE UPPER(LTRIM(RTRIM(ISNULL(n.NotaDocu, '')))) LIKE 'PROFORMA%'
    AND UPPER(LTRIM(RTRIM(ISNULL(n.NotaFormaPago, '')))) = 'TARJETA'
)
UPDATE n
SET n.NotaSubtotal = c.DetalleTotal,
    n.NotaAdicional = c.Adicional,
    n.NotaTotal = c.Total,
    n.NotaPagar = c.Total,
    n.NotaSaldo = c.Total,
    n.NotaTarjeta = c.Total
FROM dbo.NotaPedido n
JOIN calculo c ON c.NotaId = n.NotaId
WHERE ABS(ISNULL(n.NotaSubtotal, 0) - c.DetalleTotal) > 0.01
   OR ABS(ISNULL(n.NotaAdicional, 0) - c.Adicional) > 0.01
   OR ABS(ISNULL(n.NotaTotal, 0) - c.Total) > 0.01;
GO
