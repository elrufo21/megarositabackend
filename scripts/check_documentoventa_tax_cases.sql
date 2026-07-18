DECLARE @cases TABLE (
  Caso varchar(80),
  Documento varchar(20),
  ProductoBruto decimal(18,2),
  Movilidad decimal(18,2),
  Descuento decimal(18,2),
  AdicionalTarjeta decimal(18,2),
  ICBPER decimal(18,2)
);

INSERT INTO @cases VALUES
('boleta efectivo sin ajuste', 'BOLETA', 280.00, 0.00, 0.00, 0.00, 0.00),
('boleta con movilidad', 'BOLETA', 280.00, 10.00, 0.00, 0.00, 0.00),
('boleta con descuento y movilidad', 'BOLETA', 282.00, 10.00, 2.00, 0.00, 0.00),
('boleta tarjeta', 'BOLETA', 280.00, 0.00, 0.00, 0.00, 0.00),
('boleta tarjeta movilidad descuento', 'BOLETA', 282.00, 10.00, 2.00, 0.00, 0.00),
('factura tarjeta movilidad descuento', 'FACTURA', 282.00, 10.00, 2.00, 0.00, 0.00);

SELECT
  Caso,
  Documento,
  Total = CAST(ProductoBruto - Descuento + Movilidad + AdicionalTarjeta + ICBPER AS decimal(18,2)),
  DocuAdicional = CAST(0 AS decimal(18,2)),
  DocuSubtotal = CAST(ROUND((ProductoBruto - Descuento + Movilidad + AdicionalTarjeta) / 1.18, 2) AS decimal(18,2)),
  DocuIgv = CAST(ROUND((ProductoBruto - Descuento + Movilidad + AdicionalTarjeta) - ((ProductoBruto - Descuento + Movilidad + AdicionalTarjeta) / 1.18), 2) AS decimal(18,2)),
  DocuGravada = CAST(ROUND((ProductoBruto - ICBPER) / 1.18, 2) AS decimal(18,2)),
  DocuDescuento = CAST(ROUND(Descuento / 1.18, 2) AS decimal(18,2)),
  Estado =
    CASE
      WHEN CAST(ROUND((ProductoBruto - Descuento + Movilidad + AdicionalTarjeta) / 1.18, 2) AS decimal(18,2))
         = CAST(ROUND(((ProductoBruto / 1.18) - (Descuento / 1.18) + (Movilidad / 1.18) + (AdicionalTarjeta / 1.18)), 2) AS decimal(18,2))
      THEN 'OK'
      ELSE 'REVISAR'
    END
FROM @cases;
