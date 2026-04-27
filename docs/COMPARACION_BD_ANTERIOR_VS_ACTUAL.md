# Comparacion SQL: bdAnteriorEscritorio vs sqlBdActualWeb

## Contexto
- Solicitud: comparar el script anterior de escritorio contra el script actual web y registrar el contexto en un archivo Markdown.
- Fecha de comparacion: 2026-04-24 21:50:43
- Archivo anterior: `bdAnteriorEscritorio.sql`
- Archivo actual: `sqlBdActualWeb.sql`

## Resumen global
- Tamano anterior: 700512 bytes
- Tamano actual: 742839 bytes
- Diferencia lineal (git diff): **1732 inserciones** y **561 eliminaciones**
- Objetos SQL detectados (TABLE/PROCEDURE/VIEW/FUNCTION/TRIGGER):
  - Anterior: 429
  - Actual: 453
  - Nuevos: 24
  - Eliminados: 0
  - Modificados: 4
  - Sin cambios: 425

## Objetos nuevos en sqlBdActualWeb.sql
### PROCEDURE (5)
- `dbo.listanotapedido` (linea aprox: 8550)
- `dbo.listarproductos` (linea aprox: 9122)
- `dbo.uspeditarnotapedidoweb` (linea aprox: 12360)
- `dbo.uspobtenernotapedidobyid` (linea aprox: 17332)
- `dbo.uspobtenernotapedidodetalles` (linea aprox: 17389)

### TABLE (19)
- `dbo.__efmigrationshistory` (linea aprox: 449)
- `dbo.addresses` (linea aprox: 463)
- `dbo.aspnetroleclaims` (linea aprox: 542)
- `dbo.aspnetroles` (linea aprox: 558)
- `dbo.aspnetuserclaims` (linea aprox: 574)
- `dbo.aspnetuserlogins` (linea aprox: 590)
- `dbo.aspnetuserroles` (linea aprox: 607)
- `dbo.aspnetusers` (linea aprox: 622)
- `dbo.aspnetusertokens` (linea aprox: 654)
- `dbo.categories` (linea aprox: 782)
- `dbo.countries` (linea aprox: 904)
- `dbo.images` (linea aprox: 1462)
- `dbo.orderaddresses` (linea aprox: 1762)
- `dbo.orderitems` (linea aprox: 1785)
- `dbo.orders` (linea aprox: 1809)
- `dbo.products` (linea aprox: 1928)
- `dbo.reviews` (linea aprox: 2033)
- `dbo.shoppingcartitems` (linea aprox: 2054)
- `dbo.shoppingcarts` (linea aprox: 2080)

## Objetos eliminados
- No se detectaron objetos eliminados.

## Objetos modificados
- `PROCEDURE dbo.uspinsertarnotab`
  - Linea aprox anterior: 14849 | actual: 15885
  - Ocurrencias en script anterior: 1 | actual: 1
  - Diff del objeto: `artifacts\object-diffs\PROCEDURE_dbo.uspinsertarnotab.patch`
- `PROCEDURE dbo.uspvalidausuario`
  - Linea aprox anterior: 17604 | actual: 18759
  - Ocurrencias en script anterior: 1 | actual: 1
  - Diff del objeto: `artifacts\object-diffs\PROCEDURE_dbo.uspvalidausuario.patch`
- `TABLE dbo.compania`
  - Linea aprox anterior: 639 | actual: 824
  - Ocurrencias en script anterior: 1 | actual: 2
  - Diff del objeto: `artifacts\object-diffs\TABLE_dbo.compania.patch`
- `TABLE dbo.notapedido`
  - Linea aprox anterior: 1461 | actual: 1687
  - Ocurrencias en script anterior: 3 | actual: 3
  - Diff del objeto: `artifacts\object-diffs\TABLE_dbo.notapedido.patch`

## Cambios puntuales relevantes identificados
- `TABLE dbo.Compania`: se agrega columna `BoletaPorLote` (bit not null) y default `DF_Compania_BoletaPorLote = 1`.
- `TABLE dbo.NotaPedido`: en la comparacion inicial aparecian columnas extra de pago bancario; en la version de convivencia vigente **no se agregan** y se mantiene el esquema desktop.
- `PROCEDURE dbo.uspinsertarNotaB`: cambia `INSERT INTO NotaPedido` a insercion con lista explicita de columnas (mas robusto ante cambios de esquema).
- `PROCEDURE dbo.uspValidaUsuario`: reescritura importante del procedimiento (manejo de entrada, salida y campos retornados).
- Nuevos procedimientos para notas/productos: `listaNotaPedido`, `listarProductos`, `uspEditarNotaPedidowEB`, `uspObtenerNotaPedidoById`, `uspObtenerNotaPedidoDetalles`.
- Se incorporan tablas de soporte para ASP.NET Identity y e-commerce (`AspNet*`, `Products`, `Orders`, `Reviews`, `ShoppingCart*`, etc.).

## Artefactos generados
- Diff completo (todas las diferencias): `artifacts\\db-diff-bdAnterior-vs-actual.patch`
- Resumen estructurado JSON: `artifacts\\db-compare-summary.json`
- Diff por objeto modificado: carpeta `artifacts\\object-diffs\\`

## Nota metodologica
- La comparacion incluye diferencias de estructura y tambien cambios textuales del script (por ejemplo `Script Date`, formato y opciones como `SET QUOTED_IDENTIFIER`).
- Para auditoria exhaustiva usa el patch completo en `artifacts\\db-diff-bdAnterior-vs-actual.patch`.
