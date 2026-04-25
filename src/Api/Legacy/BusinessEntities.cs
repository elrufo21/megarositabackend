using System.Collections.Generic;

namespace BusinessEntities;

public sealed class CPE
{
    public string? TIPO_OPERACION { get; set; }
    public string? HORA_REGISTRO { get; set; }
    public decimal TOTAL_GRAVADAS { get; set; }
    public decimal TOTAL_INAFECTA { get; set; }
    public decimal TOTAL_EXONERADAS { get; set; }
    public decimal TOTAL_GRATUITAS { get; set; }
    public decimal TOTAL_DESCUENTO { get; set; }
    public decimal SUB_TOTAL { get; set; }
    public decimal POR_IGV { get; set; }
    public decimal TOTAL_IGV { get; set; }
    public decimal TOTAL_ISC { get; set; }
    public decimal TOTAL_EXPORTACION { get; set; }
    public decimal TOTAL_OTR_IMP { get; set; }
    public decimal TOTAL_ICBPER { get; set; }
    public decimal TOTAL { get; set; }
    public string? TOTAL_LETRAS { get; set; }
    public string? NRO_GUIA_REMISION { get; set; }
    public string? FECHA_GUIA_REMISION { get; set; }
    public string? COD_GUIA_REMISION { get; set; }
    public string? NRO_OTR_COMPROBANTE { get; set; }
    public string? COD_OTR_COMPROBANTE { get; set; }
    public string? TIPO_COMPROBANTE_MODIFICA { get; set; }
    public string? NRO_DOCUMENTO_MODIFICA { get; set; }
    public string? COD_TIPO_MOTIVO { get; set; }
    public string? DESCRIPCION_MOTIVO { get; set; }
    public string? NRO_COMPROBANTE { get; set; }
    public string? FECHA_DOCUMENTO { get; set; }
    public string? COD_TIPO_DOCUMENTO { get; set; }
    public string? COD_MONEDA { get; set; }
    public string? NRO_DOCUMENTO_CLIENTE { get; set; }
    public string? RAZON_SOCIAL_CLIENTE { get; set; }
    public string? TIPO_DOCUMENTO_CLIENTE { get; set; }
    public string? DIRECCION_CLIENTE { get; set; }
    public string? CIUDAD_CLIENTE { get; set; }
    public string? COD_PAIS_CLIENTE { get; set; }
    public string? COD_UBIGEO_CLIENTE { get; set; }
    public string? DEPARTAMENTO_CLIENTE { get; set; }
    public string? PROVINCIA_CLIENTE { get; set; }
    public string? DISTRITO_CLIENTE { get; set; }
    public string? NRO_DOCUMENTO_EMPRESA { get; set; }
    public string? TIPO_DOCUMENTO_EMPRESA { get; set; }
    public string? NOMBRE_COMERCIAL_EMPRESA { get; set; }
    public string? CODIGO_UBIGEO_EMPRESA { get; set; }
    public string? DIRECCION_EMPRESA { get; set; }
    public string? CONTACTO_EMPRESA { get; set; }
    public string? DEPARTAMENTO_EMPRESA { get; set; }
    public string? PROVINCIA_EMPRESA { get; set; }
    public string? DISTRITO_EMPRESA { get; set; }
    public string? CODIGO_PAIS_EMPRESA { get; set; }
    public string? RAZON_SOCIAL_EMPRESA { get; set; }
    public string? USUARIO_SOL_EMPRESA { get; set; }
    public string? PASS_SOL_EMPRESA { get; set; }
    public string? CONTRA_FIRMA { get; set; }
    public int TIPO_PROCESO { get; set; }
    public string? FECHA_VTO { get; set; }
    public string? FORMA_PAGO { get; set; }
    public string? GLOSA { get; set; }
    public string? RUTA_PFX { get; set; }
    public string? CODIGO_ANEXO { get; set; }
    public string? CUENTA_DETRACCION { get; set; }
    public decimal MONTO_DETRACCION { get; set; }
    public decimal PORCENTAJE_DES { get; set; }
    public List<CPE_DETALLE> detalle { get; set; } = new();
}

