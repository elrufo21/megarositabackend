using System.Net;
using Ecommerce.Application.Contracts.Usuarios;
using Ecommerce.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class UserController : ControllerBase
{
    private readonly IUsuario _mediator;

    public UserController(IUsuario mediador)
    {
        _mediator = mediador;
    }

    [AllowAnonymous]
    [HttpPost("acceso", Name = "Acceso")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    [ProducesResponseType((int)HttpStatusCode.Unauthorized)]
    [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
    public async Task<ActionResult<AuthResponseA>> Acceso([FromBody] EUser request, CancellationToken cancellationToken)
    {
        try
        {
            return Ok(await _mediator.LoginAsync(request, cancellationToken));
        }
        catch (UnauthorizedAccessException ex)
        {
            return Unauthorized(new
            {
                ok = false,
                mensaje = ex.Message
            });
        }
        catch (InvalidOperationException ex)
        {
            return StatusCode((int)HttpStatusCode.InternalServerError, new
            {
                ok = false,
                mensaje = ex.Message
            });
        }
    }
}
