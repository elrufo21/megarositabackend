UPDATE n
SET n.NotaSubtotal = n.NotaTotal - ISNULL(n.NotaMovilidad, 0) - ISNULL(n.NotaAdicional, 0)
FROM dbo.NotaPedido n
WHERE UPPER(LTRIM(RTRIM(ISNULL(n.NotaDocu, '')))) IN ('PROFORMA', 'PROFORMA V')
  AND ISNULL(n.NotaMovilidad, 0) + ISNULL(n.NotaAdicional, 0) > 0
  AND ABS(ISNULL(n.NotaSubtotal, 0) - ISNULL(n.NotaTotal, 0)) < 0.01;
GO