public sealed class CPE_DETALLE
{
    public int? ITEM { get; set; }
    public string? UNIDAD_MEDIDA { get; set; }
    public decimal CANTIDAD { get; set; }
    public decimal PRECIO { get; set; }
    public decimal IMPORTE { get; set; }
    public double IMPUESTO_ICBPER { get; set; }
    public int CANTIDAD_BOLSAS { get; set; }
    public double SUNAT_ICBPER { get; set; }
    public string? PRECIO_TIPO_CODIGO { get; set; }
    public decimal IGV { get; set; }
    public decimal BI_ISC { get; set; }
    public decimal POR_ISC { get; set; }
    public string? TIPO_ISC { get; set; }
    public decimal ISC { get; set; }
    public string? COD_TIPO_OPERACION { get; set; }
    public string? CODIGO { get; set; }
    public string? CODIGO_SUNAT { get; set; }
    public string? DESCRIPCION { get; set; }
    public decimal DESCUENTO { get; set; }
    public decimal SUB_TOTAL { get; set; }
    public decimal PRECIO_SIN_IMPUESTO { get; set; }
}

public sealed class CPE_RESUMEN_BOLETA
{
    public string? NRO_DOCUMENTO_EMPRESA { get; set; }
    public string? RAZON_SOCIAL { get; set; }
    public string? TIPO_DOCUMENTO { get; set; }
    public string? CODIGO { get; set; }
    public string? SERIE { get; set; }
    public string? SECUENCIA { get; set; }
    public string? FECHA_REFERENCIA { get; set; }
    public string? FECHA_DOCUMENTO { get; set; }
    public int TIPO_PROCESO { get; set; }
    public string? CONTRA_FIRMA { get; set; }
    public string? USUARIO_SOL_EMPRESA { get; set; }
    public string? PASS_SOL_EMPRESA { get; set; }
    public string? RUTA_PFX { get; set; }
    public List<CPE_RESUMEN_BOLETA_DETALLE> detalle { get; set; } = new();
}

public sealed class CPE_RESUMEN_BOLETA_DETALLE
{
    public int? ITEM { get; set; }
    public string? TIPO_COMPROBANTE { get; set; }
    public string? NRO_COMPROBANTE { get; set; }
    public string? TIPO_DOCUMENTO { get; set; }
    public string? NRO_DOCUMENTO { get; set; }
    public string? TIPO_COMPROBANTE_REF { get; set; }
    public string? NRO_COMPROBANTE_REF { get; set; }
    public string? STATU { get; set; }
    public string? COD_MONEDA { get; set; }
    public decimal TOTAL { get; set; }
    public decimal ICBPER { get; set; }
    public decimal GRAVADA { get; set; }
    public decimal ISC { get; set; }
    public decimal IGV { get; set; }
    public decimal OTROS { get; set; }
    public int CARGO_X_ASIGNACION { get; set; }
    public decimal MONTO_CARGO_X_ASIG { get; set; }
    public decimal EXONERADO { get; set; }
    public decimal INAFECTO { get; set; }
    public decimal EXPORTACION { get; set; }
    public decimal GRATUITAS { get; set; }
}

public sealed class CPE_BAJA
{
    public string? NRO_DOCUMENTO_EMPRESA { get; set; }
    public string? RAZON_SOCIAL { get; set; }
    public string? TIPO_DOCUMENTO { get; set; }
    public string? CODIGO { get; set; }
    public string? SERIE { get; set; }
    public string? SECUENCIA { get; set; }
    public string? FECHA_REFERENCIA { get; set; }
    public string? FECHA_BAJA { get; set; }
    public int TIPO_PROCESO { get; set; }
    public string? CONTRA_FIRMA { get; set; }
    public string? USUARIO_SOL_EMPRESA { get; set; }
    public string? PASS_SOL_EMPRESA { get; set; }
    public string? RUTA_PFX { get; set; }
    public List<CPE_BAJA_DETALLE> detalle { get; set; } = new();
}

public sealed class CPE_BAJA_DETALLE
{
    public int? ITEM { get; set; }
    public string? TIPO_COMPROBANTE { get; set; }
    public string? SERIE { get; set; }
    public string? NUMERO { get; set; }
    public string? DESCRIPCION { get; set; }
}

public sealed class CONSULTA_TICKET
{
    public int TIPO_PROCESO { get; set; }
    public string? NRO_DOCUMENTO_EMPRESA { get; set; }
    public string? USUARIO_SOL_EMPRESA { get; set; }
    public string? PASS_SOL_EMPRESA { get; set; }
    public string? TICKET { get; set; }
    public string? TIPO_DOCUMENTO { get; set; }
    public string? NRO_DOCUMENTO { get; set; }
}
