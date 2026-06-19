IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_DetallePedido_NotaId_DetalleId'
      AND object_id = OBJECT_ID('dbo.DetallePedido')
)
    CREATE INDEX IX_DetallePedido_NotaId_DetalleId
        ON dbo.DetallePedido (NotaId, DetalleId);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_DocumentoVenta_NotaId_DocuId'
      AND object_id = OBJECT_ID('dbo.DocumentoVenta')
)
    CREATE INDEX IX_DocumentoVenta_NotaId_DocuId
        ON dbo.DocumentoVenta (NotaId, DocuId DESC)
        INCLUDE (EstadoSunat);
