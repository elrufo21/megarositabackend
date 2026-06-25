using System.Net;
using Ecommerce.Application.Contracts.Productos;
using Ecommerce.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;


[ApiController]
[Route("api/v1/[controller]")]
public class ProductosController : ControllerBase
{
    private const long MaxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
    private const string ProductImageDirectory = @"D:\ArchivoSistema\ImagenesLogistica";
    private static readonly HashSet<string> AllowedImageContentTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "image/jpeg",
        "image/png",
        "image/webp"
    };

    private readonly IProducto _mediator;
    private readonly ILogger<ProductosController> _logger;

    public ProductosController(IProducto mediador, ILogger<ProductosController> logger)
    {
        _mediator = mediador;
        _logger = logger;
    }

    [Authorize]
    [RequestSizeLimit(MaxImageSizeBytes)]
    [RequestFormLimits(MultipartBodyLengthLimit = MaxImageSizeBytes)]
    [HttpPost("register", Name = "RegisterProducto")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> RegisterProducto(
        [FromForm] Producto producto,
        [FromForm(Name = "imagen")] IFormFile? imagen,
        [FromForm(Name = "imageFile")] IFormFile? imageFile,
        [FromForm(Name = "imagenUnidad")] IFormFile? imagenUnidad,
        [FromForm] bool eliminarImagen = false,
        CancellationToken cancellationToken = default)
    {
        var imagenRequest = imagen ?? imageFile;

        Producto? existente = null;
        if (producto.IdProducto > 0)
        {
            existente = await _mediator.ObtenerPorIdAsync(producto.IdProducto, cancellationToken);
        }

        if (imagenRequest is not null && imagenRequest.Length > 0)
        {
            if (!IsValidImage(imagenRequest, out var error))
            {
                return BadRequest(error);
            }

            var fileName = await SaveProductImageAsync(imagenRequest, cancellationToken);
            if (fileName is null)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "No se pudo guardar la imagen del producto.");
            }

            if (existente is not null && !string.IsNullOrWhiteSpace(existente.ProductoImagen))
            {
                DeleteProductImage(existente.ProductoImagen);
            }

            producto.ProductoImagen = fileName;
        }
        else if (eliminarImagen)
        {
            if (existente is not null && !string.IsNullOrWhiteSpace(existente.ProductoImagen))
            {
                DeleteProductImage(existente.ProductoImagen);
            }
            producto.ProductoImagen = string.Empty;
        }
        else if (producto.IdProducto > 0 && string.IsNullOrWhiteSpace(producto.ProductoImagen))
        {
            // Mantener la imagen existente en una actualización cuando no se envía nueva.
            if (existente is not null)
            {
                producto.ProductoImagen = existente.ProductoImagen;
            }
        }

        var unidadImagenFiles = GetUnidadMedidaImageFiles(imagenUnidad);
        var unidadImagenError = await ReplaceUnidadMedidaImagesFromFilesAsync(producto, unidadImagenFiles, cancellationToken);
        if (!string.IsNullOrWhiteSpace(unidadImagenError))
        {
            return BadRequest(unidadImagenError);
        }

        return Ok(await _mediator.InsertarAsync(producto, cancellationToken));
    }

    [Authorize]
    [RequestSizeLimit(MaxImageSizeBytes)]
    [RequestFormLimits(MultipartBodyLengthLimit = MaxImageSizeBytes)]
    [HttpPost("register-with-image", Name = "RegisterProductoConImagen")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> RegisterProductoConImagen(
        [FromForm] Producto producto,
        [FromForm(Name = "imagen")] IFormFile? imagen,
        [FromForm(Name = "imageFile")] IFormFile? imageFile,
        [FromForm(Name = "imagenUnidad")] IFormFile? imagenUnidad,
        CancellationToken cancellationToken)
    {
        var imagenRequest = imagen ?? imageFile;
        if (imagenRequest is not null && imagenRequest.Length > 0)
        {
            if (!IsValidImage(imagenRequest, out var error))
            {
                return BadRequest(error);
            }

            var fileName = await SaveProductImageAsync(imagenRequest, cancellationToken);
            if (fileName is null)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "No se pudo guardar la imagen del producto.");
            }

            producto.ProductoImagen = fileName;
        }

        var unidadImagenFiles = GetUnidadMedidaImageFiles(imagenUnidad);
        var unidadImagenError = await ReplaceUnidadMedidaImagesFromFilesAsync(producto, unidadImagenFiles, cancellationToken);
        if (!string.IsNullOrWhiteSpace(unidadImagenError))
        {
            return BadRequest(unidadImagenError);
        }

        return Ok(await _mediator.InsertarAsync(producto, cancellationToken));
    }

    [Authorize]
    [RequestSizeLimit(MaxImageSizeBytes)]
    [RequestFormLimits(MultipartBodyLengthLimit = MaxImageSizeBytes)]
    [HttpPost("unidad-medida", Name = "GuardarUnidadMedidaProducto")]
    [ProducesResponseType(typeof(GuardarUnidadMedidaProductoResponse), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<GuardarUnidadMedidaProductoResponse>> GuardarUnidadMedidaProducto(
        [FromForm] GuardarUnidadMedidaProductoRequest request,
        [FromForm(Name = "imagen")] IFormFile? imagen,
        CancellationToken cancellationToken = default)
    {
        if (request.IdProducto <= 0)
        {
            return BadRequest("IdProducto debe ser mayor a 0.");
        }

        if (string.IsNullOrWhiteSpace(request.UMDescripcion))
        {
            return BadRequest("UMDescripcion es requerido.");
        }

        if (imagen is not null && imagen.Length > 0)
        {
            if (!IsValidImage(imagen, out var error))
            {
                return BadRequest(error);
            }

            var fileName = await SaveProductImageAsync(imagen, cancellationToken);
            if (fileName is null)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "No se pudo guardar la imagen de la unidad.");
            }

            request.UnidadImagen = fileName;
        }

        var idUm = await _mediator.GuardarUnidadMedidaProductoAsync(request, cancellationToken);
        return Ok(new GuardarUnidadMedidaProductoResponse
        {
            IdUm = idUm
        });
    }

    [Authorize]
    [HttpDelete("{id:long}", Name = "EliminarProducto")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> EliminarProducto(long id, CancellationToken cancellationToken)
    {
        var existente = await _mediator.ObtenerPorIdAsync(id, cancellationToken);
        if (existente is not null && !string.IsNullOrWhiteSpace(existente.ProductoImagen))
        {
            DeleteProductImage(existente.ProductoImagen);
        }

        return Ok(await _mediator.EliminarAsync(id, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("list", Name = "GetProductoList")]
    [ProducesResponseType(typeof(string), (int)HttpStatusCode.OK)]
    public async Task<IActionResult> GetProductoList(
        [FromQuery] string? estado = "ACTIVO",
        CancellationToken cancellationToken = default)
    {
        var raw = await _mediator.ListarCrudRawAsync(estado, cancellationToken);
        return Content(raw, "text/plain");
    }

    [AllowAnonymous]
    [HttpGet("{id:long}", Name = "GetProductoById")]
    [ProducesResponseType(typeof(Producto), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<Producto?>> GetProductoById(long id, CancellationToken cancellationToken)
    {
        var producto = await _mediator.ObtenerPorIdAsync(id, cancellationToken);
        if (producto is null) return NotFound();
        return Ok(producto);
    }

    [AllowAnonymous]
    [HttpGet("listaPro", Name = "GetListPro")]
    [ProducesResponseType(typeof(IReadOnlyList<EListaProducto>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<EListaProducto>>> GetListPro(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        return Ok(await _mediator.ListarAsync(page, pageSize, cancellationToken));
    }
    [AllowAnonymous]
    [HttpGet("buscaPro", Name = "GetBusPro")]
    [ProducesResponseType(typeof(IReadOnlyList<EListaProducto>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<EListaProducto>>> GetBusPro(
        [FromQuery] string nombre,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        return Ok(await _mediator.BuscarProductoAsync(nombre, page, pageSize, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("listar-productos", Name = "ListarProductosPaginado")]
    [ProducesResponseType(typeof(IReadOnlyList<ProductoListadoItem>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<ProductoListadoItem>>> ListarProductos(
        [FromQuery] string? busqueda = "",
        CancellationToken cancellationToken = default)
    {
        return Ok(await _mediator.ListarProductosAsync(busqueda, cancellationToken));
    }

    private static bool IsValidImage(IFormFile file, out string error)
    {
        if (file.Length > MaxImageSizeBytes)
        {
            error = $"La imagen excede el límite de {MaxImageSizeBytes / (1024 * 1024)} MB.";
            return false;
        }

        if (!AllowedImageContentTypes.Contains(file.ContentType))
        {
            error = "Tipo de archivo no permitido. Use JPG, PNG o WEBP.";
            return false;
        }

        error = string.Empty;
        return true;
    }

    private IReadOnlyList<IFormFile> GetUnidadMedidaImageFiles(IFormFile? imagenUnidad)
    {
        if (imagenUnidad is not null)
        {
            return new[] { imagenUnidad };
        }

        if (!Request.HasFormContentType || Request.Form.Files.Count == 0)
        {
            return Array.Empty<IFormFile>();
        }

        return Request.Form.Files
            .Where(file => IsUnidadMedidaFileField(file.Name))
            .ToList();
    }

    private async Task<string?> ReplaceUnidadMedidaImagesFromFilesAsync(
        Producto producto,
        IReadOnlyList<IFormFile> files,
        CancellationToken cancellationToken)
    {
        if (files.Count == 0)
        {
            return null;
        }

        var rawData = producto.Data;
        if (string.IsNullOrWhiteSpace(rawData))
        {
            return "Se enviaron imágenes de unidad de medida, pero falta el campo Data con el detalle.";
        }

        var openIndex = rawData.IndexOf('[');
        var closeIndex = rawData.LastIndexOf(']');
        if (openIndex < 0 || closeIndex <= openIndex)
        {
            return "Formato de Data inválido. Debe incluir detalle de unidad de medida entre [ y ].";
        }

        var detalle = rawData[(openIndex + 1)..closeIndex];
        if (string.IsNullOrWhiteSpace(detalle))
        {
            return "Se enviaron imágenes de unidad de medida, pero el detalle de Data está vacío.";
        }

        var items = detalle.Split(';');
        if (items.Length == 0)
        {
            return null;
        }

        var indexedFiles = new Dictionary<int, IFormFile>();
        var sequentialFiles = new Queue<IFormFile>();
        foreach (var file in files)
        {
            if (TryGetUnidadMedidaIndex(file.Name, out var index))
            {
                indexedFiles[index] = file;
                continue;
            }

            sequentialFiles.Enqueue(file);
        }

        var changed = false;
        for (var i = 0; i < items.Length; i++)
        {
            var item = items[i];
            if (string.IsNullOrWhiteSpace(item))
            {
                continue;
            }

            var file = indexedFiles.TryGetValue(i, out var indexedFile)
                ? indexedFile
                : sequentialFiles.Count > 0 ? sequentialFiles.Dequeue() : null;

            if (file is null || file.Length == 0)
            {
                continue;
            }

            if (!IsValidImage(file, out var error))
            {
                return $"Imagen de unidad de medida inválida ({file.Name}): {error}";
            }

            var campos = item.Split('|').ToList();
            while (campos.Count < 6)
            {
                campos.Add(string.Empty);
            }

            var fileName = await SaveProductImageAsync(file, cancellationToken);
            if (fileName is null)
            {
                return $"No se pudo guardar la imagen de unidad de medida ({file.Name}).";
            }

            campos[5] = fileName;
            items[i] = string.Join("|", campos);
            changed = true;
        }

        if (!changed)
        {
            return null;
        }

        var detalleActualizado = string.Join(";", items);
        producto.Data = $"{rawData[..(openIndex + 1)]}{detalleActualizado}{rawData[closeIndex..]}";
        return null;
    }

    private static bool IsUnidadMedidaFileField(string? fieldName)
    {
        if (string.IsNullOrWhiteSpace(fieldName))
        {
            return false;
        }

        var normalized = fieldName.Trim().ToLowerInvariant();
        if (normalized == "imagenunidad")
        {
            return true;
        }

        return normalized == "unidadimagen"
            || normalized == "unidadimagenes"
            || normalized.StartsWith("unidadimagen[", StringComparison.Ordinal)
            || normalized.StartsWith("unidadimagenes[", StringComparison.Ordinal)
            || normalized.StartsWith("unidadimagen_", StringComparison.Ordinal)
            || normalized.StartsWith("unidadimagenes_", StringComparison.Ordinal)
            || normalized.StartsWith("imagenunidad[", StringComparison.Ordinal)
            || normalized.StartsWith("imagenunidad_", StringComparison.Ordinal);
    }

    private static bool TryGetUnidadMedidaIndex(string fieldName, out int index)
    {
        index = -1;
        if (string.IsNullOrWhiteSpace(fieldName))
        {
            return false;
        }

        var openBracket = fieldName.IndexOf('[');
        if (openBracket >= 0)
        {
            var closeBracket = fieldName.IndexOf(']', openBracket + 1);
            if (closeBracket > openBracket + 1)
            {
                var value = fieldName[(openBracket + 1)..closeBracket];
                return int.TryParse(value, out index) && index >= 0;
            }
        }

        var lastUnderscore = fieldName.LastIndexOf('_');
        if (lastUnderscore >= 0 && lastUnderscore < fieldName.Length - 1)
        {
            var value = fieldName[(lastUnderscore + 1)..];
            return int.TryParse(value, out index) && index >= 0;
        }

        return false;
    }

    private async Task<string?> SaveProductImageAsync(IFormFile file, CancellationToken cancellationToken)
    {
        try
        {
            Directory.CreateDirectory(ProductImageDirectory);

            var extension = NormalizeImageExtension(file);
            var baseName = SanitizeFileName(Path.GetFileNameWithoutExtension(file.FileName));
            if (string.IsNullOrWhiteSpace(baseName))
            {
                baseName = Guid.NewGuid().ToString("N");
            }

            var fileName = $"{baseName}{extension}";
            var path = Path.Combine(ProductImageDirectory, fileName);
            if (System.IO.File.Exists(path))
            {
                fileName = $"{baseName}-{Guid.NewGuid():N}{extension}";
                path = Path.Combine(ProductImageDirectory, fileName);
            }

            await using var source = file.OpenReadStream();
            await using var destination = System.IO.File.Create(path);
            await source.CopyToAsync(destination, cancellationToken);
            return fileName;
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            _logger.LogError(ex, "No se pudo guardar la imagen en {Directory}", ProductImageDirectory);
            return null;
        }
    }

    private void DeleteProductImage(string? value)
    {
        var fileName = NormalizeStoredImageFileName(value);
        if (string.IsNullOrWhiteSpace(fileName))
        {
            return;
        }

        try
        {
            var path = Path.Combine(ProductImageDirectory, fileName);
            if (System.IO.File.Exists(path))
            {
                System.IO.File.Delete(path);
            }
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            _logger.LogWarning(ex, "No se pudo eliminar la imagen {FileName}", fileName);
        }
    }

    private static string NormalizeImageExtension(IFormFile file)
    {
        var extension = Path.GetExtension(file.FileName).ToLowerInvariant();
        if (extension is ".jpg" or ".jpeg" or ".png" or ".webp")
        {
            return extension;
        }

        return file.ContentType.ToLowerInvariant() switch
        {
            "image/png" => ".png",
            "image/webp" => ".webp",
            _ => ".jpg"
        };
    }

    private static string SanitizeFileName(string? value)
    {
        var invalidChars = Path.GetInvalidFileNameChars();
        return new string((value ?? string.Empty)
            .Where(c => !invalidChars.Contains(c))
            .ToArray())
            .Trim();
    }

    private static string? NormalizeStoredImageFileName(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        var normalized = value.Trim();
        if (Uri.TryCreate(normalized, UriKind.Absolute, out var uri))
        {
            normalized = Uri.UnescapeDataString(uri.Segments.LastOrDefault() ?? string.Empty);
        }

        normalized = normalized.Replace('/', Path.DirectorySeparatorChar);
        return Path.GetFileName(normalized);
    }
}
