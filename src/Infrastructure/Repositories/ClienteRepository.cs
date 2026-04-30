using System.Data;
using Ecommerce.Application.Contracts.Clientes;
using Ecommerce.Domain;
using Ecommerce.Infrastructure.Persistence;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace Ecommerce.Infrastructure.Persistence.Repositories;

public class ClienteRepository : ICliente
{
    private readonly string _connectionString;
    private readonly AccesoDatos _accesoDatos;

    public ClienteRepository(IConfiguration configuration, AccesoDatos accesoDatos)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Missing connection string: DefaultConnection");
        _accesoDatos = accesoDatos;
    }

    public async Task<string> InsertarAsync(Cliente cliente, CancellationToken cancellationToken = default)
    {
        var movil = (cliente.ClienteMovil ?? cliente.ClienteTelefono)?.Trim();
        var telefono = cliente.ClienteTelefono?.Trim();
        var estado = string.IsNullOrWhiteSpace(cliente.ClienteEstado) ? "ACTIVO" : cliente.ClienteEstado.Trim();

        var data = $"{cliente.ClienteId}|{cliente.ClienteRazon?.Trim()}|{cliente.ClienteRuc?.Trim()}|{cliente.ClienteDni?.Trim()}|{cliente.ClienteDireccion?.Trim()}|{movil}|{telefono}|{cliente.ClienteCorreo?.Trim()}|{estado}|{cliente.ClienteDespacho?.Trim()}|{cliente.ClienteUsuario}";
        var result = await _accesoDatos.EjecutarComandoAsync("insertaClienteLD", "@Columna", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? "error" : result;
    }

    public async Task<bool> EliminarAsync(long id, CancellationToken cancellationToken = default)
    {
        const string sql = """
            DELETE FROM Cliente
            WHERE ClienteId = @Id;
            """;
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.Text
        };
        cmd.Parameters.AddWithValue("@Id", id);
        await con.OpenAsync(cancellationToken);
        try
        {
            var rows = await cmd.ExecuteNonQueryAsync(cancellationToken);
            return rows > 0;
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            // FK violation: cliente en uso por NotaPedido/DocumentoVenta u otras tablas.
            return false;
        }
    }

    public async Task<IReadOnlyList<Cliente>> ListarAsync(string? estado = "ACTIVO", int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT ClienteId, ClienteRazon, ClienteRuc, ClienteDni, ClienteDireccion, ClienteMovil, ClienteTelefono,
                   ClienteCorreo, ClienteEstado, ClienteDespacho, ClienteUsuario, ClienteFecha
            FROM Cliente
            WHERE (@Estado IS NULL OR ClienteEstado = @Estado)
            ORDER BY ClienteId DESC;
            """;

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@Estado", (object?)estado ?? DBNull.Value);
        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<Cliente>();
        while (await reader.ReadAsync(cancellationToken))
        {
            lista.Add(new Cliente
            {
                ClienteId = Convert.ToInt64(reader["ClienteId"]),
                ClienteRazon = reader["ClienteRazon"].ToString(),
                ClienteRuc = reader["ClienteRuc"].ToString(),
                ClienteDni = reader["ClienteDni"].ToString(),
                ClienteDireccion = reader["ClienteDireccion"].ToString(),
                ClienteMovil = reader["ClienteMovil"].ToString(),
                ClienteTelefono = reader["ClienteTelefono"].ToString(),
                ClienteCorreo = reader["ClienteCorreo"].ToString(),
                ClienteEstado = reader["ClienteEstado"].ToString(),
                ClienteDespacho = reader["ClienteDespacho"].ToString(),
                ClienteUsuario = reader["ClienteUsuario"].ToString(),
                ClienteFecha = reader["ClienteFecha"] == DBNull.Value ? null : Convert.ToDateTime(reader["ClienteFecha"])
            });
        }

        return lista;
    }

    public async Task<string> ListarComboAsync(CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspListaComboClienteWeb", cancellationToken: cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

}
