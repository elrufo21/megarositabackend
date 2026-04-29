using Ecommerce.Application.Contracts.Usuarios;
using Ecommerce.Application.Identity;
using Ecommerce.Application.Models.Token;
using Ecommerce.Domain;
using Ecommerce.Infrastructure.Persistence;
using Microsoft.Extensions.Options;

namespace Ecommerce.Infrastructure.Persistence.Repositories;

public class UsuarioRepository : IUsuario
{
    private readonly IAuthService _authService;
    private readonly JwtSettings _jwtSettings;
    private readonly AccesoDatos _accesoDatos;

    public UsuarioRepository(
        IAuthService authService,
        IOptions<JwtSettings> jwtSettings,
        AccesoDatos accesoDatos)
    {
        _authService = authService;
        _jwtSettings = jwtSettings.Value;
        _accesoDatos = accesoDatos;
    }

    public async Task<AuthResponseA> LoginAsync(EUser loginUser, CancellationToken cancellationToken = default)
    {
        var data = $"{loginUser.Email}|{loginUser.Password}";
        var result = await _accesoDatos.EjecutarComandoConFallbackAsync(
            new (string StoredProcedure, string ParameterName)[]
            {
                ("dbo.uspValidaUsuarioWeb", "@Data"),
                ("uspValidaUsuarioWeb", "@Data"),
                ("web.uspValidaUsuario_web", "@Data"),
                ("web.uspValidaUsuario", "@Data"),
                ("dbo.uspValidaUsuario", "@Data"),
                ("uspValidaUsuario", "@Data")
            },
            data,
            cancellationToken);

        if (string.IsNullOrWhiteSpace(result))
        {
            throw new InvalidOperationException("No hay conexión con el servidor.");
        }

        var info = result.Split('[');
        if (info.Length == 0 || info[0] == "~")
        {
            throw new UnauthorizedAccessException("Acceso denegado, usuario no válido.");
        }

        var rawPayload = info[0].Trim();
        if (rawPayload.StartsWith('¬'))
        {
            rawPayload = rawPayload.TrimStart('¬');
        }

        var payload = rawPayload.Split('|');
        if (payload.Length < 6)
        {
            throw new InvalidOperationException("Respuesta de autenticación inválida.");
        }

        var esFormatoNuevo = payload.Length >= 15 && IsBoolFlagCandidate(GetPayloadValue(payload, 14));

        var nowUtc = DateTime.UtcNow;
        var expiresAtUtc = nowUtc.Add(_jwtSettings.ExpireTime);
        var expiresInSeconds = (int)_jwtSettings.ExpireTime.TotalSeconds;
        return new AuthResponseA
        {
            Id = GetPayloadValue(payload, 0),
            PersonalId = GetPayloadValue(payload, 1),
            Area = GetPayloadValue(payload, 2),
            Usuario = GetPayloadValue(payload, 3),
            CompaniaId = GetPayloadValue(payload, 4),
            RazonSocial = GetPayloadValue(payload, 5),
            FechaVencimientoClave = esFormatoNuevo ? null : GetPayloadValue(payload, 6, null),
            DescuentoMax = esFormatoNuevo ? GetPayloadValue(payload, 6, "0") : GetPayloadValue(payload, 7, "0"),
            CompaniaRuc = esFormatoNuevo ? GetPayloadValue(payload, 7) : GetPayloadValue(payload, 8),
            CompaniaNomUbg = esFormatoNuevo ? GetPayloadValue(payload, 8) : GetPayloadValue(payload, 9),
            CompaniaComercial = esFormatoNuevo ? GetPayloadValue(payload, 9) : GetPayloadValue(payload, 10),
            CompaniaDirecSunat = esFormatoNuevo ? GetPayloadValue(payload, 10) : GetPayloadValue(payload, 11),
            UsuarioSol = esFormatoNuevo ? null : GetPayloadValue(payload, 12),
            ClaveSol = esFormatoNuevo ? null : GetPayloadValue(payload, 13),
            CertificadoBase64 = esFormatoNuevo ? null : GetPayloadValue(payload, 14),
            ClaveCertificado = esFormatoNuevo ? null : GetPayloadValue(payload, 15),
            Entorno = esFormatoNuevo ? "3" : GetPayloadValue(payload, 16, "3"),
            CompaniaTelefono = esFormatoNuevo ? null : GetPayloadValue(payload, 17),
            BoletaPorLote = ParseBoolFlag(esFormatoNuevo ? GetPayloadValue(payload, 14, "1") : GetPayloadValue(payload, 18, "1")),
            EfectivoMax = esFormatoNuevo ? GetPayloadValue(payload, 11, "0") : null,
            TarjetaPorcentaje = esFormatoNuevo ? GetPayloadValue(payload, 12, "0") : null,
            Icbper = esFormatoNuevo ? GetPayloadValue(payload, 13, "0") : null,
            CorreoSgo = esFormatoNuevo ? GetPayloadValue(payload, 15) : null,
            PasswordCorreo = esFormatoNuevo ? GetPayloadValue(payload, 16) : null,
            CorreosAdmin = esFormatoNuevo ? GetPayloadValue(payload, 17) : null,
            Token = _authService.CreateTokenA(expiresAtUtc.ToString("O")),
            ExpiresAtUtc = expiresAtUtc,
            ExpiresInSeconds = expiresInSeconds
        };
    }

    private static string? GetPayloadValue(string[] payload, int index, string? fallback = "")
    {
        return payload.Length > index ? payload[index] : fallback;
    }

    private static bool ParseBoolFlag(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return true;
        }

        var normalized = value.Trim();
        if (string.Equals(normalized, "1", StringComparison.Ordinal) ||
            string.Equals(normalized, "true", StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        if (string.Equals(normalized, "0", StringComparison.Ordinal) ||
            string.Equals(normalized, "false", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        return true;
    }

    private static bool IsBoolFlagCandidate(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return false;
        }

        var normalized = value.Trim();
        return string.Equals(normalized, "1", StringComparison.Ordinal) ||
               string.Equals(normalized, "0", StringComparison.Ordinal) ||
               string.Equals(normalized, "true", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(normalized, "false", StringComparison.OrdinalIgnoreCase);
    }
}
