namespace Ecommerce.Domain;

public class ProductoListadoPaginadoResponse
{
    public int Pagina { get; set; }
    public int TamanoPagina { get; set; }
    public int TotalRegistros { get; set; }
    public IReadOnlyList<ProductoListadoItem> Items { get; set; } = Array.Empty<ProductoListadoItem>();
}

public class ProductoListadoItem
{
    public long IdProducto { get; set; }
    public string? NombreLinea { get; set; }
    public string? NombreSublinea { get; set; }
    public string? ProductoCodigo { get; set; }
    public string? ProductoNombre { get; set; }
    public string? ProductoMarca { get; set; }
    public string? Descripcion { get; set; }
    public string? ProductoCantidad { get; set; }
    public string? ProductoUM { get; set; }
    public string? ProductoVenta { get; set; }
    public string? ProductoVentaB { get; set; }
    public decimal? PrecioCosto { get; set; }
    public decimal? CostoDolar { get; set; }
    public decimal? TipoCambio { get; set; }
    public string? AlmacenNombre { get; set; }
    public string? ProductoUbicacion { get; set; }
    public string? ProductoObs { get; set; }
    public string? ProductoEstado { get; set; }
    public string? ProductoUsuario { get; set; }
    public string? ValorUM { get; set; }
    public string? ProductoImagen { get; set; }
    public decimal? ValorCritico { get; set; }
    public string? MaxCantVen { get; set; }
    public string? AplicaINV { get; set; }
}

public class ProductoStockAlmacenesResponse
{
    public decimal CantidadPedido { get; set; }
    public decimal StockTienda { get; set; }
    public decimal FaltaCompletar { get; set; }
    public IReadOnlyList<ProductoStockAlmacenItem> Items { get; set; } = Array.Empty<ProductoStockAlmacenItem>();
}

public class ProductoStockAlmacenItem
{
    public long IdStock { get; set; }
    public long IdProducto { get; set; }
    public string? AlmacenNombre { get; set; }
    public string? Descripcion { get; set; }
    public decimal Cantidad { get; set; }
    public decimal Stock { get; set; }
    public string? UnidadMedida { get; set; }
    public decimal ValorUM { get; set; }
}

public class ProductoAlmacenListadoItem
{
    public int TotalRegistros { get; set; }
    public long IdStock { get; set; }
    public long AlmacenId { get; set; }
    public string? AlmacenNombre { get; set; }
    public long IdProducto { get; set; }
    public string? ProductoCodigo { get; set; }
    public string? ProductoNombre { get; set; }
    public string? ProductoMarca { get; set; }
    public string? Descripcion { get; set; }
    public decimal Cantidad { get; set; }
    public string? ProductoUM { get; set; }
    public decimal? ProductoVenta { get; set; }
    public decimal? ProductoVentaB { get; set; }
    public decimal? PrecioCosto { get; set; }
    public decimal? ValorUM { get; set; }
    public decimal? ValorCritico { get; set; }
    public string? ProductoImagen { get; set; }
    public string? ProductoUbicacion { get; set; }
    public string? Usuario { get; set; }
    public DateTime? FechaEdicion { get; set; }
    public decimal? Inversion { get; set; }
    public bool EsUnidadAlterna { get; set; }
}
