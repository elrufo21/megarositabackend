using System.Collections.Generic;
using BusinessEntities;

namespace MegaRosita.Capa.Aplicacion;

public sealed class CPEConfig
{
    public Dictionary<string, string> Envio(CPE _)
    {
        return CrearRespuestaNoDisponible("Envio");
    }

    public Dictionary<string, string> EnvioResumen(CPE_RESUMEN_BOLETA _)
    {
        return CrearRespuestaNoDisponible("EnvioResumen");
    }

    public Dictionary<string, string> EnvioBaja(CPE_BAJA _)
    {
        return CrearRespuestaNoDisponible("EnvioBaja");
    }

    public Dictionary<string, string> ConsultaTicket(CONSULTA_TICKET _)
    {
        return CrearRespuestaNoDisponible("ConsultaTicket");
    }

    private static Dictionary<string, string> CrearRespuestaNoDisponible(string operacion)
    {
        return new Dictionary<string, string>(System.StringComparer.OrdinalIgnoreCase)
        {
            ["flg_rta"] = "0",
            ["mensaje"] = $"Integracion legacy CPE no disponible ({operacion}).",
            ["cod_sunat"] = string.Empty,
            ["msj_sunat"] = "Servicio CPE legacy no configurado en este entorno.",
            ["hash_cpe"] = string.Empty,
            ["hash_cdr"] = string.Empty,
            ["cdr_base64"] = string.Empty,
            ["ticket"] = string.Empty
        };
    }
}
