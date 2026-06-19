namespace Ecommerce.Domain;

public class NotaListadoPaginadoResponse
{
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int Total { get; set; }
    public int TotalPages { get; set; }
    public IReadOnlyList<EListaNota> Items { get; set; } = Array.Empty<EListaNota>();
}
