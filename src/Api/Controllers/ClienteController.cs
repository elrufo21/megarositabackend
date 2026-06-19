using System.Net;
using Ecommerce.Application.Contracts.Clientes;
using Ecommerce.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class ClienteController: ControllerBase
{
    private readonly ICliente _mediator;

    public ClienteController(ICliente mediador)
    {
        _mediator = mediador;
    }

    [Authorize]
    [HttpPost("register", Name = "RegisterCliente")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> RegisterCliente([FromBody] Cliente cliente, CancellationToken cancellationToken)
    {
        var result = await _mediator.InsertarAsync(cliente, cancellationToken);

        if (result.StartsWith("error:", StringComparison.OrdinalIgnoreCase))
        {
            return Conflict(new
            {
                ok = false,
                mensaje = result[6..].Trim()
            });
        }

        return Ok(result);
    }
    
    [Authorize]
    [HttpDelete("{id}", Name = "EliminarCliente")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> EliminarCliente(long id, CancellationToken cancellationToken)
    {
        var eliminado = await _mediator.EliminarAsync(id, cancellationToken);
        if (!eliminado)
        {
            return Conflict(new
            {
                ok = false,
                mensaje = "No se pudo eliminar el cliente."
            });
        }

        return Ok(new
        {
            ok = true,
            mensaje = "Cliente eliminado correctamente."
        });
    }

    [AllowAnonymous]
    [HttpGet("list", Name = "GetClienteList")]
    [ProducesResponseType(typeof(IReadOnlyList<Cliente>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<Cliente>>> GetClienteList(
        [FromQuery] string? estado = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        var estadoFiltro = string.IsNullOrWhiteSpace(estado) ? null : estado.Trim();
        return Ok(await _mediator.ListarAsync(estadoFiltro, page, pageSize, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet(Name = "GetListCombo")]
    [ProducesResponseType(typeof(string), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<string>> ListarCombo(CancellationToken cancellationToken)
    {
        return Ok(await _mediator.ListarComboAsync(cancellationToken));
    }
}
