UPDATE d
SET d.DocuAdicional = ISNULL(n.NotaAdicional, 0),
    d.DocuGravada = (ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaMovilidad, 0) - ISNULL(n.NotaAdicional, 0) + ISNULL(n.NotaDescuento, 0) - ISNULL(d.ICBPER, 0)) / 1.18,
    d.DocuSubtotal = (ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaAdicional, 0) - ISNULL(d.ICBPER, 0)) / 1.18,
    d.DocuIgv = (ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaAdicional, 0)) - ((ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaAdicional, 0) - ISNULL(d.ICBPER, 0)) / 1.18),
    d.DocuTotal = ISNULL(n.NotaTotal, d.DocuTotal),
    d.DocuDescuento = ISNULL(n.NotaDescuento, 0) / 1.18
FROM dbo.DocumentoVenta d
JOIN dbo.NotaPedido n ON n.NotaId = d.NotaId
WHERE d.TipoCodigo IN ('01', '03')
  AND ISNULL(d.DocuSubtotal, 0) > 0
  AND ISNULL(d.DocuTotal, 0) > 0
  AND (
    ABS(ISNULL(d.DocuAdicional, 0) - ISNULL(n.NotaAdicional, 0)) > 0.01
    OR ABS(ISNULL(d.DocuSubtotal, 0) - ((ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaAdicional, 0) - ISNULL(d.ICBPER, 0)) / 1.18)) > 0.01
    OR ABS(ISNULL(d.DocuIgv, 0) - ((ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaAdicional, 0)) - ((ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaAdicional, 0) - ISNULL(d.ICBPER, 0)) / 1.18))) > 0.01
    OR ABS(ISNULL(d.DocuTotal, 0) - ISNULL(n.NotaTotal, d.DocuTotal)) > 0.01
    OR ABS(ISNULL(d.DocuGravada, 0) - ((ISNULL(n.NotaTotal, d.DocuTotal) - ISNULL(n.NotaMovilidad, 0) - ISNULL(n.NotaAdicional, 0) + ISNULL(n.NotaDescuento, 0) - ISNULL(d.ICBPER, 0)) / 1.18)) > 0.01
    OR ABS(ISNULL(d.DocuDescuento, 0) - (ISNULL(n.NotaDescuento, 0) / 1.18)) > 0.01
  );
GO
