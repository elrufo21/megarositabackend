using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Ecommerce.Infrastructure.Persistence;

public class AccesoDatos
{
    private readonly string _connectionString;
    private readonly ILogger<AccesoDatos> _logger;

    public AccesoDatos(IConfiguration configuration, ILogger<AccesoDatos> logger)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Missing connection string: DefaultConnection");
        _logger = logger;
    }

    public async Task<string> EjecutarComandoAsync(
        string nombreSp,
        string parametroNombre = "",
        string parametroValor = "",
        CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(nombreSp, con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };

        if (!string.IsNullOrWhiteSpace(parametroNombre))
        {
            cmd.Parameters.AddWithValue(parametroNombre, (object?)parametroValor ?? DBNull.Value);
        }

        try
        {
            await con.OpenAsync(cancellationToken);
            var result = await cmd.ExecuteScalarAsync(cancellationToken);
            return result?.ToString() ?? string.Empty;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Stored procedure execution failed: {StoredProcedure}", nombreSp);
            throw;
        }
    }

    public async Task<string> EjecutarComandoConFallbackAsync(
        IReadOnlyList<(string StoredProcedure, string ParameterName)> intentos,
        string parametroValor = "",
        CancellationToken cancellationToken = default)
    {
        if (intentos is null || intentos.Count == 0)
        {
            throw new ArgumentException("Debe proporcionar al menos un procedimiento para fallback.", nameof(intentos));
        }

        SqlException? lastFallbackException = null;

        foreach (var intento in intentos)
        {
            try
            {
                return await EjecutarComandoAsync(
                    intento.StoredProcedure,
                    intento.ParameterName,
                    parametroValor,
                    cancellationToken);
            }
            catch (SqlException ex) when (IsMissingProcedureOrParameter(ex))
            {
                lastFallbackException = ex;
            }
        }

        if (lastFallbackException is not null)
        {
            throw lastFallbackException;
        }

        return string.Empty;
    }

    private static bool IsMissingProcedureOrParameter(SqlException ex)
    {
        // 2812: stored procedure not found
        // 201 : expects parameter not supplied
        // 8144: too many arguments
        return ex.Number == 2812 || ex.Number == 201 || ex.Number == 8144;
    }
}
