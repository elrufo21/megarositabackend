using System.Data;
using System.Globalization;
using Ecommerce.Application.Contracts.Productos;
using Ecommerce.Domain;
using Ecommerce.Infrastructure.Persistence;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace Ecommerce.Infrastructure.Persistence.Repositories;

public class ProductoRepository : IProducto
{
    private readonly string _connectionString;
    private readonly AccesoDatos _accesoDatos;

    public ProductoRepository(IConfiguration configuration, AccesoDatos accesoDatos)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Missing connection string: DefaultConnection");
        _accesoDatos = accesoDatos;
    }

    public async Task<string> InsertarAsync(Producto producto, CancellationToken cancellationToken = default)
    {
        var rawData = (producto.Data ?? string.Empty).Trim();
        var productoImagen = NormalizeImageName(producto.ProductoImagen);
        if (!string.IsNullOrWhiteSpace(rawData) && rawData.Contains('|'))
        {
            rawData = ReplaceProductoImagenInRawData(rawData, productoImagen);
            var resultRaw = await _accesoDatos.EjecutarComandoAsync("uspIngresarProducto", "@Data", rawData, cancellationToken);
            return string.IsNullOrWhiteSpace(resultRaw) ? "error" : resultRaw;
        }

        var aplicaInv = (producto.AplicaINV ?? string.Empty).Trim();
        var detalleUm = ResolveDetalleUm(producto);

        if (TryExtractDetalleDesdeAplicaInv(aplicaInv, out var aplicaInvLimpio, out var detalleDesdeAplicaInv))
        {
            aplicaInv = aplicaInvLimpio;
            if (string.IsNullOrWhiteSpace(detalleUm))
            {
                detalleUm = detalleDesdeAplicaInv;
            }
        }

        var data = string.Join("|",
            producto.IdProducto.ToString(CultureInfo.InvariantCulture),
            producto.IdSubLinea?.ToString(CultureInfo.InvariantCulture) ?? string.Empty,
            producto.ProductoCodigo?.Trim() ?? string.Empty,
            producto.ProductoNombre?.Trim() ?? string.Empty,
            producto.ProductoUM?.Trim() ?? string.Empty,
            FormatDecimal(producto.ProductoCosto),
            FormatDecimal(producto.ProductoVenta),
            FormatDecimal(producto.ProductoVentaB),
            FormatDecimal(producto.ProductoCantidad),
            producto.ProductoEstado ?? string.Empty,
            producto.ProductoUsuario ?? string.Empty,
            productoImagen ?? string.Empty,
            FormatDecimal(producto.ValorCritico),
            aplicaInv);

        if (!string.IsNullOrWhiteSpace(detalleUm))
        {
            data = $"{data}[{detalleUm}]";
        }

        var result = await _accesoDatos.EjecutarComandoAsync("uspIngresarProducto", "@Data", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? "error" : result;
    }

    public async Task<bool> EliminarAsync(long id, CancellationToken cancellationToken = default)
    {
        const string sql = "uspEliminarProducto";
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Id", id);
        await con.OpenAsync(cancellationToken);
        return await cmd.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<Producto?> ObtenerPorIdAsync(long id, CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT IdProducto, IdSubLinea, ProductoCodigo, ProductoNombre, ProductoUM, ProductoCosto,
                   ProductoVenta, ProductoVentaB, ProductoCantidad, ProductoEstado, ProductoUsuario,
                   ProductoFecha, ProductoImagen, ValorCritico, AplicaINV
            FROM Producto
            WHERE IdProducto = @Id;
            """;

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@Id", id);
        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? MapProducto(reader) : null;
    }

    public async Task<string> ListarCrudRawAsync(string? estado = "ACTIVO", CancellationToken cancellationToken = default)
    {
        var estadoNormalizado = string.IsNullOrWhiteSpace(estado) ? null : estado.Trim();

        var intentosConEstado = new (string Sp, string Param)[]
        {
            ("uspListarProducto", "@Estado"),
            ("dbo.uspListarProducto", "@Estado"),
            ("web.uspListarProducto", "@Estado"),
            ("uspListarProducto", "@Data"),
            ("dbo.uspListarProducto", "@Data"),
            ("web.uspListarProducto", "@Data")
        };

        var intentosSinEstado = new[]
        {
            "uspListarProducto",
            "dbo.uspListarProducto",
            "web.uspListarProducto",
            "uspListaWebProducto",
            "dbo.uspListaWebProducto",
            "web.uspListaWebProducto"
        };

        SqlException? ultimaSql = null;

        if (!string.IsNullOrWhiteSpace(estadoNormalizado))
        {
            foreach (var intento in intentosConEstado)
            {
                try
                {
                    var raw = await _accesoDatos.EjecutarComandoAsync(
                        intento.Sp,
                        intento.Param,
                        estadoNormalizado,
                        cancellationToken);

                    if (!string.IsNullOrWhiteSpace(raw))
                    {
                        return raw;
                    }
                }
                catch (SqlException ex) when (IsMissingProcedureOrParameter(ex))
                {
                    ultimaSql = ex;
                }
            }
        }

        foreach (var sp in intentosSinEstado)
        {
            try
            {
                var raw = await _accesoDatos.EjecutarComandoAsync(sp, cancellationToken: cancellationToken);
                if (!string.IsNullOrWhiteSpace(raw))
                {
                    return raw;
                }
            }
            catch (SqlException ex) when (IsMissingProcedureOrParameter(ex))
            {
                ultimaSql = ex;
            }
        }

        if (ultimaSql is not null)
        {
            throw new InvalidOperationException(
                "No se pudo listar productos: no se encontró un SP compatible (uspListarProducto/uspListaWebProducto).",
                ultimaSql);
        }

        return string.Empty;
    }

    public async Task<IReadOnlyList<Producto>> ListarCrudAsync(string? estado = "ACTIVO", int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        var result = await ListarCrudRawAsync(estado, cancellationToken);

        var lista = string.IsNullOrWhiteSpace(result) ? new List<Producto>() : ParseProductosCrud(result);
        return ApplyPagination(lista, page, pageSize);
    }

    public async Task<IReadOnlyList<EListaProducto>> ListarAsync(int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspListaWebProducto", cancellationToken: cancellationToken);
        var lista = string.IsNullOrWhiteSpace(result) ? new List<EListaProducto>() : Cadena.AlistaCamposPro(result);
        return ApplyPagination(lista, page, pageSize);
    }

    public async Task<IReadOnlyList<EListaProducto>> BuscarProductoAsync(string nombre, int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspBuscaWebProducto", "@Descripcion", nombre, cancellationToken);
        var lista = string.IsNullOrWhiteSpace(result) ? new List<EListaProducto>() : Cadena.AlistaCamposPro(result);
        return ApplyPagination(lista, page, pageSize);
    }

    public async Task<IReadOnlyList<ProductoListadoItem>> ListarProductosAsync(
        string? busqueda = "",
        CancellationToken cancellationToken = default)
    {
        const int pagina = 1;
        const int tamanoPagina = 50;
        var attempts = new[]
        {
            "web.listarProductos_web",
            "web.listarProductos",
            "dbo.listarProductos",
            "listarProductos"
        };

        SqlException? lastFallbackException = null;

        foreach (var sp in attempts)
        {
            try
            {
                await using var con = new SqlConnection(_connectionString);
                await using var cmd = new SqlCommand(sp, con)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 300
                };

                cmd.Parameters.AddWithValue("@Busqueda", (object?)busqueda ?? string.Empty);
                cmd.Parameters.AddWithValue("@Pagina", pagina);
                cmd.Parameters.AddWithValue("@TamanoPagina", tamanoPagina);

                await con.OpenAsync(cancellationToken);
                await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

                var items = new List<ProductoListadoItem>();
                while (await reader.ReadAsync(cancellationToken))
                {
                    items.Add(MapProductoListado(reader));
                }

                return items.Take(50).ToList();
            }
            catch (SqlException ex) when (IsMissingProcedureOrParameter(ex) || IsSchemaIncompatibility(ex))
            {
                lastFallbackException = ex;
            }
            catch (IndexOutOfRangeException)
            {
                // Resultset shape mismatch with expected web pagination contract.
                // Continue trying legacy procedure names below.
            }
            catch (InvalidCastException)
            {
                // Resultset type mismatch with expected web pagination contract.
                // Continue trying legacy procedure names below.
            }
        }

        var legacyFallback = await TryListarProductosDesdeRawLegadoAsync(busqueda, cancellationToken);
        if (legacyFallback is not null)
        {
            return legacyFallback;
        }

        if (lastFallbackException is not null)
        {
            throw new InvalidOperationException(
                "No se pudo listar productos con SP web ni con fallback legado. Verifique despliegue de SPs y esquema de BD.",
                lastFallbackException);
        }

        return Array.Empty<ProductoListadoItem>();
    }

    private async Task<IReadOnlyList<ProductoListadoItem>?> TryListarProductosDesdeRawLegadoAsync(
        string? busqueda,
        CancellationToken cancellationToken)
    {
        var query = (busqueda ?? string.Empty).Trim();
        var attempts = string.IsNullOrWhiteSpace(query)
            ? new (string StoredProcedure, string? ParameterName)[]
            {
                ("uspListaWebProducto", null),
                ("web.uspListaWebProducto", null),
                ("dbo.uspListaWebProducto", null)
            }
            : new (string StoredProcedure, string? ParameterName)[]
            {
                ("uspBuscaWebProducto", "@Descripcion"),
                ("web.uspBuscaWebProducto", "@Descripcion"),
                ("dbo.uspBuscaWebProducto", "@Descripcion")
            };

        foreach (var attempt in attempts)
        {
            try
            {
                var raw = attempt.ParameterName is null
                    ? await _accesoDatos.EjecutarComandoAsync(attempt.StoredProcedure, cancellationToken: cancellationToken)
                    : await _accesoDatos.EjecutarComandoAsync(attempt.StoredProcedure, attempt.ParameterName, query, cancellationToken);

                if (string.IsNullOrWhiteSpace(raw))
                {
                    continue;
                }

                var parsed = ParseListadoLegado(raw);
                if (!string.IsNullOrWhiteSpace(query))
                {
                    parsed = parsed
                        .Where(x =>
                            (!string.IsNullOrWhiteSpace(x.Descripcion) &&
                             x.Descripcion.Contains(query, StringComparison.OrdinalIgnoreCase)) ||
                            (!string.IsNullOrWhiteSpace(x.ProductoCodigo) &&
                             x.ProductoCodigo.Contains(query, StringComparison.OrdinalIgnoreCase)) ||
                            (!string.IsNullOrWhiteSpace(x.ProductoNombre) &&
                             x.ProductoNombre.Contains(query, StringComparison.OrdinalIgnoreCase)))
                        .ToList();
                }

                return parsed.Take(50).ToList();
            }
            catch (SqlException ex) when (IsMissingProcedureOrParameter(ex) || IsSchemaIncompatibility(ex))
            {
                // keep trying fallback variants
            }
            catch (FormatException)
            {
                // malformed legacy payload; try another fallback source
            }
            catch (IndexOutOfRangeException)
            {
                // malformed legacy payload; try another fallback source
            }
        }

        return null;
    }

    private static List<ProductoListadoItem> ParseListadoLegado(string raw)
    {
        var result = new List<ProductoListadoItem>();
        var rows = raw.Split('¬', StringSplitOptions.RemoveEmptyEntries);
        foreach (var row in rows)
        {
            var fields = row.Split('|');
            if (fields.Length == 0 || string.Equals(fields[0], "~", StringComparison.Ordinal))
            {
                break;
            }

            var idRaw = Field(fields, 0);
            var descripcion = Field(fields, 1);
            var imagen = NormalizeImageName(Field(fields, 4));

            result.Add(new ProductoListadoItem
            {
                IdProducto = long.TryParse(idRaw, NumberStyles.Any, CultureInfo.InvariantCulture, out var id)
                    ? id
                    : 0,
                ProductoCodigo = string.Empty,
                ProductoNombre = descripcion,
                Descripcion = descripcion,
                ProductoCantidad = Field(fields, 3),
                ProductoUM = NormalizeUnidad(Field(fields, 5)),
                ProductoVenta = Field(fields, 2),
                ProductoVentaB = Field(fields, 2),
                ProductoImagen = imagen,
                ValorUM = Field(fields, 6),
                ProductoEstado = "BUENO"
            });
        }

        return result;
    }

    private static string? Field(string[] fields, int index)
    {
        return index >= 0 && index < fields.Length ? fields[index] : null;
    }

    private static string? NormalizeUnidad(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return value;
        }

        var trimmed = value.Trim();
        return trimmed.Length > 3 ? trimmed[..3] : trimmed;
    }

    public async Task<long> GuardarUnidadMedidaProductoAsync(GuardarUnidadMedidaProductoRequest request, CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("dbo.uspGuardarUnidadMedidaProducto", con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.Add(new SqlParameter("@IdProducto", SqlDbType.Decimal)
        {
            Precision = 20,
            Scale = 0,
            Value = request.IdProducto
        });
        cmd.Parameters.Add(new SqlParameter("@UMDescripcion", SqlDbType.VarChar, 100)
        {
            Value = request.UMDescripcion.Trim()
        });
        cmd.Parameters.Add(new SqlParameter("@ValorUM", SqlDbType.Decimal)
        {
            Precision = 18,
            Scale = 2,
            Value = request.ValorUM
        });
        cmd.Parameters.Add(new SqlParameter("@PrecioVenta", SqlDbType.Decimal)
        {
            Precision = 18,
            Scale = 2,
            Value = request.PrecioVenta
        });
        cmd.Parameters.Add(new SqlParameter("@PrecioVentaB", SqlDbType.Decimal)
        {
            Precision = 18,
            Scale = 2,
            Value = request.PrecioVentaB
        });
        cmd.Parameters.Add(new SqlParameter("@PrecioCosto", SqlDbType.Decimal)
        {
            Precision = 18,
            Scale = 2,
            Value = request.PrecioCosto
        });

        await con.OpenAsync(cancellationToken);
        if (await StoredProcedureHasParameterAsync(con, "uspGuardarUnidadMedidaProducto", "@UnidadImagen", cancellationToken))
        {
            cmd.Parameters.Add(new SqlParameter("@UnidadImagen", SqlDbType.VarChar, -1)
            {
                Value = string.IsNullOrWhiteSpace(request.UnidadImagen)
                    ? DBNull.Value
                    : request.UnidadImagen.Trim()
            });
        }

        var result = await cmd.ExecuteScalarAsync(cancellationToken);
        if (result is null || result == DBNull.Value)
        {
            throw new InvalidOperationException("El procedimiento no devolvió IdUm.");
        }

        return Convert.ToInt64(result);
    }

    private static Producto MapProducto(SqlDataReader reader)
    {
        return new Producto
        {
            IdProducto = Convert.ToInt64(reader["IdProducto"]),
            IdSubLinea = reader["IdSubLinea"] == DBNull.Value ? null : Convert.ToInt64(reader["IdSubLinea"]),
            ProductoCodigo = reader["ProductoCodigo"]?.ToString(),
            ProductoNombre = reader["ProductoNombre"]?.ToString(),
            ProductoUM = reader["ProductoUM"]?.ToString(),
            ProductoCosto = reader["ProductoCosto"] == DBNull.Value ? null : Convert.ToDecimal(reader["ProductoCosto"]),
            ProductoVenta = reader["ProductoVenta"] == DBNull.Value ? null : Convert.ToDecimal(reader["ProductoVenta"]),
            ProductoVentaB = reader["ProductoVentaB"] == DBNull.Value ? null : Convert.ToDecimal(reader["ProductoVentaB"]),
            ProductoCantidad = reader["ProductoCantidad"] == DBNull.Value ? null : Convert.ToDecimal(reader["ProductoCantidad"]),
            ProductoEstado = reader["ProductoEstado"]?.ToString(),
            ProductoUsuario = reader["ProductoUsuario"]?.ToString(),
            ProductoFecha = reader["ProductoFecha"] == DBNull.Value ? null : Convert.ToDateTime(reader["ProductoFecha"]),
            ProductoImagen = reader["ProductoImagen"]?.ToString(),
            ValorCritico = reader["ValorCritico"] == DBNull.Value ? null : Convert.ToDecimal(reader["ValorCritico"]),
            AplicaINV = reader["AplicaINV"]?.ToString()
        };
    }

    private static ProductoListadoItem MapProductoListado(SqlDataReader reader)
    {
        return new ProductoListadoItem
        {
            IdProducto = ToInt64(reader, "IdProducto"),
            NombreLinea = ToString(reader, "NombreLinea"),
            NombreSublinea = ToString(reader, "NombreSublinea"),
            ProductoCodigo = ToString(reader, "ProductoCodigo"),
            ProductoNombre = ToString(reader, "ProductoNombre"),
            ProductoMarca = ToString(reader, "ProductoMarca"),
            Descripcion = ToString(reader, "Descripcion"),
            ProductoCantidad = ToString(reader, "ProductoCantidad"),
            ProductoUM = ToString(reader, "ProductoUM"),
            ProductoVenta = ToString(reader, "ProductoVenta"),
            ProductoVentaB = ToString(reader, "ProductoVentaB"),
            PrecioCosto = ToNullableDecimal(reader, "PrecioCosto"),
            CostoDolar = ToNullableDecimal(reader, "CostoDolar"),
            TipoCambio = ToNullableDecimal(reader, "TipoCambio"),
            AlmacenNombre = ToString(reader, "AlmacenNombre"),
            ProductoUbicacion = ToString(reader, "ProductoUbicacion"),
            ProductoObs = ToString(reader, "ProductoObs"),
            ProductoEstado = ToString(reader, "ProductoEstado"),
            ProductoUsuario = ToString(reader, "ProductoUsuario"),
            ValorUM = ToString(reader, "ValorUM"),
            ProductoImagen = ToString(reader, "ProductoImagen"),
            ValorCritico = ToNullableDecimal(reader, "ValorCritico"),
            MaxCantVen = ToString(reader, "MaxCantVen"),
            AplicaINV = ToString(reader, "AplicaINV")
        };
    }

    private static string? ToString(SqlDataReader reader, string columnName)
    {
        var value = reader[columnName];
        return value == DBNull.Value ? null : value.ToString();
    }

    private static int ToInt32(SqlDataReader reader, string columnName)
    {
        var value = reader[columnName];
        if (value == DBNull.Value)
        {
            return 0;
        }

        return Convert.ToInt32(value, CultureInfo.InvariantCulture);
    }

    private static long ToInt64(SqlDataReader reader, string columnName)
    {
        var value = reader[columnName];
        if (value == DBNull.Value)
        {
            return 0;
        }

        return Convert.ToInt64(value, CultureInfo.InvariantCulture);
    }

    private static decimal? ToNullableDecimal(SqlDataReader reader, string columnName)
    {
        var value = reader[columnName];
        if (value == DBNull.Value)
        {
            return null;
        }

        return Convert.ToDecimal(value, CultureInfo.InvariantCulture);
    }

    private static IReadOnlyList<EListaProducto> ApplyPagination(IReadOnlyList<EListaProducto> source, int page, int pageSize)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);
        return source.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    private static IReadOnlyList<Producto> ApplyPagination(IReadOnlyList<Producto> source, int page, int pageSize)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);
        return source.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    private static List<Producto> ParseProductosCrud(string data)
    {
        var lista = new List<Producto>();
        var registros = data.Split('¬');

        foreach (var registro in registros)
        {
            var campos = registro.Split('|');
            if (campos.Length == 0 || campos[0] == "~")
            {
                break;
            }

            lista.Add(new Producto
            {
                IdProducto = ToLong(campos, 0),
                IdSubLinea = ToNullableLong(campos, 1),
                ProductoCodigo = ToNullableString(campos, 2),
                ProductoNombre = ToNullableString(campos, 3),
                ProductoUM = ToNullableString(campos, 4),
                ProductoCosto = ToNullableDecimal(campos, 5),
                ProductoVenta = ToNullableDecimal(campos, 6),
                ProductoVentaB = ToNullableDecimal(campos, 7),
                ProductoCantidad = ToNullableDecimal(campos, 8),
                ProductoEstado = ToNullableString(campos, 9),
                ProductoUsuario = ToNullableString(campos, 10),
                ProductoFecha = ToNullableDate(campos, 11),
                ProductoImagen = ToNullableString(campos, 12),
                ValorCritico = ToNullableDecimal(campos, 13),
                AplicaINV = ToNullableString(campos, 14)
            });
        }

        return lista;
    }

    private static string? ToNullableString(string[] campos, int index)
    {
        if (index >= campos.Length) return null;
        var value = campos[index];
        return string.IsNullOrWhiteSpace(value) ? null : value;
    }

    private static long ToLong(string[] campos, int index)
    {
        var value = ToNullableString(campos, index);
        return long.TryParse(value, out var parsed) ? parsed : 0;
    }

    private static long? ToNullableLong(string[] campos, int index)
    {
        var value = ToNullableString(campos, index);
        return long.TryParse(value, out var parsed) ? parsed : null;
    }

    private static decimal? ToNullableDecimal(string[] campos, int index)
    {
        var value = ToNullableString(campos, index);
        return decimal.TryParse(value, out var parsed) ? parsed : null;
    }

    private static DateTime? ToNullableDate(string[] campos, int index)
    {
        var value = ToNullableString(campos, index);
        return DateTime.TryParse(value, out var parsed) ? parsed : null;
    }

    private static (int page, int pageSize) NormalizePagination(int page, int pageSize)
    {
        var normalizedPage = page < 1 ? 1 : page;
        var normalizedPageSize = pageSize < 1 ? 1 : Math.Min(pageSize, 100);
        return (normalizedPage, normalizedPageSize);
    }

    private static string FormatDecimal(decimal? value)
    {
        return (value ?? 0m).ToString(CultureInfo.InvariantCulture);
    }

    private static string? NormalizeDetalleUm(string? detalleUm)
    {
        if (string.IsNullOrWhiteSpace(detalleUm))
        {
            return null;
        }

        var normalized = detalleUm.Trim();
        if (normalized.StartsWith('[') && normalized.EndsWith(']') && normalized.Length > 1)
        {
            normalized = normalized[1..^1].Trim();
        }

        return string.IsNullOrWhiteSpace(normalized) ? null : normalized;
    }

    private static string? ResolveDetalleUm(Producto producto)
    {
        return NormalizeDetalleUm(producto.DetalleUm)
            ?? NormalizeDetalleUm(producto.DetalleUM)
            ?? NormalizeDetalleUm(producto.UnidadMedidaDetalle);
    }

    private static bool TryExtractDetalleDesdeAplicaInv(string aplicaInv, out string aplicaInvLimpio, out string? detalleUm)
    {
        aplicaInvLimpio = aplicaInv;
        detalleUm = null;

        if (string.IsNullOrWhiteSpace(aplicaInv))
        {
            return false;
        }

        var openIndex = aplicaInv.IndexOf('[');
        if (openIndex <= 0)
        {
            return false;
        }

        aplicaInvLimpio = aplicaInv[..openIndex].Trim();

        var closeIndex = aplicaInv.LastIndexOf(']');
        var rawDetalle = closeIndex > openIndex
            ? aplicaInv.Substring(openIndex + 1, closeIndex - openIndex - 1)
            : aplicaInv[(openIndex + 1)..];

        detalleUm = string.IsNullOrWhiteSpace(rawDetalle) ? null : rawDetalle.Trim();
        return true;
    }

    private static string ReplaceProductoImagenInRawData(string rawData, string? productoImagen)
    {
        var openIndex = rawData.IndexOf('[');
        var closeIndex = rawData.LastIndexOf(']');
        var hasDetalle = openIndex >= 0 && closeIndex > openIndex;

        var cabecera = hasDetalle ? rawData[..openIndex] : rawData;
        var campos = cabecera.Split('|');
        if (campos.Length < 14)
        {
            return rawData;
        }

        campos[11] = NormalizeImageName(productoImagen ?? campos[11]) ?? string.Empty;
        var cabeceraActualizada = string.Join("|", campos);
        return hasDetalle ? $"{cabeceraActualizada}{rawData[openIndex..]}" : cabeceraActualizada;
    }

    private static string? NormalizeImageName(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        var normalized = value.Trim();
        if (normalized.StartsWith("blob:", StringComparison.OrdinalIgnoreCase) ||
            normalized.StartsWith("data:", StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }

        if (Uri.TryCreate(normalized, UriKind.Absolute, out var uri))
        {
            normalized = Uri.UnescapeDataString(uri.Segments.LastOrDefault() ?? string.Empty);
        }

        normalized = normalized.Replace('\\', '/');
        var fileName = normalized.Split('/', StringSplitOptions.RemoveEmptyEntries).LastOrDefault();
        return string.IsNullOrWhiteSpace(fileName) ? null : fileName.Trim();
    }

    private static async Task<bool> StoredProcedureHasParameterAsync(
        SqlConnection connection,
        string procedureName,
        string parameterName,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT TOP 1 1
            FROM sys.parameters p
            INNER JOIN sys.objects o ON o.object_id = p.object_id
            WHERE o.type = 'P'
              AND o.name = @ProcedureName
              AND p.name = @ParameterName;
            """;

        await using var cmd = new SqlCommand(sql, connection)
        {
            CommandTimeout = 30,
            CommandType = CommandType.Text
        };
        cmd.Parameters.AddWithValue("@ProcedureName", procedureName);
        cmd.Parameters.AddWithValue("@ParameterName", parameterName);

        var result = await cmd.ExecuteScalarAsync(cancellationToken);
        return result is not null && result != DBNull.Value;
    }

    private static bool IsMissingProcedureOrParameter(SqlException ex)
    {
        // 2812: stored procedure not found
        // 201 : expects parameter not supplied
        // 8144: too many arguments
        return ex.Number == 2812 || ex.Number == 201 || ex.Number == 8144;
    }

    private static bool IsSchemaIncompatibility(SqlException ex)
    {
        // 207: invalid column name
        // 208: invalid object name
        // 213: column name/number mismatch
        return ex.Number == 207 || ex.Number == 208 || ex.Number == 213;
    }
}
