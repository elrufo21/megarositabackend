UPDATE n
SET n.NotaEstado = 'EMITIDO'
FROM dbo.NotaPedido n
WHERE UPPER(LTRIM(RTRIM(ISNULL(n.NotaDocu, '')))) = 'BOLETA'
  AND UPPER(LTRIM(RTRIM(ISNULL(n.NotaEstado, '')))) = 'PENDIENTE';
GO
