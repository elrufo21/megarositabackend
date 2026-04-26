using System.Text;
using System.Text.Json.Serialization;
using System.Threading.RateLimiting;
using Ecommerce.Api.Legacy;
using Ecommerce.Application;
using Ecommerce.Application.Contracts.Areas;
using Ecommerce.Application.Contracts.Clientes;
using Ecommerce.Application.Contracts.Compras;
using Ecommerce.Application.Contracts.Companias;
using Ecommerce.Application.Contracts.Feriados;
using Ecommerce.Application.Contracts.Infrastructure;
using Ecommerce.Application.Contracts.Lineas;
using Ecommerce.Application.Contracts.Maquinas;
using Ecommerce.Application.Contracts.NotaPedido;
using Ecommerce.Application.Contracts.Personales;
using Ecommerce.Application.Contracts.Productos;
using Ecommerce.Application.Contracts.Proveedores;
using Ecommerce.Application.Contracts.Usuarios;
using Ecommerce.Domain;
using Ecommerce.Infrastructure.ImageCloudinary;
using Ecommerce.Infrastructure.Persistence;
using Ecommerce.Infrastructure.Persistence.Repositories;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddEnvironmentVariables();

const string DevelopmentJwtFallbackKey = "Megarosita_Dev_Jwt_Key_2026_AtLeast_64_Bytes_For_HS512_Signing_ABC123456789";
var jwtSigningKey = builder.Configuration["JwtSettings:Key"];

if (builder.Environment.IsDevelopment())
{
    var isMissingOrPlaceholder = string.IsNullOrWhiteSpace(jwtSigningKey) ||
                                 string.Equals(jwtSigningKey, "CHANGE_ME", StringComparison.OrdinalIgnoreCase);
    var isTooShortForHs512 = !string.IsNullOrWhiteSpace(jwtSigningKey) &&
                             Encoding.UTF8.GetByteCount(jwtSigningKey) < 64;

    if (isMissingOrPlaceholder || isTooShortForHs512)
    {
        builder.Configuration["JwtSettings:Key"] = DevelopmentJwtFallbackKey;
        jwtSigningKey = DevelopmentJwtFallbackKey;
        Console.WriteLine("[DEV] JwtSettings:Key invalida o placeholder. Se usa fallback local para pruebas.");
    }
}

if (string.IsNullOrWhiteSpace(jwtSigningKey))
{
    throw new InvalidOperationException("Missing JwtSettings:Key. Configure it via environment variables, Secret Manager, or appsettings.");
}

if (Encoding.UTF8.GetByteCount(jwtSigningKey) < 64)
{
    throw new InvalidOperationException("JwtSettings:Key must be at least 64 bytes for HS512.");
}

builder.Services.AddInfrastructureServices(builder.Configuration);
builder.Services.AddApplicationServices(builder.Configuration);

builder.Services.AddHttpContextAccessor();
builder.Services.AddProblemDetails();

builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 10 * 1024 * 1024; // 10 MB per multipart request
});

builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(context =>
    {
        var key = context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
        return RateLimitPartition.GetFixedWindowLimiter(key, _ => new FixedWindowRateLimiterOptions
        {
            PermitLimit = 120,
            Window = TimeSpan.FromMinutes(1),
            QueueLimit = 0
        });
    });
});

builder.Services.AddDbContext<EcommerceDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"),
    b => b.MigrationsAssembly(typeof(EcommerceDbContext).Assembly.FullName)
    )
);

builder.Services.AddScoped<IManageImageService, ManageImageService>();
builder.Services.AddTransient<IArea, AreaRepository>();
builder.Services.AddTransient<IPersonal, PersonalRepository>();
builder.Services.AddTransient<IMaquina, MaquinaRepository>();
builder.Services.AddTransient<ILinea, LineaRepository>();
builder.Services.AddTransient<IUsuario, UsuarioRepository>();
builder.Services.AddTransient<IProducto, ProductoRepository>();
builder.Services.AddTransient<INotaPedido, NotaPedidoRepository>();
builder.Services.AddTransient<ICompra, CompraRepository>();
builder.Services.AddTransient<ICliente, ClienteRepository>();
builder.Services.AddTransient<ICompania, CompaniaRepository>();
builder.Services.AddTransient<ICpeGateway, CpeGateway>();
builder.Services.AddTransient<IProveedor, ProveedorRepository>();
builder.Services.AddTransient<ICuentaProveedor, CuentaProveedorRepository>();
builder.Services.AddTransient<IUsuariosCrud, UsuariosCrudRepository>();
builder.Services.AddTransient<IFeriado, FeriadoRepository>();

// Add services to the container.

builder.Services.AddControllers(opt =>
{
    var policy = new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build();
    opt.Filters.Add(new AuthorizeFilter(policy));
}).AddJsonOptions(x =>
{
    x.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    //x.JsonSerializerOptions.Converters.Add(new NullableDateTimeConverter());
});

IdentityBuilder identityBuilder = builder.Services.AddIdentityCore<Usuario>();
identityBuilder = new IdentityBuilder(identityBuilder.UserType, identityBuilder.Services);

identityBuilder.AddRoles<IdentityRole>().AddDefaultTokenProviders();
identityBuilder.AddClaimsPrincipalFactory<UserClaimsPrincipalFactory<Usuario, IdentityRole>>();

identityBuilder.AddEntityFrameworkStores<EcommerceDbContext>();
identityBuilder.AddSignInManager<SignInManager<Usuario>>();

builder.Services.TryAddSingleton<ISystemClock, SystemClock>();


var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSigningKey));
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
.AddJwtBearer(opt =>
{
    opt.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = key,
        ValidateAudience = false,
        ValidateIssuer = false
    };
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("CorsPolicy", corsBuilder =>
    {
        var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? Array.Empty<string>();
        if (allowedOrigins.Length == 0)
        {
            if (builder.Environment.IsDevelopment())
            {
                corsBuilder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
            }
            return;
        }

        corsBuilder.WithOrigins(allowedOrigins)
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseHsts();
}

app.UseExceptionHandler();
app.UseHttpsRedirection();
app.UseRateLimiter();

app.UseCors("CorsPolicy");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();


using (var scope = app.Services.CreateScope())
{
    var service = scope.ServiceProvider;
    var loggerFactory = service.GetRequiredService<ILoggerFactory>();

    try
    {
        var context = service.GetRequiredService<EcommerceDbContext>();
        var usuarioManager = service.GetRequiredService<UserManager<Usuario>>();
        var roleManager = service.GetRequiredService<RoleManager<IdentityRole>>();
        await context.Database.MigrateAsync();
        //await EcommerceDbContextData.LoadDataAsync(context, usuarioManager, roleManager, loggerFactory);
    }
    catch (Exception ex)
    {
        var logger = loggerFactory.CreateLogger<Program>();
        logger.LogError(ex, "Error en la migration");
    }
}

app.Run();
