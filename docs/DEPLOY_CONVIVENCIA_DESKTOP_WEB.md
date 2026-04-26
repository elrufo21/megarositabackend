# Deploy Convivencia Desktop + Web

## Archivo principal a ejecutar
- `scripts/deploy_convivencia_desktop_web.sql`

## Que hace el script
- Crea el esquema `web` para aislar procedimientos del backend.
- Agrega columnas aditivas (sin borrar ni renombrar):
  - `dbo.Compania.BoletaPorLote`
  - `dbo.NotaPedido.EntidadBancaria`
  - `dbo.NotaPedido.NroOperacion`
  - `dbo.NotaPedido.Efectivo`
  - `dbo.NotaPedido.Deposito`
- No modifica los procedimientos legacy de escritorio en `dbo` (incluido `dbo.uspinsertarNotaB`).
- Crea procedimientos web con sufijo `_web` en esquema `web` (por ejemplo `web.uspinsertarNotaB_web`).
- Crea wrappers de compatibilidad en `web` sin sufijo y un wrapper `dbo.uspinsertarNotaB_web`.
- Incluye una guardia de seguridad: si detecta `dbo.uspinsertarNotaB` con `INSERT INTO NotaPedido VALUES(...)`, corta la ejecucion (`NOEXEC`) para no romper escritorio.

## Como ejecutarlo (SSMS)
1. Abrir SQL Server Management Studio.
2. Seleccionar la base de datos productiva.
3. Abrir `scripts/deploy_convivencia_desktop_web.sql`.
4. Ejecutar completo.

## Como ejecutarlo (sqlcmd)
```powershell
sqlcmd -S TU_SERVIDOR -d TU_BASE -E -i "C:\ruta\al\repo\scripts\deploy_convivencia_desktop_web.sql"
```

Si usas usuario/clave:
```powershell
sqlcmd -S TU_SERVIDOR -d TU_BASE -U TU_USUARIO -P TU_PASSWORD -i "C:\ruta\al\repo\scripts\deploy_convivencia_desktop_web.sql"
```

## Paso recomendado despues del script
- Usar un usuario SQL exclusivo para backend y asignarle `DEFAULT_SCHEMA = web`.
- El script deja ejemplos comentados para eso.

## Validaciones minimas post-ejecucion
```sql
SELECT COL_LENGTH('dbo.Compania','BoletaPorLote') AS BoletaPorLote;
SELECT COL_LENGTH('dbo.NotaPedido','EntidadBancaria') AS EntidadBancaria;
SELECT COL_LENGTH('dbo.NotaPedido','NroOperacion') AS NroOperacion;
SELECT COL_LENGTH('dbo.NotaPedido','Efectivo') AS Efectivo;
SELECT COL_LENGTH('dbo.NotaPedido','Deposito') AS Deposito;
```

```sql
EXEC web.uspValidaUsuario_web @Data = 'USUARIO|CLAVE|MAQUINA';
EXEC web.uspinsertarNotaB_web @ListaOrden = '...';
EXEC dbo.uspinsertarNotaB_web @ListaOrden = '...';
```

## Prueba funcional obligatoria
1. Probar login y una venta en escritorio.
2. Probar login y crear/editar nota en web.
3. Confirmar que ambas apps operan en paralelo sobre la misma BD.
