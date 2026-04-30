USE [master]
GO
/****** Object:  Database [MEGAROSITAB_ACT]    Script Date: 29/04/2026 15:56:22 ******/
CREATE DATABASE [MEGAROSITAB_ACT] ON  PRIMARY 
( NAME = N'MEGAROSITA', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPSS_2008\MSSQL\DATA\MEGAROSITAB_ACT.mdf' , SIZE = 1062144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MEGAROSITA_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPSS_2008\MSSQL\DATA\MEGAROSITAB_ACT.ldf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MEGAROSITAB_ACT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET ARITHABORT OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET  MULTI_USER 
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET DB_CHAINING OFF 
GO
USE [MEGAROSITAB_ACT]
GO
/****** Object:  Schema [web]    Script Date: 29/04/2026 15:56:22 ******/
CREATE SCHEMA [web]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularEdad]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcularEdad]
(
    @FecNac             date
)
RETURNS int
AS
BEGIN
declare 
 @fechaActual date,
 @anioNacimiento int,
 @mesNacimiento int,
 @diaNacimiento int,
 @añoActual int,
 @mesActual int,
 @diaActual int,
 @anios int

set @fechaActual=getdate()
set @anioNacimiento = year(@FecNac)
set @mesNacimiento = month(@FecNac)
set @diaNacimiento = day(@FecNac)

set @añoActual = CONVERT(int,year(@fechaActual))
set @mesActual = CONVERT(int,month(@fechaActual))
set @diaActual = CONVERT(int,day(@fechaActual))



set @anios = @añoActual - @anioNacimiento

if ((@mesActual - @mesNacimiento)<0)
begin
if (@anioNacimiento<@añoActual)
   set @anios=@anios-1 
end

if ((@mesActual = @mesNacimiento))
begin
   if (@diaNacimiento>@diaActual)
   set @anios=@anios-1 
end

RETURN @anios
END
GO
/****** Object:  UserDefinedFunction [dbo].[desincrectar]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[desincrectar]
( @clave varbinary(500))

 returns varchar(100)
 as
 begin
 declare @pass as varchar(50)
 set @pass=DECRYPTBYPASSPHRASE('clave',@clave)
 return @pass
 end
GO
/****** Object:  UserDefinedFunction [dbo].[diaNombre]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[diaNombre]  
(@fecha date)  
returns nvarchar(20)  
as  
begin  
declare @NomDia nvarchar(20)  
  if (DATEPART(dw,@fecha)=7)set @NomDia='DOMINGO'  
  if (DATEPART(dw,@fecha)=1)set @NomDia='LUNES'  
  if (DATEPART(dw,@fecha)=2)set @NomDia='MARTES'  
  if (DATEPART(dw,@fecha)=3)set @NomDia='MIERCOLES'  
  if (DATEPART(dw,@fecha)=4)set @NomDia='JUEVES'  
  if (DATEPART(dw,@fecha)=5)set @NomDia='VIERNES'  
  if (DATEPART(dw,@fecha)=6)set @NomDia='SABADO'  
 return @Nomdia  
end
GO
/****** Object:  UserDefinedFunction [dbo].[encriptar]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[encriptar]
( @clave varchar(50))
 returns varbinary(500)
 as
 begin
 declare @pass as varbinary(500)
 set @pass=ENCRYPTBYPASSPHRASE('clave',@clave)
 return @pass
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplitString]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSplitString] 
( 
    @string VARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata VARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
    END 
    RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[geneneraIdLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[geneneraIdLiquida] (@dato varchar(20) )
returns varchar(12)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(12)
set @codigo=SUBSTRING(@dato,1,4)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(LiquidacionNumero,8))),0)FROM Liquidacion
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@codigo)+RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[geneneraIdLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[geneneraIdLiVenta] (@dato varchar(20))
returns varchar(12)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(12)
set @codigo=SUBSTRING(@dato,1,4)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(LiquidacionNumero,8))),0)FROM LiquidacionVenta
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@codigo)+RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[genenerarNroFactura]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[genenerarNroFactura](@dato varchar(20),@CompaniaId int,@DocuDocumento varchar(40))
returns varchar(13)
begin 
declare @autoincremento int,
@numero varchar(8),
@codigo varchar(11)
set @codigo=SUBSTRING(@dato,1,4)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(DocuNumero,8))),0)FROM DocumentoVenta
where CompaniaId=@CompaniaId and (DocuDocumento=@DocuDocumento and DocuSerie=@dato)
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[genenerarNroGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[genenerarNroGuia] (@dato varchar(20))
returns varchar(11)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(11)
set @codigo=SUBSTRING(@dato,1,5)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(GuiaNumero,6))),0)FROM GuiaRemision
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('00000' + convert(varchar,@autoincremento),6)
set @codigo=RTRIM(@codigo)+RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[Letras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Letras]
(
    @Numero             Decimal(18,2),
    @Moneda             varchar(60)
)
RETURNS Varchar(180)
AS
BEGIN
    DECLARE @RespLetra Varchar(180)
        DECLARE @lnEntero INT,
                        @lcRetorno VARCHAR(512),
                        @lnTerna INT,
                        @lcMiles VARCHAR(512),
                        @lcCadena VARCHAR(512),
                        @lnUnidades INT,
                        @lnDecenas INT,
                        @lnCentenas INT,
                        @lnFraccion INT
        SELECT  @lnEntero = CAST(@Numero AS INT),
                        @lnFraccion = (@Numero - @lnEntero) * 100,
                        @lcRetorno = '',
                        @lnTerna = 1
  WHILE @lnEntero > 0
  BEGIN /* WHILE */
            -- Recorro terna por terna
            SELECT @lcCadena = ''
            SELECT @lnUnidades = @lnEntero % 10
            SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
            SELECT @lnDecenas = @lnEntero % 10
            SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
            SELECT @lnCentenas = @lnEntero % 10
            SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
            -- Analizo las unidades
            SELECT @lcCadena =
            CASE /* UNIDADES */
              WHEN @lnUnidades = 1 THEN 'UN ' + @lcCadena
              WHEN @lnUnidades = 2 THEN 'DOS ' + @lcCadena
              WHEN @lnUnidades = 3 THEN 'TRES ' + @lcCadena
              WHEN @lnUnidades = 4 THEN 'CUATRO ' + @lcCadena
              WHEN @lnUnidades = 5 THEN 'CINCO ' + @lcCadena
              WHEN @lnUnidades = 6 THEN 'SEIS ' + @lcCadena
              WHEN @lnUnidades = 7 THEN 'SIETE ' + @lcCadena
              WHEN @lnUnidades = 8 THEN 'OCHO ' + @lcCadena
              WHEN @lnUnidades = 9 THEN 'NUEVE ' + @lcCadena
              ELSE @lcCadena
            END /* UNIDADES */
            -- Analizo las decenas
            SELECT @lcCadena =
            CASE /* DECENAS */
              WHEN @lnDecenas = 1 THEN
                CASE @lnUnidades
                  WHEN 0 THEN 'DIEZ '
                  WHEN 1 THEN 'ONCE '
                  WHEN 2 THEN 'DOCE '
                  WHEN 3 THEN 'TRECE '
                  WHEN 4 THEN 'CATORCE '
                  WHEN 5 THEN 'QUINCE '
                  WHEN 6 THEN 'DIEZ Y SEIS '
                  WHEN 7 THEN 'DIEZ Y SIETE '
                  WHEN 8 THEN 'DIEZ Y OCHO '
                  WHEN 9 THEN 'DIEZ Y NUEVE '
                END
              WHEN @lnDecenas = 2 THEN
              CASE @lnUnidades
                WHEN 0 THEN 'VEINTE '
                ELSE 'VEINTI' + @lcCadena
              END
              WHEN @lnDecenas = 3 THEN
              CASE @lnUnidades
                WHEN 0 THEN 'TREINTA '
                ELSE 'TREINTA Y ' + @lcCadena
              END
              WHEN @lnDecenas = 4 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'CUARENTA'
                    ELSE 'CUARENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 5 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'CINCUENTA '
                    ELSE 'CINCUENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 6 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'SESENTA '
                    ELSE 'SESENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 7 THEN
                 CASE @lnUnidades
                    WHEN 0 THEN 'SETENTA '
                    ELSE 'SETENTA Y ' + @lcCadena
                 END
              WHEN @lnDecenas = 8 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'OCHENTA '
                    ELSE  'OCHENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 9 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'NOVENTA '
                    ELSE 'NOVENTA Y ' + @lcCadena
                END
              ELSE @lcCadena
            END /* DECENAS */
            -- Analizo las centenas
            SELECT @lcCadena =
            CASE /* CENTENAS */
			WHEN @lnCentenas = 1 AND @lnTerna = 3 THEN 'CIEN ' + @lcCadena
WHEN @lnCentenas = 1 AND @lnUnidades = 0 AND @lnDecenas = 0 THEN 'CIEN ' + @lcCadena
WHEN @lnCentenas = 1 AND @lnTerna <> 3 THEN 'CIENTO ' + @lcCadena
              WHEN @lnCentenas = 1 THEN 'CIENTO ' + @lcCadena
              WHEN @lnCentenas = 2 THEN 'DOSCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 3 THEN 'TRESCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 4 THEN 'CUATROCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 5 THEN 'QUINIENTOS ' + @lcCadena
              WHEN @lnCentenas = 6 THEN 'SEISCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 7 THEN 'SETECIENTOS ' + @lcCadena
              WHEN @lnCentenas = 8 THEN 'OCHOCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 9 THEN 'NOVECIENTOS ' + @lcCadena
              ELSE @lcCadena
            END /* CENTENAS */
            -- Analizo la terna
            SELECT @lcCadena =
            CASE /* TERNA */
              WHEN @lnTerna = 1 THEN @lcCadena
              WHEN @lnTerna = 2 THEN @lcCadena + 'MIL '
              WHEN @lnTerna = 3 THEN @lcCadena + 'MILLONES '
              WHEN @lnTerna = 4 THEN @lcCadena + 'MIL '
              ELSE ''
            END /* TERNA */
            -- Armo el retorno terna a terna
            SELECT @lcRetorno = @lcCadena  + @lcRetorno
            SELECT @lnTerna = @lnTerna + 1
   END /* WHILE */
   IF @lnTerna = 1
       SELECT @lcRetorno = 'CERO'
   DECLARE @sFraccion VARCHAR(15)
   SET @sFraccion = '00' + LTRIM(CAST(@lnFraccion AS varchar))
   SELECT @RespLetra = RTRIM(@lcRetorno) + ' CON ' + SUBSTRING(@sFraccion,LEN(@sFraccion)-1,2) + '/100 '+@Moneda
   RETURN @RespLetra
END
GO
/****** Object:  UserDefinedFunction [dbo].[MesNombre]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[MesNombre]
(@NroMes int)
returns nvarchar(20)
as
begin
declare @NomMes nvarchar(20)
--set @NroMes=12
	 if (@NroMes=1)set @NomMes='Enero'
	 if (@NroMes=2)set @NomMes='Febreo'
	 if (@NroMes=3)set @NomMes='Marzo'
	 if (@NroMes=4)set @NomMes='Abril'
	 if (@NroMes=5)set @NomMes='Mayo'
	 if (@NroMes=6)set @NomMes='Junio'
	 if (@NroMes=7)set @NomMes='Julio'
	 if (@NroMes=8)set @NomMes='Agosto'
	 if (@NroMes=9)set @NomMes='Septiembre'
	 if (@NroMes=10)set @NomMes='Octubre'
	 if (@NroMes=11)set @NomMes='Noviembre'
	 if (@NroMes=12)set @NomMes='Diciembre'
 return @NomMes
end
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Addresses]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Direccion] [nvarchar](max) NULL,
	[Ciudad] [nvarchar](max) NULL,
	[Departamento] [nvarchar](max) NULL,
	[CodigoPostal] [nvarchar](max) NULL,
	[Username] [nvarchar](max) NULL,
	[Pais] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Almacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Almacen](
	[AlmacenId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[AlmacenNombre] [varchar](80) NULL,
	[AlmacenDepartamento] [varchar](80) NULL,
	[AlmacenProvincia] [varchar](80) NULL,
	[AlmacenDistrito] [varchar](80) NULL,
	[AlmacenDireccion] [varchar](300) NULL,
	[AlmacenEstado] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[AlmacenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Area]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area](
	[AreaId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[AreaNombre] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Asistencia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asistencia](
	[Id] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NULL,
	[PersonalId] [numeric](20, 0) NULL,
	[HoraIngreso] [datetime] NULL,
	[SalidaRefrigerio] [datetime] NULL,
	[IngresoRefrigerio] [datetime] NULL,
	[HoraSalida] [datetime] NULL,
	[NroMarcacion] [int] NULL,
	[Observaciones] [varchar](max) NULL,
	[NroTardanza] [int] NULL,
	[Estado] [nvarchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](36) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](36) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](90) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](36) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](36) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](36) NOT NULL,
	[RoleId] [nvarchar](36) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](36) NOT NULL,
	[Nombre] [nvarchar](max) NULL,
	[Apellido] [nvarchar](max) NULL,
	[Telefono] [nvarchar](max) NULL,
	[AvatarUrl] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](90) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](36) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BLOQUE]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BLOQUE](
	[BloqueId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[BloqueCaja] [numeric](38, 0) NULL,
	[BloqueFecha] [datetime] NULL,
	[BloqueTotal] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[BloqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Caja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Caja](
	[CajaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CajaFecha] [datetime] NULL,
	[CajaCierre] [varchar](40) NULL,
	[MontoIniSOl] [decimal](18, 2) NULL,
	[CajaEncargado] [varchar](60) NULL,
	[CajaUsuario] [varchar](60) NULL,
	[CajaEstado] [varchar](40) NULL,
	[CajaIngresos] [decimal](18, 2) NULL,
	[CajaDeposito] [decimal](18, 2) NULL,
	[CajaSalidas] [decimal](18, 2) NULL,
	[CajaTotal] [decimal](18, 2) NULL,
	[UsuarioId] [int] NULL,
	[Observacion] [varchar](max) NULL,
	[CajaIdB] [nvarchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[CajaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajaDetalle]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajaDetalle](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CajaId] [numeric](38, 0) NULL,
	[DetalleFecha] [datetime] NULL,
	[NotaId] [numeric](38, 0) NULL,
	[DetalleMovimiento] [varchar](80) NULL,
	[DetalleReferencia] [varchar](80) NULL,
	[DetalleConcepto] [varchar](250) NULL,
	[DetalleMonto] [decimal](18, 2) NULL,
	[DetalleEfectivo] [decimal](18, 2) NULL,
	[DetalleVuelto] [decimal](18, 2) NULL,
	[RutaImagen] [varchar](max) NULL,
	[Estado] [nvarchar](1) NULL,
	[Vista] [nvarchar](1) NULL,
	[Usuario] [varchar](80) NULL,
	[GastoId] [varchar](40) NULL,
	[LiquidaId] [nvarchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajaGeneral]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajaGeneral](
	[IdGeneral] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[FechaCierre] [datetime] NULL,
	[Usuario] [varchar](80) NULL,
	[Ingresos] [decimal](18, 2) NULL,
	[Salidas] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdGeneral] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajaPincipal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajaPincipal](
	[IdCaja] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CajaConcepto] [varchar](80) NULL,
	[CajaFecha] [datetime] NULL,
	[CajaId] [numeric](38, 0) NULL,
	[CajaDescripcion] [varchar](250) NULL,
	[CajaMonto] [decimal](18, 2) NULL,
	[CajaUsuario] [varchar](20) NULL,
	[IdGeneral] [numeric](38, 0) NULL,
	[Referencia] [nvarchar](40) NULL,
	[GastoId] [nvarchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[ClienteId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[ClienteRazon] [varchar](140) NULL,
	[ClienteRuc] [varchar](40) NULL,
	[ClienteDni] [varchar](40) NULL,
	[ClienteDireccion] [varchar](max) NULL,
	[ClienteMovil] [varchar](80) NULL,
	[ClienteTelefono] [varchar](80) NULL,
	[ClienteCorreo] [varchar](80) NULL,
	[ClienteEstado] [varchar](40) NULL,
	[ClienteDespacho] [varchar](max) NULL,
	[ClienteUsuario] [varchar](80) NULL,
	[ClienteFecha] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compania]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compania](
	[CompaniaId] [int] IDENTITY(1,1) NOT NULL,
	[CompaniaRazonSocial] [varchar](140) NULL,
	[CompaniaRUC] [varchar](20) NULL,
	[CompaniaDireccion] [varchar](max) NULL,
	[CompaniaTelefono] [varchar](80) NULL,
	[CompaniaEmail] [varchar](100) NULL,
	[CompaniaIniFecha] [varchar](100) NULL,
	[CompaniaComercial] [varchar](250) NULL,
	[CompaniaUserSecun] [varchar](250) NULL,
	[ComapaniaPWD] [varchar](250) NULL,
	[CompaniaPFX] [varchar](250) NULL,
	[CompaniaClave] [varchar](250) NULL,
	[CompaniaNomUBG] [varchar](40) NULL,
	[CompaniaCodigoUBG] [varchar](10) NULL,
	[CompaniaDistrito] [varchar](40) NULL,
	[CompaniaDirecSunat] [varchar](250) NULL,
	[ICBPER] [decimal](18, 2) NULL,
	[TokenApi] [varchar](max) NULL,
	[ClienIdToken] [varchar](300) NULL,
	[DescuentoMax] [decimal](18, 2) NULL,
	[EfectivoMax] [decimal](18, 2) NULL,
	[RenovacionFirma] [date] NULL,
	[CorreoSGO] [varchar](80) NULL,
	[PasswordCorreo] [varchar](80) NULL,
	[CorreosAdmin] [varchar](max) NULL,
	[RenovacionOSE] [date] NULL,
	[RenovacionSome] [date] NULL,
	[BoletaPorLote] [bit] NULL,
	[TarjetaPorcentaje] [decimal](8, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CompaniaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compras](
	[CompraId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[CompraCorrelativo] [varchar](80) NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[CompraRegistro] [datetime] NULL,
	[CompraEmision] [date] NULL,
	[CompraComputo] [date] NULL,
	[TipoCodigo] [char](20) NULL,
	[CompraSerie] [varchar](60) NULL,
	[CompraNumero] [varchar](80) NULL,
	[CompraCondicion] [varchar](60) NULL,
	[CompraMoneda] [varchar](60) NULL,
	[CompraTipoCambio] [decimal](18, 3) NULL,
	[CompraDias] [int] NULL,
	[CompraFechaPago] [date] NULL,
	[CompraUsuario] [varchar](80) NULL,
	[CompraTipoIgv] [varchar](60) NULL,
	[CompraValorVenta] [decimal](18, 2) NULL,
	[CompraDescuento] [decimal](18, 2) NULL,
	[CompraSubtotal] [decimal](18, 2) NULL,
	[CompraIgv] [decimal](18, 2) NULL,
	[CompraTotal] [decimal](18, 2) NULL,
	[CompraEstado] [varchar](60) NULL,
	[CompraAsociado] [varchar](60) NULL,
	[CompraSaldo] [decimal](18, 2) NULL,
	[CompraOBS] [varchar](max) NULL,
	[CompraTipoSunat] [decimal](18, 3) NULL,
	[CompraConcepto] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[CompraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Iso2] [nvarchar](max) NULL,
	[Iso3] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaProveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaProveedor](
	[CuentaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[Entidad] [varchar](80) NULL,
	[TipoCuenta] [varchar](80) NULL,
	[Moneda] [varchar](80) NULL,
	[NroCuenta] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[CuentaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetaLiquidaVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetaLiquidaVenta](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionId] [numeric](38, 0) NULL,
	[DocuId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[SaldoActual] [decimal](18, 2) NULL,
	[FechaPago] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleBloque]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleBloque](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[BloqueId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCompra](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCodigo] [varchar](80) NULL,
	[Descripcion] [varchar](255) NULL,
	[DetalleUM] [varchar](60) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
	[DetalleImporte] [decimal](18, 4) NULL,
	[DetalleDescuento] [decimal](18, 4) NULL,
	[DetalleEstado] [varchar](40) NULL,
	[DescuentoB] [decimal](18, 4) NULL,
	[EstadoB] [char](1) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleDocumento]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleDocumento](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetallPrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleNotaId] [numeric](38, 0) NULL,
	[DetalleUM] [varchar](80) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleGuia](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetalleCosto] [decimal](18, 4) NULL,
	[DetallePrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleEstado] [varchar](60) NULL,
	[IdDetalle] [numeric](38, 0) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[UniMedida] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleIngreso]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleIngreso](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[UniMedida] [varchar](40) NULL,
	[Descripcion] [varchar](max) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleLetra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleLetra](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LetraId] [numeric](38, 0) NULL,
	[LetraCanje] [varchar](80) NULL,
	[LetraDias] [int] NULL,
	[LetraVencimiento] [date] NULL,
	[DetalleSaldo] [decimal](18, 2) NULL,
	[DetalleMonto] [decimal](18, 2) NULL,
	[DetalleEstado] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleLiquida](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionId] [numeric](38, 0) NULL,
	[CompraId] [numeric](38, 0) NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[SaldoActual] [decimal](18, 2) NULL,
	[FechaPago] [varchar](60) NULL,
	[Numero] [varchar](60) NULL,
	[Proveedor] [varchar](255) NULL,
	[Moneda] [varchar](20) NULL,
	[Concepto] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleNube]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleNube](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[ProductoCodigo] [varchar](300) NULL,
	[Descripcion] [varchar](max) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetalleUM] [varchar](80) NULL,
	[DetallPrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallePedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallePedido](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[NotaId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetalleUm] [varchar](40) NULL,
	[DetalleDescripcion] [varchar](140) NULL,
	[DetalleCosto] [decimal](18, 2) NULL,
	[DetallePrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleEstado] [varchar](60) NULL,
	[CantidadSaldo] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[Estado] [nvarchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleStock](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaId] [numeric](38, 0) NULL,
	[IdStock] [numeric](38, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[UniMedida] [varchar](40) NULL,
	[Descripcion] [varchar](max) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[NotaId] [varchar](80) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[ESTADO] [nvarchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleTurnos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleTurnos](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[PersonalId] [numeric](20, 0) NULL,
	[TurnoId] [int] NULL,
	[Dia] [nvarchar](40) NULL,
	[Estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentoCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentoCanje](
	[DocumentoId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LetraId] [numeric](38, 0) NULL,
	[CompraId] [numeric](38, 0) NULL,
	[Documento] [varchar](60) NULL,
	[Moneda] [varchar](60) NULL,
	[Monto] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[DocumentoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentoVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentoVenta](
	[DocuId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[NotaId] [numeric](38, 0) NULL,
	[DocuDocumento] [varchar](60) NULL,
	[DocuNumero] [varchar](60) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[DocuRegistro] [datetime] NULL,
	[DocuEmision] [date] NULL,
	[DocuCondicion] [varchar](60) NULL,
	[DocuDias] [int] NULL,
	[DocuFechaPago] [date] NULL,
	[DocuCancelacion] [varchar](60) NULL,
	[DocuLetras] [varchar](max) NULL,
	[DocuSubTotal] [decimal](18, 2) NULL,
	[DocuIgv] [decimal](18, 2) NULL,
	[DocuTotal] [decimal](18, 2) NULL,
	[DocuSaldo] [decimal](18, 2) NULL,
	[DocuUsuario] [varchar](60) NULL,
	[DocuEstado] [varchar](60) NULL,
	[DocuSerie] [char](4) NULL,
	[TipoCodigo] [char](20) NULL,
	[DocuAdicional] [decimal](18, 2) NULL,
	[DocuAsociado] [varchar](80) NULL,
	[DocuConcepto] [varchar](80) NULL,
	[DocuNroGuia] [varchar](80) NULL,
	[DocuHash] [varchar](250) NULL,
	[EstadoSunat] [varchar](80) NULL,
	[ICBPER] [decimal](18, 2) NULL,
	[CodigoSunat] [varchar](80) NULL,
	[MensajeSunat] [varchar](max) NULL,
	[DocuGravada] [decimal](18, 2) NULL,
	[DocuDescuento] [decimal](18, 2) NULL,
	[EnvioCorreo] [nvarchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[DocuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnvioTrunsk]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnvioTrunsk](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NULL,
	[Usuario] [varchar](80) NULL,
	[FechaEnvio] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FacturasNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FacturasNC](
	[ID] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[AsociadoID] [numeric](38, 0) NULL,
	[Factura] [varchar](80) NULL,
	[Monto] [decimal](18, 2) NULL,
	[Moneda] [varchar](20) NULL,
	[Acuenta] [decimal](18, 2) NULL,
	[Saldo] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feriados]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feriados](
	[IdFeriado] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NULL,
	[Motivo] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdFeriado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GastosFijos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GastosFijos](
	[GastoId] [int] IDENTITY(1,1) NOT NULL,
	[GastoFecha] [date] NULL,
	[GsstoDesc] [varchar](max) NULL,
	[GstoMonto] [decimal](18, 2) NULL,
	[GastoReg] [datetime] NULL,
	[GastoUsuario] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[GastoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaAlmacen](
	[GuiaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaConcepto] [varchar](40) NULL,
	[GuiaMotivo] [varchar](80) NULL,
	[GuiaRegistro] [datetime] NULL,
	[AlmacenId] [numeric](20, 0) NULL,
	[GuiaObservacion] [varchar](max) NULL,
	[GuiaResponsable] [varchar](80) NULL,
	[GuiaUsuario] [varchar](80) NULL,
	[GuiaEstado] [char](1) NULL,
	[NotaId] [varchar](80) NULL,
	[RazonSocial] [varchar](300) NULL,
	[GuiaDoc] [varchar](40) NULL,
	[GuiaDocNumero] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[GuiaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaCanje](
	[CanjeId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[CompaniaId] [int] NULL,
	[CanjeFecha] [date] NULL,
	[CanjeRegistro] [datetime] NULL,
	[CanjeSerie] [varchar](80) NULL,
	[CanjeNumero] [varchar](80) NULL,
	[CanjeEmision] [date] NULL,
	[CanjeComputo] [date] NULL,
	[CanjeCorrelativo] [varchar](80) NULL,
	[CanjeTipo] [varchar](80) NULL,
	[CanjeOBS] [varchar](max) NULL,
	[TCSunat] [decimal](18, 3) NULL,
	[GCompania] [int] NULL,
	[GSerie] [varchar](80) NULL,
	[GNumero] [varchar](80) NULL,
	[GEmision] [date] NULL,
	[GCanjeComputo] [date] NULL,
	[GCanjeCorrelativo] [varchar](80) NULL,
	[GCanjeTipo] [varchar](80) NULL,
	[GCanjeOBS] [varchar](max) NULL,
	[GTCSunat] [decimal](18, 3) NULL,
	[CanjeUsuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[CanjeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaIngreso]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaIngreso](
	[GuiaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaConcepto] [varchar](40) NULL,
	[GuiaMotivo] [varchar](80) NULL,
	[GuiaRegistro] [datetime] NULL,
	[AlmacenId] [numeric](20, 0) NULL,
	[GuiaObservacion] [varchar](max) NULL,
	[GuiaUsuario] [varchar](80) NULL,
	[RazonSocial] [varchar](300) NULL,
	[GuiaDoc] [varchar](40) NULL,
	[GuiaDocNumero] [varchar](80) NULL,
	[Estado] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[GuiaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaRelacion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaRelacion](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaRemision]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaRemision](
	[GuiaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaNumero] [varchar](60) NULL,
	[GuiaMotivo] [varchar](80) NULL,
	[GuiaRegistro] [datetime] NULL,
	[GuiaDestinatario] [varchar](250) NULL,
	[GuiaRucDes] [varchar](60) NULL,
	[GuiaAlmacen] [varchar](80) NULL,
	[GuiaPartida] [varchar](max) NULL,
	[GuiaLLegada] [varchar](max) NULL,
	[GuiaTramsporte] [varchar](80) NULL,
	[GuiaUsuario] [varchar](80) NULL,
	[GuiaTotal] [decimal](18, 2) NULL,
	[GuiaConcepto] [varchar](40) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[GuiaEstado] [varchar](60) NULL,
	[GuiaTelefono] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[GuiaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Images]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Images](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Url] [nvarchar](4000) NULL,
	[ProductId] [int] NOT NULL,
	[PublicCode] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kardex]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kardex](
	[KardexId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[KardexFecha] [datetime] NULL,
	[KardexMotivo] [varchar](60) NULL,
	[KardexDocumento] [varchar](60) NULL,
	[StockInicial] [decimal](18, 2) NULL,
	[CantidadIngreso] [decimal](18, 2) NULL,
	[CantidadSalida] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
	[StockFinal] [decimal](18, 2) NULL,
	[KadexConcepto] [varchar](40) NULL,
	[Usuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[KardexId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KardexAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KardexAlmacen](
	[KardexId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdStock] [numeric](20, 0) NULL,
	[KardexFecha] [datetime] NULL,
	[KardexMotivo] [varchar](60) NULL,
	[KardexDocumento] [varchar](60) NULL,
	[StockInicial] [decimal](18, 2) NULL,
	[CantidadIngreso] [decimal](18, 2) NULL,
	[CantidadSalida] [decimal](18, 2) NULL,
	[StockFinal] [decimal](18, 2) NULL,
	[KadexConcepto] [varchar](40) NULL,
	[Usuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[KardexId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Letra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Letra](
	[LetraId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[LetraFechaReg] [datetime] NULL,
	[LetraFechaGiro] [date] NULL,
	[LetraMoneda] [varchar](40) NULL,
	[LetraSaldo] [decimal](18, 2) NULL,
	[LetraTotal] [decimal](18, 2) NULL,
	[LetraUsuario] [varchar](60) NULL,
	[LetraEstado] [varchar](60) NULL,
	[CompaniaId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LetraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Linea]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Linea](
	[IdLinea] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[NombreLinea] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdLinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Liquidacion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Liquidacion](
	[LiquidacionId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionNumero] [varchar](80) NULL,
	[LiquidacionRegistro] [datetime] NULL,
	[LiquidacionFecha] [date] NULL,
	[LiquidacionDescripcion] [varchar](250) NULL,
	[LiquidacionCambio] [decimal](18, 3) NULL,
	[LiquidaEfectivoSol] [decimal](18, 2) NULL,
	[LiquidaDepositoSol] [decimal](18, 2) NULL,
	[LiquidaTotalSol] [decimal](18, 2) NULL,
	[LiquidaEfectivoDol] [decimal](18, 2) NULL,
	[LiquidaDepositoDol] [decimal](18, 2) NULL,
	[LiquidaTotalDol] [decimal](18, 2) NULL,
	[LiquidaUsuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[LiquidacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LiquidacionVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LiquidacionVenta](
	[LiquidacionId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionNumero] [varchar](80) NULL,
	[LiquidacionRegistro] [datetime] NULL,
	[LiquidacionFecha] [date] NULL,
	[LiquidacionDescripcion] [varchar](250) NULL,
	[LiquidacionCambio] [decimal](18, 3) NULL,
	[LiquidaEfectivoSol] [decimal](18, 2) NULL,
	[LiquidaDepositoSol] [decimal](18, 2) NULL,
	[LiquidaTotalSol] [decimal](18, 2) NULL,
	[LiquidaEfectivoDol] [decimal](18, 2) NULL,
	[LiquidaDepositoDol] [decimal](18, 2) NULL,
	[LiquidaTotalDol] [decimal](18, 2) NULL,
	[LiquidaUsuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[LiquidacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[logCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[logCaja](
	[LogId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[FechaRegistro] [datetime] NULL,
	[CajaId] [varchar](38) NULL,
	[Accion] [varchar](140) NULL,
	[Movimiento] [varchar](140) NULL,
	[Justificacion] [varchar](max) NULL,
	[Monto] [decimal](18, 2) NULL,
	[Cajero] [varchar](80) NULL,
	[Autoriza] [varchar](80) NULL,
	[NotaId] [varchar](38) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MAQUINAS]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAQUINAS](
	[IdMaquina] [int] IDENTITY(1,1) NOT NULL,
	[Maquina] [varchar](140) NULL,
	[Registro] [datetime] NULL,
	[Estado] [char](1) NULL,
	[EstadoC] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMaquina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monedas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monedas](
	[MonedaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ConteoId] [numeric](38, 0) NULL,
	[Efectivo] [int] NULL,
	[Billete] [varchar](80) NULL,
	[Monto] [decimal](18, 2) NULL,
	[Concepto] [char](1) NULL,
	[CajaId] [numeric](38, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[MonedaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MontoMaximo]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MontoMaximo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Monto] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotaPedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotaPedido](
	[NotaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[NotaDocu] [varchar](60) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[NotaFecha] [datetime] NULL,
	[NotaUsuario] [varchar](60) NULL,
	[NotaFormaPago] [varchar](60) NULL,
	[NotaCondicion] [varchar](60) NULL,
	[NotaDias] [int] NULL,
	[NotaFechaPago] [date] NULL,
	[NotaDireccion] [varchar](max) NULL,
	[NotaTelefono] [varchar](250) NULL,
	[NotaSubtotal] [decimal](18, 2) NULL,
	[NotaMovilidad] [decimal](18, 2) NULL,
	[NotaDescuento] [decimal](18, 2) NULL,
	[NotaTotal] [decimal](18, 2) NULL,
	[NotaAcuenta] [decimal](18, 2) NULL,
	[NotaSaldo] [decimal](18, 2) NULL,
	[NotaAdicional] [decimal](18, 2) NULL,
	[NotaTarjeta] [decimal](18, 2) NULL,
	[NotaPagar] [decimal](18, 2) NULL,
	[NotaEstado] [varchar](60) NULL,
	[CompaniaId] [int] NULL,
	[NotaEntrega] [varchar](40) NULL,
	[ModificadoPor] [varchar](60) NULL,
	[FechaEdita] [varchar](60) NULL,
	[NotaConcepto] [varchar](60) NULL,
	[NotaSerie] [varchar](60) NULL,
	[NotaNumero] [varchar](60) NULL,
	[NotaGanancia] [decimal](18, 2) NULL,
	[ICBPER] [decimal](18, 2) NULL,
	[CajaId] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[NotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NubeDocumento]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NubeDocumento](
	[Id] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[CompaniaId] [int] NULL,
	[NotaId] [numeric](38, 0) NULL,
	[Emision] [date] NULL,
	[Documento] [varchar](60) NULL,
	[Numero] [varchar](60) NULL,
	[ClienteRazon] [varchar](max) NULL,
	[ClienteRUC] [varchar](20) NULL,
	[ClienteDNI] [varchar](20) NULL,
	[DireccionFiscal] [varchar](max) NULL,
	[DireccionDespacho] [varchar](max) NULL,
	[Total] [decimal](18, 2) NULL,
	[Usuario] [varchar](60) NULL,
	[Estado] [varchar](60) NULL,
	[FechaEnvio] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderAddresses]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderAddresses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Direccion] [nvarchar](max) NULL,
	[Ciudad] [nvarchar](max) NULL,
	[Departamento] [nvarchar](max) NULL,
	[CodigoPostal] [nvarchar](max) NULL,
	[Username] [nvarchar](max) NULL,
	[Pais] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_OrderAddresses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Precio] [decimal](10, 2) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductItemId] [int] NOT NULL,
	[ProductNombre] [nvarchar](max) NULL,
	[ImagenUrl] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompradorNombre] [nvarchar](max) NULL,
	[CompradorUsername] [nvarchar](max) NULL,
	[OrderAddressId] [int] NULL,
	[Subtotal] [decimal](10, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[Total] [decimal](10, 2) NOT NULL,
	[Impuesto] [decimal](10, 2) NOT NULL,
	[PrecioEnvio] [decimal](10, 2) NOT NULL,
	[PaymentIntentId] [nvarchar](max) NULL,
	[ClientSecret] [nvarchar](max) NULL,
	[StripeApiKey] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personal](
	[PersonalId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[PersonalNombres] [varchar](140) NULL,
	[PersonalApellidos] [varchar](140) NULL,
	[AreaId] [numeric](20, 0) NULL,
	[PersonalCodigo] [varchar](80) NULL,
	[PersonalNacimiento] [date] NULL,
	[PersonalIngreso] [varchar](20) NULL,
	[PersonalDNI] [varchar](20) NULL,
	[PersonalDireccion] [varchar](140) NULL,
	[PersonalTelefono] [varchar](40) NULL,
	[PersonalTelefonoAsi] [varchar](40) NULL,
	[PersonalEmail] [varchar](100) NULL,
	[PersonalSueldo] [decimal](18, 2) NULL,
	[PersonalEstado] [varchar](60) NULL,
	[PersonalBajaFecha] [varchar](60) NULL,
	[PersonalRuc] [varchar](20) NULL,
	[PersonalImagen] [varchar](max) NULL,
	[CompaniaId] [int] NULL,
	[PersonalLicencia] [varchar](80) NULL,
	[HUELLA] [image] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[IdProducto] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[IdSubLinea] [numeric](20, 0) NULL,
	[ProductoCodigo] [varchar](300) NULL,
	[ProductoNombre] [varchar](300) NULL,
	[ProductoMarca] [varchar](80) NULL,
	[ProductoTipoCambio] [decimal](18, 3) NULL,
	[ProductoCostoDolar] [decimal](18, 4) NULL,
	[ProductoUM] [varchar](60) NULL,
	[ProductoCosto] [decimal](18, 4) NULL,
	[ProductoVenta] [decimal](18, 2) NULL,
	[ProductoVentaB] [decimal](18, 2) NULL,
	[AlmacenId] [numeric](20, 0) NULL,
	[ProductoUbicacion] [varchar](80) NULL,
	[ProductoCantidad] [decimal](18, 2) NULL,
	[ProductoEstado] [varchar](60) NULL,
	[ProductoUsuario] [varchar](60) NULL,
	[ProductoFecha] [datetime] NULL,
	[ProductoImagen] [varchar](max) NULL,
	[ValorCritico] [decimal](18, 2) NULL,
	[AplicaTC] [nvarchar](1) NULL,
	[AplicaFB] [nvarchar](1) NULL,
	[AplicaINV] [nvarchar](1) NULL,
	[CantidadANT] [decimal](18, 2) NULL,
	[FechaModCant] [datetime] NULL,
	[MaxCantVen] [decimal](18, 2) NULL,
	[CantidadNB] [decimal](18, 2) NULL,
	[ProductoObs] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductoUnion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductoUnion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[IdProductoB] [numeric](20, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[UM] [varchar](80) NULL,
	[Precio] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[Estado] [nvarchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
	[Precio] [decimal](10, 2) NOT NULL,
	[Descripcion] [nvarchar](4000) NULL,
	[Rating] [int] NOT NULL,
	[Vendedor] [nvarchar](100) NULL,
	[Stock] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedor](
	[ProveedorId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ProveedorRazon] [varchar](250) NULL,
	[ProveedorRuc] [varchar](20) NULL,
	[ProveedorContacto] [varchar](140) NULL,
	[ProveedorCelular] [varchar](140) NULL,
	[ProveedorTelefono] [varchar](140) NULL,
	[ProveedorCorreo] [varchar](140) NULL,
	[ProveedorDireccion] [varchar](140) NULL,
	[ProveedorEstado] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProveedorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RentaMensual]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentaMensual](
	[RentaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[RentaUsuario] [varchar](80) NULL,
	[RentaANNO] [int] NULL,
	[RentaMes] [int] NULL,
	[IGV] [decimal](18, 2) NULL,
	[Renta] [decimal](18, 2) NULL,
	[SaldoIGV] [decimal](18, 2) NULL,
	[SaldoRenta] [decimal](18, 2) NULL,
	[InteresIgv] [decimal](18, 2) NULL,
	[InteresRenta] [decimal](18, 2) NULL,
	[TributoIgv] [decimal](18, 2) NULL,
	[TributoRenta] [decimal](18, 2) NULL,
	[FormaPago] [bit] NULL,
	[FechaCancelacion] [date] NULL,
	[EntidadBancaria] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[PagoTotal] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[RentaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResumenBoletas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResumenBoletas](
	[ResumenId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[ResumenSerie] [varchar](250) NULL,
	[Secuencia] [numeric](38, 0) NULL,
	[FechaReferencia] [date] NULL,
	[FechaEnvio] [datetime] NULL,
	[SubTotal] [decimal](18, 2) NULL,
	[IGV] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[ResumenTiket] [varchar](250) NULL,
	[CodigoSunat] [varchar](80) NULL,
	[HASHCDR] [varchar](max) NULL,
	[MensajeSunat] [varchar](max) NULL,
	[Usuario] [varchar](80) NULL,
	[ESTADO] [char](1) NULL,
	[RangoNumero] [varchar](80) NULL,
	[ICBPER] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ResumenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
	[Rating] [int] NOT NULL,
	[Comentario] [nvarchar](4000) NULL,
	[ProductId] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCartItems]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Producto] [nvarchar](max) NULL,
	[Precio] [decimal](10, 2) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Imagen] [nvarchar](max) NULL,
	[Categoria] [nvarchar](max) NULL,
	[ShoppingCartMasterId] [uniqueidentifier] NULL,
	[ShoppingCartId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Stock] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_ShoppingCartItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCarts]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCarts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShoppingCartMasterId] [uniqueidentifier] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_ShoppingCarts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock](
	[IdStock] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[AlmacenId] [numeric](20, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[Estado] [varchar](40) NULL,
	[Usuario] [varchar](80) NULL,
	[FechaEdicion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdStock] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sublinea]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sublinea](
	[IdSubLinea] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[IdLinea] [numeric](20, 0) NULL,
	[NombreSublinea] [varchar](300) NULL,
	[CodigoSunat] [varchar](40) NULL,
	[ControlAlmacen] [nvarchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubLinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalAlmacen](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NULL,
	[IdStok] [numeric](38, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[UniMedida] [varchar](80) NULL,
	[Concepto] [char](1) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[CanInicial] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalCanje](
	[temporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[temporalCanje] [varchar](80) NULL,
	[temporalDias] [int] NULL,
	[temporalVencimiento] [varchar](20) NULL,
	[temporalMonto] [decimal](18, 2) NULL,
	[usuarioId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[temporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalCompra](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCodigo] [varchar](80) NULL,
	[Descripcion] [varchar](255) NULL,
	[DetalleUM] [varchar](60) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleDescuento] [decimal](18, 4) NULL,
	[DetalleEstado] [varchar](40) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalGuia](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[cantidad] [decimal](18, 2) NULL,
	[precioventa] [decimal](18, 2) NULL,
	[importe] [decimal](18, 2) NULL,
	[Concepto] [varchar](60) NULL,
	[CantidadSaldo] [decimal](18, 2) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[DetalleId] [numeric](38, 0) NULL,
	[DetalleUM] [varchar](40) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalING](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[UniMedida] [varchar](80) NULL,
	[Concepto] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temporalLetra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temporalLetra](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[TemporalDocumento] [varchar](60) NULL,
	[TemporalMoneda] [varchar](20) NULL,
	[TemporalMonto] [decimal](18, 2) NULL,
	[UsuarioId] [int] NULL,
	[TemporalCanje] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalLiquida](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdDeuda] [numeric](38, 0) NULL,
	[Numero] [varchar](60) NULL,
	[Proveedor] [varchar](255) NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[Moneda] [varchar](20) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[TemporalFecha] [varchar](60) NULL,
	[UsuarioId] [int] NULL,
	[Concepto] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalLiVenta](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL,
	[UsuarioId] [int] NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[TemporalFecha] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalServicio]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalServicio](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NULL,
	[TemporalDetalle] [varchar](max) NULL,
	[TemporalUm] [varchar](80) NULL,
	[TemporalCantidad] [decimal](18, 2) NULL,
	[TemporalCosto] [decimal](18, 4) NULL,
	[TemporalDescuento] [decimal](18, 4) NULL,
	[TemporalImporte] [decimal](18, 2) NULL,
	[TemporalEstado] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalVenta](
	[temporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[cantidad] [decimal](18, 2) NULL,
	[precioventa] [decimal](18, 2) NULL,
	[importe] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[UniMedida] [varchar](40) NULL,
	[Estado] [nvarchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoCambio]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCambio](
	[IdTipo] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[TipoFecha] [date] NULL,
	[TipoCompra] [decimal](18, 3) NULL,
	[TipoVenta] [decimal](18, 3) NULL,
	[TipoEmpresa] [decimal](18, 3) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoComprobante]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoComprobante](
	[TipoId] [int] IDENTITY(1,1) NOT NULL,
	[TipoCodigo] [char](20) NULL,
	[TipoDescripcion] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TipoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Turnos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Turnos](
	[TurnoId] [int] IDENTITY(1,1) NOT NULL,
	[Turno] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[TurnoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ubigeo]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ubigeo](
	[UgeoId] [int] IDENTITY(1,1) NOT NULL,
	[IdDepa] [varchar](20) NULL,
	[IdProv] [varchar](20) NULL,
	[IdDist] [varchar](20) NULL,
	[Nombre] [varchar](140) NULL,
PRIMARY KEY CLUSTERED 
(
	[UgeoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadMedida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadMedida](
	[IdUm] [int] IDENTITY(1,1) NOT NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[UMDescripcion] [varchar](80) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[PrecioVenta] [decimal](18, 2) NULL,
	[PrecioVentaB] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[PersonalId] [numeric](20, 0) NULL,
	[UsuarioAlias] [varchar](60) NULL,
	[UsuarioClave] [varbinary](500) NULL,
	[UsuarioFechaReg] [datetime] NULL,
	[UsuarioEstado] [varchar](40) NULL,
	[UsuarioSerie] [varchar](4) NULL,
	[EnviaBoleta] [bit] NULL,
	[EnviarFactura] [bit] NULL,
	[EnviaNC] [bit] NULL,
	[EnviaND] [bit] NULL,
	[Administrador] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 29/04/2026 15:56:22 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 29/04/2026 15:56:22 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_fecha]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_fecha] ON [dbo].[CajaDetalle]
(
	[DetalleFecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_IdGeneral]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_IdGeneral] ON [dbo].[CajaPincipal]
(
	[IdGeneral] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CompraComputo]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_CompraComputo] ON [dbo].[Compras]
(
	[CompraComputo] ASC,
	[CompraEmision] ASC,
	[TipoCodigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Bloque]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_Bloque] ON [dbo].[DetalleBloque]
(
	[NotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DocuEmision]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_DocuEmision] ON [dbo].[DocumentoVenta]
(
	[DocuEmision] ASC,
	[DocuDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Images_ProductId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_Images_ProductId] ON [dbo].[Images]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_NotaUsuario]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_NotaUsuario] ON [dbo].[NotaPedido]
(
	[NotaFecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderItems_OrderId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderId] ON [dbo].[OrderItems]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderItems_ProductId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_OrderItems_ProductId] ON [dbo].[OrderItems]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_OrderAddressId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_Orders_OrderAddressId] ON [dbo].[Orders]
(
	[OrderAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SubLinea]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_SubLinea] ON [dbo].[Producto]
(
	[IdSubLinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Products_CategoryId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_Products_CategoryId] ON [dbo].[Products]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reviews_ProductId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_Reviews_ProductId] ON [dbo].[Reviews]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShoppingCartItems_ShoppingCartId]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItems_ShoppingCartId] ON [dbo].[ShoppingCartItems]
(
	[ShoppingCartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Idproducto]    Script Date: 29/04/2026 15:56:22 ******/
CREATE NONCLUSTERED INDEX [IX_Idproducto] ON [dbo].[UnidadMedida]
(
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[CajaDetalle]  WITH CHECK ADD FOREIGN KEY([CajaId])
REFERENCES [dbo].[Caja] ([CajaId])
GO
ALTER TABLE [dbo].[Compras]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Compras]  WITH CHECK ADD FOREIGN KEY([ProveedorId])
REFERENCES [dbo].[Proveedor] ([ProveedorId])
GO
ALTER TABLE [dbo].[DetaLiquidaVenta]  WITH CHECK ADD FOREIGN KEY([LiquidacionId])
REFERENCES [dbo].[LiquidacionVenta] ([LiquidacionId])
GO
ALTER TABLE [dbo].[DetaLiquidaVenta]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[DetalleBloque]  WITH CHECK ADD FOREIGN KEY([BloqueId])
REFERENCES [dbo].[BLOQUE] ([BloqueId])
GO
ALTER TABLE [dbo].[DetalleCompra]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[DetalleDocumento]  WITH CHECK ADD FOREIGN KEY([DocuId])
REFERENCES [dbo].[DocumentoVenta] ([DocuId])
GO
ALTER TABLE [dbo].[DetalleDocumento]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetalleGuia]  WITH CHECK ADD FOREIGN KEY([GuiaId])
REFERENCES [dbo].[GuiaRemision] ([GuiaId])
GO
ALTER TABLE [dbo].[DetalleGuia]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetalleIngreso]  WITH CHECK ADD FOREIGN KEY([GuiaId])
REFERENCES [dbo].[GuiaIngreso] ([GuiaId])
GO
ALTER TABLE [dbo].[DetalleIngreso]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetalleLetra]  WITH CHECK ADD FOREIGN KEY([LetraId])
REFERENCES [dbo].[Letra] ([LetraId])
GO
ALTER TABLE [dbo].[DetalleLiquida]  WITH CHECK ADD FOREIGN KEY([LiquidacionId])
REFERENCES [dbo].[Liquidacion] ([LiquidacionId])
GO
ALTER TABLE [dbo].[DetallePedido]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetallePedido]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[DetalleStock]  WITH CHECK ADD FOREIGN KEY([GuiaId])
REFERENCES [dbo].[GuiaAlmacen] ([GuiaId])
GO
ALTER TABLE [dbo].[DetalleStock]  WITH CHECK ADD FOREIGN KEY([IdStock])
REFERENCES [dbo].[Stock] ([IdStock])
GO
ALTER TABLE [dbo].[DetalleTurnos]  WITH CHECK ADD FOREIGN KEY([PersonalId])
REFERENCES [dbo].[Personal] ([PersonalId])
GO
ALTER TABLE [dbo].[DetalleTurnos]  WITH CHECK ADD FOREIGN KEY([TurnoId])
REFERENCES [dbo].[Turnos] ([TurnoId])
GO
ALTER TABLE [dbo].[DocumentoCanje]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[DocumentoCanje]  WITH CHECK ADD FOREIGN KEY([LetraId])
REFERENCES [dbo].[Letra] ([LetraId])
GO
ALTER TABLE [dbo].[DocumentoVenta]  WITH CHECK ADD FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO
ALTER TABLE [dbo].[DocumentoVenta]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[DocumentoVenta]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[GuiaCanje]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[Images]  WITH CHECK ADD  CONSTRAINT [FK_Images_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Images] CHECK CONSTRAINT [FK_Images_Products_ProductId]
GO
ALTER TABLE [dbo].[Letra]  WITH CHECK ADD FOREIGN KEY([ProveedorId])
REFERENCES [dbo].[Proveedor] ([ProveedorId])
GO
ALTER TABLE [dbo].[NotaPedido]  WITH CHECK ADD FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO
ALTER TABLE [dbo].[NotaPedido]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders_OrderId]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products_ProductId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId] FOREIGN KEY([OrderAddressId])
REFERENCES [dbo].[OrderAddresses] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId]
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD FOREIGN KEY([AreaId])
REFERENCES [dbo].[Area] ([AreaId])
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD FOREIGN KEY([AlmacenId])
REFERENCES [dbo].[Almacen] ([AlmacenId])
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD FOREIGN KEY([IdSubLinea])
REFERENCES [dbo].[Sublinea] ([IdSubLinea])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories_CategoryId]
GO
ALTER TABLE [dbo].[RentaMensual]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products_ProductId]
GO
ALTER TABLE [dbo].[ShoppingCartItems]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId] FOREIGN KEY([ShoppingCartId])
REFERENCES [dbo].[ShoppingCarts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShoppingCartItems] CHECK CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId]
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD FOREIGN KEY([AlmacenId])
REFERENCES [dbo].[Almacen] ([AlmacenId])
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD FOREIGN KEY([AlmacenId])
REFERENCES [dbo].[Almacen] ([AlmacenId])
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[Sublinea]  WITH CHECK ADD FOREIGN KEY([IdLinea])
REFERENCES [dbo].[Linea] ([IdLinea])
GO
ALTER TABLE [dbo].[TemporalAlmacen]  WITH CHECK ADD FOREIGN KEY([IdStok])
REFERENCES [dbo].[Stock] ([IdStock])
GO
ALTER TABLE [dbo].[TemporalCompra]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalGuia]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalGuia]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[TemporalING]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[temporalLetra]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[temporalLetra]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[TemporalLiVenta]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[TemporalVenta]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalVenta]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([PersonalId])
REFERENCES [dbo].[Personal] ([PersonalId])
GO
/****** Object:  StoredProcedure [dbo].[AcuentaPedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AcuentaPedido]
@NotaId numeric(38)
as
begin
select
'NroCaja|Fecha|Movimiento|Efectivo|Monto|Vuelto|Usuario¬100|140|110|115|115|115|115¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.DetalleFecha,103)+' '+Convert(char(8),c.DetalleFecha,114)+'|'+
c.DetalleMovimiento+'|'+CONVERT(VarChar(50),cast(c.DetalleEfectivo as money ), 1)+'|'+
CONVERT(VarChar(50),cast(c.DetalleMonto as money ), 1)+'|'+
CONVERT(VarChar(50),cast(c.DetalleVuelto as money ), 1)+'|'+c.Usuario
from CajaDetalle c
where c.NotaId=@NotaId
order by DetalleId asc
FOR XML PATH('')),1,1,'')),'~')+'['+
'FechaPago|Liquidacion|Documento|SaldoDocu|Acuenta|SaldoActual|Usuario¬110|125|120|115|115|115|120¬String|String|String|String|String|String|String¬'+
isnull((select stuff((select '¬'+ Convert(char(10),d.FechaPago,103)+'|'+'LQ '+l.LiquidacionNumero+'|'+
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end+'|'+
CONVERT(VarChar(50),cast(d.SaldoDocu as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.SaldoActual as money ), 1)+'|'+l.LiquidaUsuario
from DetaLiquidaVenta d
inner join LiquidacionVenta l
on l.LiquidacionId=d.LiquidacionId
inner join NotaPedido n
on n.NotaId=d.NotaId
where d.NotaId=@NotaId
order by d.DetalleId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[anularDocumento]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[anularDocumento]
@Data varchar(max)
as
declare @pos1 int
declare @pos2 int
declare @pos3 int
declare @DocuId numeric(38),
@NotaId numeric(38),
@DocuUsuario varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = Len(@Data)+1
Set @DocuUsuario=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
begin
IF NOT EXISTS(select * from CajaDetalle where NotaId=@NotaId)
begin
update DocumentoVenta
set DocuEstado='ANULADO',DocuUsuario=@DocuUsuario
where DocuId=@DocuId
update NotaPedido set ModificadoPor=@DocuUsuario,
FechaEdita=(IsNull(convert(varchar,GETDATE(),103),'')+' '+ IsNull(SUBSTRING(convert(varchar,GETDATE(),114),1,8),'')),
NotaEstado='ANULADO' 
where NotaId=@NotaId
select 'true'
end
else
select 'COBRADO'
end
GO
/****** Object:  StoredProcedure [dbo].[ap_insertarCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ap_insertarCanje]
@LetraId  numeric(38),
@CompraId numeric(38),
@Documento varchar(60),
@Moneda varchar(60),
@Monto    varchar(80)
as
begin
insert into DocumentoCanje values(@LetraId,@CompraId,@Documento,@Moneda,@Monto)
end
GO
/****** Object:  StoredProcedure [dbo].[ap_Reimprimir]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ap_Reimprimir] 
@NotaId numeric(38),
@Usuario varchar(60)
as
begin
begin
update DetallePedido
set DetalleEstado='PENDIENTE'
where NotaId=@NotaId
end
begin
update NotaPedido
set NotaDocu='PROFORMA V',NotaEstado='PENDIENTE',
NotaSerie='',NotaNumero='',ModificadoPor=@Usuario
where NotaId=@NotaId
end
end
GO
/****** Object:  StoredProcedure [dbo].[ap_xEntregar]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ap_xEntregar]
as
begin
select 
'Codigo|RazonSocial|Direccion|Telefono¬80|355|80|80¬String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+c.ClienteDespacho+'|'+c.ClienteTelefono
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join cliente c
on c.ClienteId=n.ClienteId
where d.cantidadSaldo>0 and (n.NotaEstado<>'ANULADO' and n.NotaEntrega='POR ENTREGAR')
group by c.ClienteId,c.ClienteRazon,c.ClienteDespacho,c.ClienteTelefono
order by c.ClienteRazon asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[aumentarStockCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[aumentarStockCompra]    
@IdProducto numeric(38),    
@Cantidad decimal(18,2),    
@Costo decimal(18,4),    
@costoDolar decimal(18,4),    
@TipoCambio decimal(18,3),    
@Estado varchar(40),    
@Documento varchar(80),    
@usuario varchar(80)
as    
begin    

declare @IniciaStock decimal(18,2),@stockFinal decimal(18,2)    
set @IniciaStock=(select top 1 p.ProductoCantidad 
from Producto p (nolock)
where p.IdProducto=@IdProducto)    

set @stockFinal=@IniciaStock+@Cantidad
    
Declare @AplicaINV nvarchar(1) 

set @AplicaINV=(select top 1 p.AplicaINV
from Producto p (nolock) 
where p.IdProducto=@IdProducto)  

if(@Estado='BONIFICACION')    
begin    
	update Producto     
	set ProductoCantidad=ProductoCantidad+@Cantidad    
	where IdProducto=@IdProducto and AplicaINV='S'
	
	if(@AplicaINV='S')
	begin
    insert into Kardex values(@IdProducto,GETDATE(),'Ingreso por Compra',@Documento,@IniciaStock,    
	@Cantidad,0,0,@StockFinal,'INGRESO',@Usuario)
	end 
end    
else    
begin  

if(@AplicaINV='S')
begin   
	update Producto     
	set ProductoCantidad=ProductoCantidad+@Cantidad,ProductoCosto=@Costo,    
	ProductoCostoDolar=@costoDolar,ProductoTipoCambio=@TipoCambio    
	where IdProducto=@IdProducto
	
	insert into Kardex values(@IdProducto,GETDATE(),'Ingreso por Compra',@Documento,@IniciaStock,    
	@Cantidad,0,@Costo,@StockFinal,'INGRESO',@Usuario)
end
else
begin
	update Producto     
	set ProductoCosto=@Costo,ProductoCostoDolar=@costoDolar,
	ProductoTipoCambio=@TipoCambio    
	where IdProducto=@IdProducto  
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[aumentaSaldo]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[aumentaSaldo]
@Cantidad decimal(18,2),
@IdDetalle numeric(38)
as
update DetallePedido
set CantidadSaldo=CantidadSaldo+@Cantidad
where DetalleId=@IdDetalle
GO
/****** Object:  StoredProcedure [dbo].[buscaProUnion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscaProUnion]                   
as              
begin              
select               
'IdPro|Categoria|Codigo|Descripcion|Cantidad|Pre_Venta|PedidoYa|Stock|U_Medida|Pre_Costo|ValorUM|ValorCritico|AplicaINV¬100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String¬'+              
isnull((select STUFF((select '¬'+    
convert(varchar,p.IdProducto)+'|'+    
s.NombreSublinea+'|'+              
p.ProductoCodigo+'|'+    
p.ProductoNombre+' '+p.ProductoMarca+'||'+              
CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)+'|'+              
CONVERT(VarChar(50), cast(p.ProductoVentaB as money ), 1)+'|'+              
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1)+'|'+              
p.ProductoUM+'|'+              
convert(varchar,p.ProductoCosto)+'|1|'+              
convert(varchar,p.ValorCritico)+'|'+p.AplicaINV              
FROM Producto p (nolock)              
INNER JOIN Sublinea s (nolock)              
ON p.IdSubLinea =s.IdSubLinea               
where p.ProductoEstado='BUENO'              
order by p.ProductoNombre asc              
FOR XML path ('')),1,1,'')),'~')+'¬'+              
isnull((select STUFF((select '¬'+    
convert(varchar,p.IdProducto)+'|'+              
s.NombreSublinea+'|'+              
p.ProductoCodigo+'|'+    
p.ProductoNombre+'||'+              
CONVERT(VarChar(50), cast(u.PrecioVenta as money ), 1)+'|'+              
CONVERT(VarChar(50), cast(u.PrecioVentaB as money ), 1)+'|'+              
CONVERT(VarChar(50),cast((p.ProductoCantidad/u.ValorUM)as money ), 1)+'|'+              
u.UMDescripcion+'|'+convert(varchar,u.PrecioCosto)+'|'+    
convert(varchar,u.ValorUM)+'|'+    
convert(varchar,p.ValorCritico)+'|'+p.AplicaINV              
from UnidadMedida u (nolock)              
inner join Producto p (nolock)              
on p.IdProducto=u.IdProducto              
INNER JOIN Sublinea s (nolock)              
ON p.IdSubLinea =s.IdSubLinea               
where p.ProductoEstado='BUENO'              
order by p.ProductoNombre asc              
FOR XML path ('')),1,1,'')),'~')              
end
GO
/****** Object:  StoredProcedure [dbo].[buscarProducto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[buscarProducto]         
@Descripcion varchar(250)          
as          
begin          
select top 70 p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,          
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,        
CONVERT(VarChar,cast(p.ProductoCantidad as money ), 1) as ProductoCantidad,           
p.ProductoUM,    
CONVERT(VarChar,cast(p.ProductoVenta as money ), 1)as ProductoVenta,        
CONVERT(VarChar,cast(p.ProductoVentaB as money ), 1)as ProductoVentaB,        
p.ProductoCosto as PrecioCosto,p.ProductoCostoDolar as CostoDolar,p.ProductoTipoCambio as TipoCambio,           
a.AlmacenNombre,p.ProductoUbicacion,''as ProductoObs,p.ProductoEstado,p.ProductoUsuario,'1' as ValorUM,      
p.ProductoImagen,p.ValorCritico,p.MaxCantVen,p.AplicaINV       
FROM Producto p (nolock)          
INNER JOIN Sublinea s (nolock)          
ON p.IdSubLinea =s.IdSubLinea           
INNER JOIN Linea l (nolock)          
ON s.IdLinea =l.IdLinea           
INNER JOIN Almacen a (nolock)          
ON p.AlmacenId =a.AlmacenId          
where (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%')  
and p.ProductoEstado='BUENO' and p.ProductoCantidad>0     
union all(          
select top 70 p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,          
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,      
CONVERT(VarChar,cast((p.ProductoCantidad/u.ValorUM)as money ), 1) as ProductoCantidad,           
u.UMDescripcion,    
CONVERT(VarChar,cast(u.PrecioVenta as money ), 1)as ProductoVenta,      
CONVERT(VarChar,cast(u.PrecioVentaB as money ), 1)as ProductoVentaB,u.PrecioCosto,'0' as CostoDolar,'0' as TipoCambio,           
a.AlmacenNombre,p.ProductoUbicacion,'' as ProductoObs,p.ProductoEstado,p.ProductoUsuario,u.ValorUM,      
p.ProductoImagen,p.ValorCritico,    
CONVERT(varchar,convert(decimal(18,2),(convert(decimal(18,2),(1/u.ValorUM))* p.MaxCantVen)))as MaxCantVen,    
p.AplicaINV       
from UnidadMedida u (nolock)          
inner join Producto p (nolock)          
on p.IdProducto=u.IdProducto          
INNER JOIN Sublinea s (nolock)          
ON p.IdSubLinea =s.IdSubLinea           
INNER JOIN Linea l (nolock)          
ON s.IdLinea =l.IdLinea           
INNER JOIN Almacen a (nolock)          
ON p.AlmacenId =a.AlmacenId          
where (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%')and     
p.ProductoEstado='BUENO' and p.ProductoCantidad>0)          
order by 7 asc          
end
GO
/****** Object:  StoredProcedure [dbo].[buscarProductoB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarProductoB]     
@Descripcion varchar(80)    
as    
begin    
SELECT top 150 p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,    
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,    
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as ProductoCantidad,     
p.ProductoUM,CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)as ProductoVenta,    
CONVERT(VarChar(50), cast(p.ProductoVentaB as money ), 1)as ProductoVentaB,    
p.ProductoCosto,ProductoCostoDolar,ProductoTipoCambio,     
a.AlmacenNombre,p.ProductoUbicacion,    
p.ProductoEstado,p.ProductoUsuario,p.ProductoFecha,p.ProductoImagen,p.ValorCritico,p.AplicaINV    
FROM Producto p (nolock)    
INNER JOIN Sublinea s (nolock)  
ON p.IdSubLinea =s.IdSubLinea     
INNER JOIN Linea l (nolock)    
ON s.IdLinea =l.IdLinea     
INNER JOIN Almacen a (nolock)    
ON p.AlmacenId =a.AlmacenId    
where (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%') and     
p.ProductoEstado='BUENO' AND s.ControlAlmacen<>'F'    
order by 7 asc    
end
GO
/****** Object:  StoredProcedure [dbo].[buscarProductoC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarProductoC]    
@AlmacenId int    
as    
begin    
select    
'Id|Codigo|Descripcion|Cantidad|Precio|Inventario|UM|ValorUM|ValorCritico|Imagen¬100|120|470|120|100|100|120|100|100|100¬String|String|String|String|String|String|String|String|String|String¬'+    
isnull((select STUFF ((select '¬'+    
convert(varchar,p.IdProducto)+'|'+p.ProductoCodigo+'|'+    
p.ProductoNombre+' '+p.ProductoMarca+'|'+''+'|'+    
CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)+'|'+    
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1)+'|'+    
p.ProductoUM+'|'+'1'+'|'+    
convert(varchar,p.ValorCritico)+'|'+    
p.ProductoImagen    
from Producto p (nolock)    
where p.ProductoEstado='BUENO' and p.IdProducto NOT IN (SELECT IdProducto FROM Stock where AlmacenId=@AlmacenId)    
order by p.ProductoCodigo asc    
for xml path('')),1,1,'')),'~') +'¬'+  
isnull((select STUFF ((select '¬'+    
convert(varchar,p.IdProducto)+'|'+p.ProductoCodigo+'|'+    
p.ProductoNombre+' '+p.ProductoMarca+'|'+''+'|'+    
CONVERT(VarChar(50), cast(u.PrecioVenta as money ), 1)+'|'+    
CONVERT(VarChar(50), cast((p.ProductoCantidad/u.ValorUM)as money ), 1)+'|'+    
u.UMDescripcion+'|'+convert(varchar,u.ValorUM)+'|'+    
convert(varchar,p.ValorCritico)+'|'+    
p.ProductoImagen   
from UnidadMedida u (nolock)  
inner join Producto p (nolock)  
on p.IdProducto=u.IdProducto  
where p.ProductoEstado='BUENO' and p.IdProducto NOT IN (SELECT IdProducto FROM Stock where AlmacenId=@AlmacenId)    
order by p.ProductoCodigo asc    
for xml path('')),1,1,'')),'~')   
end
GO
/****** Object:  StoredProcedure [dbo].[buscarProductoPF]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarProductoPF]             
@Descripcion varchar(250)              
as              
begin              
select top 70 p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,              
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,            
CONVERT(VarChar,cast(p.ProductoCantidad as money ), 1) as ProductoCantidad,               
p.ProductoUM,        
CONVERT(VarChar,cast(p.ProductoVenta as money ), 1)as ProductoVenta,            
CONVERT(VarChar,cast(p.ProductoVentaB as money ), 1)as ProductoVentaB,            
p.ProductoCosto as PrecioCosto,p.ProductoCostoDolar as CostoDolar,p.ProductoTipoCambio as TipoCambio,               
a.AlmacenNombre,p.ProductoUbicacion,''as ProductoObs,p.ProductoEstado,p.ProductoUsuario,'1' as ValorUM,          
p.ProductoImagen,p.ValorCritico,p.MaxCantVen,p.AplicaINV           
FROM Producto p (nolock)              
INNER JOIN Sublinea s (nolock)              
ON p.IdSubLinea =s.IdSubLinea               
INNER JOIN Linea l (nolock)              
ON s.IdLinea =l.IdLinea               
INNER JOIN Almacen a (nolock)              
ON p.AlmacenId =a.AlmacenId              
where (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%')      
and p.ProductoEstado='BUENO'--and p.ProductoCantidad>0         
union all(              
select top 70 p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,              
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,          
CONVERT(VarChar,cast((p.ProductoCantidad/u.ValorUM)as money ), 1) as ProductoCantidad,               
u.UMDescripcion,        
CONVERT(VarChar,cast(u.PrecioVenta as money ), 1)as ProductoVenta,          
CONVERT(VarChar,cast(u.PrecioVentaB as money ), 1)as ProductoVentaB,u.PrecioCosto,'0' as CostoDolar,'0' as TipoCambio,               
a.AlmacenNombre,p.ProductoUbicacion,'' as ProductoObs,p.ProductoEstado,p.ProductoUsuario,u.ValorUM,          
p.ProductoImagen,p.ValorCritico,        
CONVERT(varchar,convert(decimal(18,2),(convert(decimal(18,2),(1/u.ValorUM))* p.MaxCantVen)))as MaxCantVen,        
p.AplicaINV           
from UnidadMedida u (nolock)              
inner join Producto p (nolock)              
on p.IdProducto=u.IdProducto              
INNER JOIN Sublinea s (nolock)              
ON p.IdSubLinea =s.IdSubLinea               
INNER JOIN Linea l (nolock)              
ON s.IdLinea =l.IdLinea               
INNER JOIN Almacen a (nolock)              
ON p.AlmacenId =a.AlmacenId              
where (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%')and         
p.ProductoEstado='BUENO')  
--and p.ProductoCantidad>0)              
order by 7 asc              
end
GO
/****** Object:  StoredProcedure [dbo].[buscarSubLinea]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarSubLinea]   
@IdSubLinea numeric(20)  
as  
begin  
select p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,  
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as ProductoCantidad,   
p.ProductoUM,CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)as ProductoVenta,CONVERT(VarChar(50), cast(p.ProductoVentaB as money ), 1)as ProductoVentaB,p.ProductoCosto as PrecioCosto,p.ProductoCostoDolar as CostoDolar,p.ProductoTipoCambio as TipoCambio,   
a.AlmacenNombre,p.ProductoUbicacion,' 'as ProductoObs,p.ProductoEstado,p.ProductoUsuario,'1' as ValorUM,p.ProductoImagen,p.ValorCritico  
FROM Producto p (nolock)  
INNER JOIN Sublinea s (nolock)  
ON p.IdSubLinea =s.IdSubLinea   
INNER JOIN Linea l (nolock)  
ON s.IdLinea =l.IdLinea   
INNER JOIN Almacen a (nolock)  
ON p.AlmacenId =a.AlmacenId  
where p.IdSubLinea=@IdSubLinea  
union all(  
select p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,  
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,CONVERT(VarChar(50), cast((p.ProductoCantidad/u.ValorUM)as money ), 1) as ProductoCantidad,   
u.UMDescripcion,CONVERT(VarChar(50), cast(u.PrecioVenta as money ), 1)as ProductoVenta,CONVERT(VarChar(50), cast(u.PrecioVentaB as money ), 1)as ProductoVentaB,u.PrecioCosto,'0' as CostoDolar,'0' as TipoCambio,   
a.AlmacenNombre,p.ProductoUbicacion,' 'as ProductoObs,p.ProductoEstado,p.ProductoUsuario,u.ValorUM,p.ProductoImagen,p.ValorCritico  
from UnidadMedida u (nolock)  
inner join Producto p (nolock)  
on p.IdProducto=u.IdProducto  
INNER JOIN Sublinea s (nolock)  
ON p.IdSubLinea =s.IdSubLinea   
INNER JOIN Linea l (nolock)  
ON s.IdLinea =l.IdLinea   
INNER JOIN Almacen a (nolock)  
ON p.AlmacenId =a.AlmacenId  
where p.IdSubLinea=@IdSubLinea)  
order by 7 asc  
end
GO
/****** Object:  StoredProcedure [dbo].[buscaValorCritico]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[buscaValorCritico] @Descripcion varchar(80)
as
begin
select top 200 p.IdProducto,p.ProductoCodigo as Codigo,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as Stock,
p.ProductoUM as UM,p.ProductoCosto as Costo,p.ProductoCostoDolar as CostoDolar
from Producto p (nolock)
where p.ProductoNombre+' '+p.ProductoMarca like '%'+@Descripcion+'%' and (p.ProductoCantidad < = p.ValorCritico)
order by 3 asc
end
GO
/****** Object:  StoredProcedure [dbo].[cajaPrincipal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[cajaPrincipal]
as
begin
select
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Referencia|GastoId¬90|100|80|136|212|120|100|100|100¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId 
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Referencia|GastoId¬90|100|80|135|290|125|100|100|100¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId  
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
'Codigo|FechaCierre|Usuario|Ingresos|Salidas|Total¬100|140|150|130|130|130¬String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[canjearGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[canjearGuia] 
@ProveedorId numeric(38)
as
begin
select
'CompraId|FechaEmision|Documento|Moneda|Saldo|Monto|Estado¬100|110|150|90|120|120|150¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.CompraId)+'|'+(Convert(char(10),c.CompraEmision,103))+'|'+
SUBSTRING(t.TipoDescripcion,1,1)+'C '+ c.CompraSerie+'-'+c.CompraNumero+'|'+c.CompraMoneda+'|'+
(convert(varchar(50), CAST(c.CompraSaldo as money), -1))+'|'+
(convert(varchar(50), CAST(c.CompraTotal as money), -1))+'|'+
c.CompraEstado
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.ProveedorId=@ProveedorId and c.TipoCodigo='09'
order by c.CompraEmision desc
for xml path('')),1,1,'')),'~')	
end
GO
/****** Object:  StoredProcedure [dbo].[CanjeFacturaFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CanjeFacturaFecha]
@fechainicio date,
@fechafin date
as
begin
SELECT dbo.GuiaCanje.*, dbo.Compras.CompraMoneda as Moneda,(convert(varchar(50), CAST(dbo.Compras.CompraValorVenta as money), -1))as Total,
(SUBSTRING(dbo.Compras.CompraMoneda,1,1)+'/.  '+(convert(varchar(50), CAST(dbo.Compras.CompraTotal as money), -1)))as Monto,dbo.Proveedor.ProveedorRazon as Proveedor
FROM dbo.GuiaCanje INNER JOIN dbo.Compras ON dbo.GuiaCanje.CompraId = dbo.Compras.CompraId inner join dbo.Proveedor on dbo.Proveedor.ProveedorId=dbo.Compras.ProveedorId 
where (Convert(char(10),dbo.GuiaCanje.CanjeFecha,103) BETWEEN @fechainicio AND @fechafin) 
order by dbo.GuiaCanje.CanjeId desc
end
GO
/****** Object:  StoredProcedure [dbo].[CantidadVendidas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CantidadVendidas] 
@MES INT,
@ANNO INT
as
begin
select 'Id|SubLinea¬0|300¬'+
(select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea
from Sublinea s
for XMl path('')),1,1,''))+'_'+
'Descripcion|Cantidad|UM|Venta|Ganancia¬520|125|100|125|125¬'+
(select STUFF((select '¬'+ p.ProductoNombre+' '+p.ProductoMarca+'|'+
convert(varchar(50),cast(sum(d.DetalleCantidad)as money),1)+'|'+p.ProductoUM+'|'+
convert(varchar(50),cast(SUM(d.DetalleImporte)as money),1)+'|'+
convert(varchar(50),cast(sum((d.DetallePrecio-d.DetalleCosto)* d.DetalleCantidad)as money),1)+'|'+convert(varchar,p.IdSubLinea)
from NotaPedido n
inner join DetallePedido d
on d.NotaId=n.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where n.NotaEstado='CANCELADO' and 
(MONTH(n.NotaFecha)=@MES and year(n.NotaFecha)=@ANNO)
group by p.IdSubLinea,p.IdProducto,p.ProductoNombre,p.ProductoMarca,p.ProductoUM
order by p.IdSubLinea asc,sum(d.DetalleCantidad) desc
for XMl path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[cargaPrincipal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[cargaPrincipal]  
as  
begin  
select  
isnull((select STUFF((select '¬'+ convert(varchar,c.CompaniaId)+'|'+  
c.CompaniaRazonSocial  
from Compania c   
order by c.CompaniaId asc   
FOR XML PATH('')),1,1,'')),'~')+'['+  
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+  
s.NombreSublinea   
from Sublinea s   
where s.NombreSublinea<>''  
order by s.IdSubLinea asc 
FOR XML PATH('')),1,1,'')),'~')+'['+  
isnull((select STUFF((select '¬'+ t.TipoCodigo+'|'+  
t.TipoDescripcion  
from TipoComprobante t  
order by t.TipoCodigo asc  
FOR XML PATH('')),1,1,'')),'~')+'['+  
isnull((select STUFF((select '¬'+ convert(varchar,a.AreaId)+'|'+  
a.AreaNombre   
from Area a  
order by a.AreaNombre asc  
FOR XML PATH('')),1,1,'')),'~')+'['+  
isnull((select STUFF((select '¬'+convert(varchar,count(*))  
from Producto p  
where p.ProductoEstado='BUENO' and p.ProductoCosto>=p.ProductoVenta  
FOR XML PATH('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[ClientesAtendidos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ClientesAtendidos]
@ANNO INT,
@VENDEDOR VARCHAR(40)
as
begin
select MONTH(N.NotaFecha)as Numero,
(DATENAME(month,n.NotaFecha)) as Mes,n.NotaUsuario as Usuario,
COUNT(ClienteId) as Clientes
from NotaPedido n
where YEAR(n.NotaFecha)=@ANNO and (n.NotaUsuario=@VENDEDOR and n.NotaEstado='CANCELADO')
group by MONTH(N.NotaFecha),(DATENAME(month,n.NotaFecha)),n.NotaUsuario
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[comboGuias]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[comboGuias]
@ClienteId numeric(20)
as
begin
Select
(select STUFF((select '¬' +convert(varchar,g.GuiaId)+'|'+g.GuiaNumero
from GuiaRemision g
where (g.ClienteId=@ClienteId and g.GuiaConcepto='SALIDA') and g.guiaEstado=''
order by 1 asc
for xml path('')),1,1,''))+'['+
'IdPro|Cantidad|UM|Descripcion|PrecioUni|Importe|Costo|ValorUM¬0|100|100|410|125|125|0|0¬'+
(select STUFF((select '¬' + convert(varchar,d.IdProducto)+'|'+
CONVERT(VarChar(50),cast(d.DetalleCantidad as money), 1)+'|'+d.UniMedida+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+ 
CONVERT(varchar,d.ValorUM)+'|'+
convert(varchar,d.GuiaId)
from GuiaRemision g
inner join DetalleGuia d
on d.GuiaId=g.GuiaId
inner join Producto p
on p.IdProducto=d.IdProducto
where g.clienteId=@ClienteId and g.guiaEstado=''
order by d.DetalleId asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[CorrelativoCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CorrelativoCompra]
@CompaniaId int,
@anno int,
@mes int
as
begin
Declare @UltimoNumero numeric(38)
Declare @NuevoNumero numeric(38)
set @UltimoNumero=(select top 1 isnull(substring(CompraCorrelativo,9,len(CompraCorrelativo)),0) as Correlativo 
from Compras
where CompaniaId=@CompaniaId and (year(CompraComputo)=@anno and MONTH(CompraComputo)=@mes)
order by CompraId desc)
set @NuevoNumero=(select top 1 count(c.CompraCorrelativo) as Correlativo
from Compras c
where CompaniaId=@CompaniaId and (year(CompraComputo)=@anno and MONTH(CompraComputo)=@mes))
if(@NuevoNumero=0)
begin
set @NuevoNumero=1
select convert(varchar,@NuevoNumero) as Correlativo
end
else
begin
if(@NuevoNumero=@UltimoNumero)
begin
set @NuevoNumero=@NuevoNumero+1
select convert(varchar,@NuevoNumero) as Correlativo
end 
else
begin
select convert(varchar,@NuevoNumero) as Correlativo
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[CorrelativoLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CorrelativoLiquida]
as
begin
declare @cod varchar(12)
select @cod=dbo.geneneraIdLiquida('001-')
SELECT TOP 1 @cod  AS ID FROM Liquidacion
end
GO
/****** Object:  StoredProcedure [dbo].[CorrelativoLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CorrelativoLiVenta]
as
begin
declare @cod varchar(12)
select @cod=dbo.geneneraIdLiVenta('001-')
SELECT TOP 1 @cod  AS ID FROM LiquidacionVenta
end
GO
/****** Object:  StoredProcedure [dbo].[correlativoNroFactura]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[correlativoNroFactura]@dato varchar(20),@CompaniaId int,@DocuDocumento varchar(40)
as
begin
declare @cod varchar(13)
select @cod=dbo.genenerarNroFactura(@dato,@CompaniaId,@DocuDocumento)
SELECT TOP 1 @cod  AS ID FROM DocumentoVenta
end
GO
/****** Object:  StoredProcedure [dbo].[correlativoNroGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[correlativoNroGuia] @dato varchar(20)
as
begin
declare @cod varchar(11)
select @cod=dbo.genenerarNroGuia(@dato)
SELECT TOP 1 @cod  AS ID FROM GuiaRemision
end
GO
/****** Object:  StoredProcedure [dbo].[CuentaCorrienteCliente]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CuentaCorrienteCliente]  
as  
begin  
select  
'ClienteId|Cliente|SaldoSol¬100|525|140¬String|String|String¬'+  
isnull((select stuff((select '¬'+ convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+  
CONVERT(VarChar(50), cast(sum(n.NotaSaldo)as money ), 1)  
from NotaPedido n  
inner join Cliente c  
on c.ClienteId=n.ClienteId  
where n.NotaEstado<>'ANULADO' and (n.NotaSaldo>0 and n.NotaEstado<>'CANCELADO') and n.NotaCondicion='CREDITO'  
group by c.ClienteId,c.ClienteRazon  
order by c.ClienteRazon asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[CuentaCorrienteProCom]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CuentaCorrienteProCom] 
@CompaniaId varchar(40)
as
begin
select isnull(SC.ProveedorId,ISNULL(DC.ProveedorId,ISNULL(LS.ProveedorId,LD.ProveedorId))) as ProveedorId
,isnull(SC.RazonSocial,ISNULL(DC.RazonSocial,ISNULL(LS.RazonSocial,LD.RazonSocial))) as ProveedorRazon,
convert(varchar(50),cast((isnull(Sum(DC.SaldoDol),0)+ isnull(sum(LD.SaldoDolLe),0))as money),1)as SaldoDol,
convert(varchar(50),cast((isnull(Sum(SC.SaldoSol),0)+ isnull(sum(LS.SaldoSolLe),0))as money),1)as SaldoSol
from
(
    select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoSol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompaniaId=@CompaniaId and (c.CompraMoneda='SOLES' and c.CompraEstado='PENDIENTE DE PAGO')
	group by p.ProveedorId,p.ProveedorRazon
) SC
full join(
  select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoDol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompaniaId=@CompaniaId and (c.CompraMoneda='DOLARES' and c.CompraEstado='PENDIENTE DE PAGO')
	group by p.ProveedorId,p.ProveedorRazon
)DC ON SC.ProveedorId=DC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoSolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.CompaniaId=@CompaniaId and(l.LetraMoneda='SOLES' and d.DetalleEstado='PENDIENTE')
group by p.ProveedorId,p.ProveedorRazon
)LS ON LS.ProveedorId=SC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoDolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.CompaniaId=@CompaniaId and (l.LetraMoneda='DOLARES' and d.DetalleEstado='PENDIENTE')
group by p.ProveedorId,p.ProveedorRazon
)LD ON LS.ProveedorId=LD.ProveedorId
GROUP BY SC.ProveedorId,DC.ProveedorId,LS.ProveedorId,LD.ProveedorId,
		 SC.RazonSocial,DC.RazonSocial,LS.RazonSocial,LD.RazonSocial
order by 2 asc
end
GO
/****** Object:  StoredProcedure [dbo].[CuentaCorrienteProveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CuentaCorrienteProveedor]
as
begin
select isnull(SC.ProveedorId,ISNULL(DC.ProveedorId,ISNULL(LS.ProveedorId,LD.ProveedorId))) as ProveedorId
,isnull(SC.RazonSocial,ISNULL(DC.RazonSocial,ISNULL(LS.RazonSocial,LD.RazonSocial))) as ProveedorRazon,
convert(varchar(50),cast((isnull(Sum(DC.SaldoDol),0)+ isnull(sum(LD.SaldoDolLe),0))as money),1)as SaldoDol,
convert(varchar(50),cast((isnull(Sum(SC.SaldoSol),0)+ isnull(sum(LS.SaldoSolLe),0))as money),1)as SaldoSol
from
(
    select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoSol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompraMoneda='SOLES' and c.CompraEstado='PENDIENTE DE PAGO'
	group by p.ProveedorId,p.ProveedorRazon
) SC
full join(
  select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoDol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompraMoneda='DOLARES' and c.CompraEstado='PENDIENTE DE PAGO'
	group by p.ProveedorId,p.ProveedorRazon
)DC ON SC.ProveedorId=DC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoSolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.LetraMoneda='SOLES' and d.DetalleEstado='PENDIENTE'
group by p.ProveedorId,p.ProveedorRazon
)LS ON LS.ProveedorId=SC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoDolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.LetraMoneda='DOLARES' and d.DetalleEstado='PENDIENTE'
group by p.ProveedorId,p.ProveedorRazon
)LD ON LS.ProveedorId=LD.ProveedorId
GROUP BY SC.ProveedorId,DC.ProveedorId,LS.ProveedorId,LD.ProveedorId,
		 SC.RazonSocial,DC.RazonSocial,LS.RazonSocial,LD.RazonSocial
order by 2 asc
end
GO
/****** Object:  StoredProcedure [dbo].[CuentasCorreienteCompania]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CuentasCorreienteCompania]
as
begin
select 
isnull(SC.CompaniaId,ISNULL(DC.CompaniaId,ISNULL(LS.CompaniaId,LD.CompaniaId))) as CompaniaId
,isnull(SC.RazonSocial,ISNULL(DC.RazonSocial,ISNULL(LS.RazonSocial,LD.RazonSocial))) as RazonSocial,
convert(varchar(50),cast((isnull(Sum(DC.SaldoDol),0)+ isnull(sum(LD.SaldoDolLe),0))as money),1)as SaldoDol,
convert(varchar(50),cast((isnull(Sum(SC.SaldoSol),0)+ isnull(sum(LS.SaldoSolLe),0))as money),1)as SaldoSol
from
(
select co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,
sum(c.CompraSaldo)SaldoSol
from Compania co
inner join Compras c
on c.CompaniaId=co.CompaniaId
where c.CompraMoneda='SOLES' AND c.CompraEstado='PENDIENTE DE PAGO'
group by co.CompaniaId,co.CompaniaRazonSocial
) SC
FULL JOIN 
(
select co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,
sum(c.CompraSaldo)as SaldoDol
from Compania co
inner join Compras c
on c.CompaniaId=co.CompaniaId
where c.CompraMoneda='DOLARES' AND c.CompraEstado='PENDIENTE DE PAGO'
group by co.CompaniaId,co.CompaniaRazonSocial
)DC ON DC.CompaniaId=SC.CompaniaId
full join
(
select l.CompaniaId,co.CompaniaRazonSocial as RazonSocial,SUM(d.DetalleSaldo) as SaldoSolLe
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Compania co
on co.CompaniaId=l.CompaniaId
where d.DetalleEstado='PENDIENTE' and l.LetraMoneda='SOLES'
group by l.CompaniaId,co.CompaniaRazonSocial
)LS on LS.CompaniaId=SC.CompaniaId
full join(
select l.CompaniaId,co.CompaniaRazonSocial as RazonSocial,SUM(d.DetalleSaldo) as SaldoDolLe
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Compania co
on co.CompaniaId=l.CompaniaId
where d.DetalleEstado='PENDIENTE' and l.LetraMoneda='DOLARES'
group by l.CompaniaId,co.CompaniaRazonSocial
)LD on LD.CompaniaId=LS.CompaniaId
GROUP BY SC.CompaniaId,DC.CompaniaId,LS.CompaniaId,LD.CompaniaId,
		 SC.RazonSocial,DC.RazonSocial,LS.RazonSocial,LD.RazonSocial
order by 2 asc
end
GO
/****** Object:  StoredProcedure [dbo].[DeudaCliente]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeudaCliente] @Cliente numeric(20)
as
begin
select
'ClienteId|FechaEmision|Documento|Vencimiento|Moneda|SaldoDocu|MontoDocu¬100|105|140|105|90|120|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,n.ClienteId)+'|'+(Convert(char(10),n.NotaFecha,103))+'|'+
substring(n.NotaDocu,1,2)+' '+cast(n.NotaId as varchar(80))+'|'+
(Convert(char(10),n.NotaFechaPago,103))+'|'+'SOLES'+'|'+convert(varchar(50),cast(n.NotaSaldo as money),1)+'|'+
convert(varchar(50),cast(n.NotaPagar as money),1) 
from NotaPedido n
where n.notadocu<>'PROFORMA' and (n.ClienteId=@Cliente and ((n.NotaSaldo>0 and n.NotaEstado<>'CANCELADO') and n.NotaCondicion='CREDITO'))
order by n.NotaId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[DeudasProveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeudasProveedor] @ProveedorId numeric(38)
as
begin
select c.ProveedorId,c.CompraId,
(Convert(char(10),c.CompraEmision,103)) as CompraEmision,
substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Documento,
(Convert(char(10),c.CompraFechaPago,103)) as Vencimiento,
c.CompraMoneda as Moneda,
c.CompraTipoCambio as TipoCambio,
convert(varchar(50),cast(c.CompraSaldo as money),1) as SaldoDoc,
convert(varchar(50),cast(c.CompraTotal as money),1) as MontoDoc
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.ProveedorId=@ProveedorId and c.CompraEstado='PENDIENTE DE PAGO'
union all
select l.ProveedorId,d.LetraId,(Convert(char(10),l.LetraFechaGiro,103))as LetraFechaGiro,
'LT '+d.LetraCanje as Documento,(Convert(char(10),d.LetraVencimiento,103))as LetraVencimiento,
l.LetraMoneda,'3.276' as TipoCambio,
convert(varchar(50),cast(d.DetalleSaldo as money),1) as DetalleSaldo,
convert(varchar(50),cast(d.DetalleMonto as money),1) as DetalleMonto
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
where l.ProveedorId=@ProveedorId and d.DetalleEstado='PENDIENTE'
end
GO
/****** Object:  StoredProcedure [dbo].[DeudasProveedorA]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeudasProveedorA]
as
begin
select c.CompraId,(Convert(char(10),c.CompraEmision,103)) as CompraEmision,substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Documento,
(Convert(char(10),c.CompraFechaPago,103)) as Vencimiento,c.CompraMoneda as Moneda,c.CompraTipoCambio as TipoCambio,
CONVERT(VarChar(50),cast(c.CompraSaldo as money ), 1) as SaldoDoc,CONVERT(VarChar(50),cast(c.CompraTotal as money ), 1) as MontoDoc
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.CompraEstado='PENDIENTE DE PAGO'
order by c.CompraFechaPago asc
end
GO
/****** Object:  StoredProcedure [dbo].[DeudasProveedorC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeudasProveedorC] 
@CompaniaId varchar(40),
@ProveedorId numeric(38)
as
begin
select c.ProveedorId,c.CompraId,
(Convert(char(10),c.CompraEmision,103)) as CompraEmision,
substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Documento,
(Convert(char(10),c.CompraFechaPago,103)) as Vencimiento,
c.CompraMoneda as Moneda,
c.CompraTipoCambio as TipoCambio,
convert(varchar(50),cast(c.CompraSaldo as money),1) as SaldoDoc,
convert(varchar(50),cast(c.CompraTotal as money),1) as MontoDoc
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.CompaniaId=@CompaniaId and c.ProveedorId=@ProveedorId) and c.CompraEstado='PENDIENTE DE PAGO'
union all
select l.ProveedorId,d.LetraId,(Convert(char(10),l.LetraFechaGiro,103))as LetraFechaGiro,
'LT '+d.LetraCanje as Documento,(Convert(char(10),d.LetraVencimiento,103))as LetraVencimiento,
l.LetraMoneda,'3.276' as TipoCambio,
convert(varchar(50),cast(d.DetalleSaldo as money),1) as DetalleSaldo,
convert(varchar(50),cast(d.DetalleMonto as money),1) as DetalleMonto
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
where (l.CompaniaId=@CompaniaId and l.ProveedorId=@ProveedorId) and d.DetalleEstado='PENDIENTE'
end
GO
/****** Object:  StoredProcedure [dbo].[editaDescontinuado]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDescontinuado]
@Data varchar(max)
as
Set @Data =LTRIM(RTrim(@Data))
	Declare @pos1 int
	declare @IdProducto numeric(20)
Set @pos1 = Len(@Data)+1
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,1,@pos1-1))
begin
	update Producto
	set ProductoEstado='BUENO'
	where IdProducto=@IdProducto
	select isnull((select STUFF((select '¬'+convert(varchar,p.IdProducto)+'|'+p.ProductoCodigo+'|'+
	p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+ 
	p.ProductoUM+'|'+convert(varchar(50),cast(p.ProductoVenta as money),1)+'|'+
	convert(varchar(50),cast(p.ProductoVentaB as money),1)+'|'+convert(varchar,p.ProductoCosto)+'|'+
	convert(varchar,ProductoCostoDolar)+'|'+convert(varchar,ProductoTipoCambio)+'|'+
	p.ProductoEstado+'|'+p.ProductoUsuario+'|'+p.ProductoImagen
	FROM Producto p with(nolock)
	where p.ProductoEstado='DESCONTINUADO'
	order by p.ProductoNombre+' '+p.ProductoMarca asc
	for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[editaDescontinuadoStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDescontinuadoStock]  
@Data varchar(max)  
as
Declare @pos1 int    
Set @Data =LTRIM(RTrim(@Data))  
declare @IdStock numeric(20)  
Set @pos1 = Len(@Data)+1  
Set @IdStock=convert(numeric(20),SUBSTRING(@Data,1,@pos1-1))  
begin  
 update Stock  
 set Estado='BUENO'  
 where IdStock=@IdStock  
	select
	isnull((select STUFF((select '¬'+convert(varchar,s.IdStock)+'|'+p.ProductoCodigo+'|'+  
	p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+   
	p.ProductoUM+'|'+s.Estado+'|'+s.Usuario+'|'+p.ProductoImagen  
	FROM Producto p with(nolock)
	inner join Stock s
	on s.IdProducto=p.IdProducto  
	where s.Estado='DESCONTINUADO'  
	order by p.ProductoNombre+' '+p.ProductoMarca asc  
	for xml path('')),1,1,'')),'~') 
end
GO
/****** Object:  StoredProcedure [dbo].[editaDetaCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDetaCompra]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
declare @Id numeric(38),
@cantidad decimal(18,2),
@precioCosto decimal(18,4),
@Descuento decimal(18,4),
@importe decimal(18,2),
@CompraId numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @Id =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @precioCosto=convert(decimal(18,4),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @Descuento=convert(decimal(18,4),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5= CharIndex('|',@Data,@pos4+1)
Set @importe=convert(decimal(18,4),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =Len(@Data)+1
Set @CompraId=convert(numeric(38),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
update DetalleCompra
set DetalleCantidad=@cantidad,PrecioCosto=@precioCosto,
DetalleDescuento=@Descuento,DetalleImporte=@importe
where DetalleId=@Id
select isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,d.PrecioCosto)
from UnidadMedida u
inner join DetalleCompra d
on d.IdProducto=u.IdProducto
where d.CompraId=@CompraId
order by u.ValorUM asc
for xml path('')),1,1,'')),'true')
end
GO
/****** Object:  StoredProcedure [dbo].[editaDetaLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDetaLiVenta]
@DetalleId numeric(38),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@FechaPago varchar(60)
as
begin
update DetaLiquidaVenta
set EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,FechaPago=@FechaPago
where DetalleId=@DetalleId
end
GO
/****** Object:  StoredProcedure [dbo].[editaDetalleNota]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDetalleNota]
@DetalleId numeric(38),
@IdProducto numeric(20),
@DetalleCantidad decimal(18,2),
@DetalleUM varchar(80),
@DetalleCosto decimal(18,2), 
@DetallePrecio decimal(18,2),
@DetalleImporte decimal(18,2),
@CantidadSaldo decimal(18,2),
@DetalleEstado varchar(60),
@DocuId numeric(38),
@ValorUM decimal(18,4)
as
begin
declare @guias int
set @guias=(select COUNT(d.IdDetalle)from DetalleGuia d where d.IdDetalle=@DetalleId)
begin
update DetallePedido
set DetalleCantidad=@DetalleCantidad,DetalleCosto=@DetalleCosto,
DetallePrecio=@DetallePrecio,DetalleImporte=@DetalleImporte,DetalleEstado=@DetalleEstado
where DetalleId=@DetalleId
if(@guias<=0)
begin
update DetallePedido
set CantidadSaldo=@CantidadSaldo
where DetalleId=@DetalleId
end
end
if(@DocuId<>'0')
begin
insert into DetalleDocumento values
(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,
@DetalleImporte,@DetalleId,@DetalleUM,@ValorUM)
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaGuiacanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaGuiacanje]
@CanjeId numeric(38),
@CompraId numeric(38),
@CompaniaId int,
@CanjeFecha date,
@CanjeRegistro datetime,
@CanjeSerie varchar(80),
@CanjeNumero varchar(80),
@CanjeEmision date,
@CanjeComputo date,
@CanjeCorrelativo varchar(80),
@CanjeTipo varchar(80),
@CanjeOBS varchar(max),
@TCSunat decimal(18,3),
@Usuario varchar(80),
@Subtotal decimal(18,2),
@Igv decimal(18,2),
@Total decimal(18,2)
as
begin
update GuiaCanje
set CompaniaId=@CompaniaId,CanjeFecha=@CanjeFecha,CanjeRegistro=@CanjeRegistro,
CanjeSerie=@CanjeSerie,CanjeNumero=@CanjeNumero,CanjeEmision=@CanjeEmision,CanjeComputo=@CanjeComputo,
CanjeCorrelativo=@CanjeCorrelativo,CanjeTipo=@CanjeTipo,CanjeOBS=@CanjeOBS,TCSunat=@TCSunat,CanjeUsuario=@Usuario
where CanjeId=@CanjeId
begin
update Compras
set CompaniaId=@CompaniaId,CompraSerie=@CanjeSerie,CompraNumero=@CanjeNumero,CompraEmision=@CanjeEmision,
CompraComputo=@CanjeComputo,CompraCorrelativo=@CanjeCorrelativo,CompraTipoIgv=@CanjeTipo,CompraOBS=@CanjeOBS,
CompraTipoSunat=@TCSunat,CompraUsuario=@Usuario,CompraSubtotal=@Subtotal,CompraIgv=@Igv,CompraTotal=@Total
where CompraId=@CompraId
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaNotaLD]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaNotaLD]  
@Data varchar(max)  
as  
begin  
declare @p0 int,@p1 int,  
  @p2 int,@p3 int,  
  @p4 int,@p5 int,  
  @p6 int,@p7 int,  
  @p8 int  
declare @DetalleId numeric(38),  
  @Cantidad decimal(18,2),  
  @Costo decimal(18,2),  
  @PrecioUni decimal(18,2),  
  @Importe decimal(18,2),  
  @Ganancia decimal(18,2),  
  @UM varchar(80),  
  @IdProducto numeric(20)     
Declare @NotaId numeric(38),  
        @Aviso varchar(max),  
        @Stock decimal(18,2),  
        @Existe int,@Condicion varchar(1)  
Set @Data= LTRIM(RTrim(@Data))  
set @p0 = CharIndex('|',@Data,0)  
Set @p1 = CharIndex('|',@Data,@p0+1)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = CharIndex('|',@Data,@p3+1)  
Set @p5= CharIndex('|',@Data,@p4+1)  
Set @p6= CharIndex('|',@Data,@p5+1)  
Set @p7= CharIndex('|',@Data,@p6+1)  
Set @p8=Len(@Data)+1  
  
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Data,1,@p0-1))  
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Data,@p0+1,@p1-(@p0+1)))  
Set @Costo= Convert(decimal(18,2),SUBSTRING(@Data,@p1+1,@p2-(@p1+1)))  
Set @PrecioUni= Convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-(@p2+1)))  
Set @Importe= Convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-(@p3+1)))  
Set @Ganancia= Convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))  
Set @UM=SUBSTRING(@Data,@p5+1,@p6-@p5-1)  
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Data,@p6+1,@p7-@p6-1))  
Set @Condicion=SUBSTRING(@Data,@p7+1,@p8-@p7-1)  
  
  
set @NotaId=(select NotaId from DetallePedido where DetalleId=@DetalleId)  
  
if(@Condicion='B')  
begin  
    update DetallePedido   
 set DetalleCantidad=@Cantidad,DetalleCosto=@Costo,  
 DetallePrecio=@PrecioUni,DetalleImporte=@Importe   
 where DetalleId=@DetalleId  
 update NotaPedido  
 set NotaGanancia=@Ganancia  
 where NotaId=@NotaId  
 select 'true'  
end  
  
else  
begin  
  
set @Aviso=isnull((select top 1 convert(varchar,p.ProductoCantidad)   
from Producto p   
where p.IdProducto=@IdProducto and p.ProductoUM=@UM),'false')  
  
if(@Aviso='false')  
begin  
  
set @Stock=isnull((select top 1 cast((p.ProductoCantidad/u.ValorUM) as decimal(18,2))   
from Producto p  
inner join UnidadMedida u  
on p.IdProducto=u.IdProducto  
where p.IdProducto=@IdProducto and u.UMDescripcion=@UM),0)  
  
end  
else  
begin  
  
set @Stock=@Aviso  
  
end  
if(@Cantidad>@Stock)  
begin  
select CONVERT(varchar,@Stock)  
end  
else  
begin  
  
    update DetallePedido   
 set DetalleCantidad=@Cantidad,DetalleCosto=@Costo,  
 DetallePrecio=@PrecioUni,DetalleImporte=@Importe   
 where DetalleId=@DetalleId  
 update NotaPedido  
 set NotaGanancia=@Ganancia  
 where NotaId=@NotaId  
 select 'true'  
  
end  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[editaPrecioB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaPrecioB] 
@IdTabla numeric(38),
@IdProducto numeric(20),
@Aviso varchar(20),
@Accion varchar(20),
@UM varchar(80),
@valor decimal(18,4)
as
begin
declare @productoventaA decimal(18,2)
declare @productoventaB decimal(18,2)
if(@valor=1)
begin
set @productoventaA=(select top 1 p.ProductoVenta from Producto p where p.IdProducto=@IdProducto)
set @productoventaB=(select top 1 p.ProductoVentaB from Producto p where p.IdProducto=@IdProducto)
end
else
begin
set @productoventaA=isnull((select top 1 u.PrecioVenta from UnidadMedida u where u.IdProducto=@IdProducto and u.UMDescripcion=@UM),0)
set @productoventaB=isnull((select top 1 u.PrecioVentaB from UnidadMedida u where u.IdProducto=@IdProducto and u.UMDescripcion=@UM),0)
end
if(@Accion='T')
begin
if @Aviso='B'
begin
update TemporalVenta
set precioventa=@productoventaB,importe=cantidad*@productoventaB
where temporalId=@IdTabla
end
else
begin
update TemporalVenta
set precioventa=@productoventaA,importe=cantidad*@productoventaA
where temporalId=@IdTabla
end
end
else
begin
if @Aviso='B'
begin
update DetallePedido
set DetallePrecio=@productoventaB,DetalleImporte=DetalleCantidad*@productoventaB
where DetalleId=@IdTabla
end
else
begin
update DetallePedido
set DetallePrecio=@productoventaA,DetalleImporte=DetalleCantidad*@productoventaA
where DetalleId=@IdTabla
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaProductoCosto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaProductoCosto] 
@IdProducto numeric(38),
@Costo decimal(18,4),
@costoDolar decimal(18,4),
@TipoCambio decimal(18,3),
@Estado varchar(40),
@Condicion varchar(60),
@DescuentoB decimal(18,4),
@DetalleId numeric(38)
as
begin
if(@Estado<>'BONIFICACION')
begin
update Producto 
set ProductoCosto=@Costo,ProductoCostoDolar=@costoDolar,ProductoTipoCambio=@TipoCambio
where IdProducto=@IdProducto 
if (@Condicion='NOTA CREDITO')
begin
update DetalleCompra
set DescuentoB=@DescuentoB
where DetalleId=@DetalleId
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaprueba]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[editaprueba]
@ListaOrden varchar(Max)
as
begin
Declare @detalle varchar(max)
Set @detalle =@ListaOrden
Declare @count int
set @count=0;
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @Id numeric(38)
	    declare @Codigo varchar(140)
		Declare @p1 int
		declare @p2 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @p1 = CharIndex('|',@Columna,0)
		Set @p2 =Len(@Columna)+1
        Set @Id=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
		Set @Codigo=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
        SET @count=@count+1
        update Producto
        set ProductoCodigo='MR00'+CONVERT(VARCHAR,@count)
        where IdProducto=@Id
Fetch Next From Tabla INTO @Columna
End
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[editapruebaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editapruebaB]
@ListaOrden varchar(Max)
as
begin
Declare @detalle varchar(max)
Set @detalle =@ListaOrden
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @DetalleId numeric(38)
	    declare @UM varchar(40)
		Declare @p1 int
		declare @p2 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @p1 = CharIndex('|',@Columna,0)
		Set @p2 =Len(@Columna)+1
        Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
		Set @UM=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
		update DetalleGuia
		set UniMedida=@UM
		where DetalleId=@DetalleId
Fetch Next From Tabla INTO @Columna
End
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[editarCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCanje]
@temporalId numeric(38),
@temporalCanje varchar(80),
@temporalDias int,
@temporalVencimiento varchar(20),
@temporalMonto decimal(18,2)
as
begin
update TemporalCanje
set temporalCanje=@temporalCanje,temporalDias=@temporalDias,
temporalVencimiento=@temporalVencimiento,temporalMonto=@temporalMonto
where temporalId=@temporalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarCompania]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCompania]
@CompaniaId int,
@CompaniaRazonSocial varchar(140),
@CompaniaRUC varchar(20),
@CompaniaDireccion varchar(max),
@CompaniaTelefono varchar(80),
@CompaniaEmail varchar(100),
@CompaniaIniFecha varchar(100)
as
begin
update Compania
set CompaniaRazonSocial=@CompaniaRazonSocial,
CompaniaRUC=@CompaniaRUC,CompaniaDireccion=@CompaniaDireccion,
CompaniaTelefono=@CompaniaTelefono,CompaniaEmail=@CompaniaEmail,
CompaniaIniFecha=@CompaniaIniFecha
where CompaniaId=@CompaniaId
end
GO
/****** Object:  StoredProcedure [dbo].[editarCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCompra]
@CompraId numeric(38),
@CompaniaId int,
@CompraCorrelativo varchar(80),
@ProveedorId numeric(38),
@CompraEmision date,
@CompraComputo date,
@TipoCodigo char(20),
@CompraSerie varchar(60),
@CompraNumero varchar(80),
@CompraCondicion varchar(60),
@CompraMoneda varchar(60),
@CompraTipoCambio decimal(18,3),
@CompraDias int,
@CompraFechaPago date,
@CompraUsuario varchar(80),
@CompraTipoIgv varchar(60),
@CompraValorVenta decimal(18,2),
@CompraDescuento decimal(18,2),
@CompraSubtotal decimal(18,2),
@CompraIgv decimal(18,2),
@CompraTotal decimal(18,2),
@CompraEstado varchar(60),
@CompraAsociado varchar(60),
@compraSaldo decimal(18,2),
@CompraOBS varchar(max),
@CompraTipoSunat decimal(18,3)
as 
begin
update Compras
set CompaniaId=@CompaniaId,CompraCorrelativo=@CompraCorrelativo,
ProveedorId=@ProveedorId,CompraEmision=@CompraEmision,
CompraComputo=@CompraComputo,TipoCodigo=@TipoCodigo,CompraSerie=@CompraSerie,
CompraNumero=@CompraNumero,CompraCondicion=@CompraCondicion,
CompraMoneda=@CompraMoneda,CompraTipoCambio=@CompraTipoCambio,
CompraDias=@CompraDias,CompraFechaPago=@CompraFechaPago,
CompraUsuario=@CompraUsuario,CompraTipoIgv=@CompraTipoIgv,
CompraValorVenta=@CompraValorVenta,
CompraDescuento=@CompraDescuento,
CompraSubtotal=@CompraSubtotal,
CompraIgv=@CompraIgv,CompraTotal=@CompraTotal,
CompraEstado=@CompraEstado,
CompraAsociado=@CompraAsociado,CompraSaldo=@compraSaldo,CompraOBS=@CompraOBS,
CompraTipoSunat=@CompraTipoSunat
where CompraId=@CompraId
end
GO
/****** Object:  StoredProcedure [dbo].[editarDetaLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarDetaLiquida]
@DetalleId numeric(38),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@FechaPago varchar(60)
as
begin
update DetalleLiquida
set EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,FechaPago=@FechaPago
where DetalleId=@DetalleId
end
GO
/****** Object:  StoredProcedure [dbo].[editarGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarGuia]
@orden varchar(Max)
as
begin
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,                            
        @pos5 int,@pos6 int,@pos7 int ,@pos8 int,                
        @pos9 int,@pos10 int,@pos11 int,@pos12 int
          
Declare @GuiaId numeric(38),@GuiaMotivo varchar(80),    
		@GuiaDestinatario varchar(250),@GuiaRucDes varchar(60),    
		@GuiaAlmacen varchar(80),@GuiaPartida varchar(max),    
		@GuiaLLegada varchar(max),@GuiaTramsporte varchar(80),    
		@GuiaUsuario varchar(80),@GuiaTotal decimal(18,2),    
		@ClienteId numeric(20),@GuiaTelefono varchar(80)    

Set @pos1=CharIndex('|',@orden,0)                            
Set @pos2=CharIndex('|',@orden,@pos1+1)                            
Set @pos3=CharIndex('|',@orden,@pos2+1)                            
Set @pos4=CharIndex('|',@orden,@pos3+1)                            
Set @pos5=CharIndex('|',@orden,@pos4+1)                            
Set @pos6=CharIndex('|',@orden,@pos5+1)                          
Set @pos7=CharIndex('|',@orden,@pos6+1)                  
Set @pos8=CharIndex('|',@orden,@pos7+1)                
Set @pos9=CharIndex('|',@orden,@pos8+1)                            
Set @pos10=CharIndex('|',@orden,@pos9+1)                            
Set @pos11=CharIndex('|',@orden,@pos10+1)
Set @pos12=Len(@orden)+1

Set @GuiaId=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))                           
Set @GuiaMotivo=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)                
Set @GuiaDestinatario=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)                            
Set @GuiaRucDes=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)                            
Set @GuiaAlmacen=SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1)                            
Set @GuiaPartida=SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1)                            
Set @GuiaLLegada=SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1)               
Set @GuiaTramsporte=SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1)                            
Set @GuiaUsuario=SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1)              
Set @GuiaTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1))                            
Set @ClienteId=convert(int,SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1))                  
Set @GuiaTelefono=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1) 

update GuiaRemision    
set GuiaMotivo=@GuiaMotivo,GuiaRegistro=GETDATE(),    
GuiaDestinatario=@GuiaDestinatario,GuiaRucDes=@GuiaRucDes,GuiaAlmacen=@GuiaAlmacen,    
GuiaPartida=@GuiaPartida,GuiaLLegada=@GuiaLLegada,GuiaTramsporte=@GuiaTramsporte,  
GuiaUsuario=@GuiaUsuario,GuiaTotal=@GuiaTotal,    
ClienteId=@ClienteId,GuiaTelefono=@GuiaTelefono    
where GuiaId=@GuiaId

select 'true'  

end
GO
/****** Object:  StoredProcedure [dbo].[editarLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarLiquida]
@LiquidacionId numeric(38),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
update Liquidacion
set LiquidacionRegistro=@LiquidacionRegistro,LiquidacionFecha=@LiquidacionFecha,
LiquidacionDescripcion=@LiquidacionDescripcion,LiquidacionCambio=@LiquidacionCambio,
LiquidaEfectivoSol=@LiquidaEfectivoSol,LiquidaDepositoSol=@LiquidaDepositoSol,
LiquidaTotalSol=@LiquidaTotalSol,LiquidaEfectivoDol=@LiquidaEfectivoDol,
LiquidaDepositoDol=@LiquidaDepositoDol,LiquidaTotalDol=@LiquidaTotalDol,
LiquidaUsuario=@LiquidaUsuario
where LiquidacionId=@LiquidacionId
end
GO
/****** Object:  StoredProcedure [dbo].[editarLiquidaVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarLiquidaVenta]
@LiquidacionId numeric(38),
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
update LiquidacionVenta
set LiquidacionRegistro=GETDATE(),LiquidacionFecha=@LiquidacionFecha,
LiquidacionDescripcion=@LiquidacionDescripcion,LiquidacionCambio=@LiquidacionCambio,
LiquidaEfectivoSol=@LiquidaEfectivoSol,LiquidaDepositoSol=@LiquidaDepositoSol,
LiquidaTotalSol=@LiquidaTotalSol,LiquidaEfectivoDol=@LiquidaEfectivoDol,
LiquidaDepositoDol=@LiquidaDepositoDol,LiquidaTotalDol=@LiquidaTotalDol,
LiquidaUsuario=@LiquidaUsuario
where LiquidacionId=@LiquidacionId
end
GO
/****** Object:  StoredProcedure [dbo].[editarNOta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarNOta]
@NotaId numeric(38),
@NotaDocu varchar(60),
@ClienteId numeric(20),
@NotaFecha datetime,
@NotaUsuario varchar(60),
@NotaSubtotal decimal(8,2),
@NotaDescuento decimal(18,2),
@NotaTotal decimal(18,2),
@NotaEstado varchar(60)
as
begin
update NotaPedido
set NotaDocu=@NotaDocu,ClienteId=@ClienteId,NotaFecha=@NotaFecha,NotaUsuario=@NotaUsuario,NotaSubtotal=@NotaSubtotal,NotaDescuento=@NotaDescuento,NotaTotal=@NotaTotal,NotaEstado=@NotaEstado
where NotaId=@NotaId
end
GO
/****** Object:  StoredProcedure [dbo].[editarPersonal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarPersonal]
@PersonalId numeric(20),
@PersonalNombres varchar(140),
@PersonalApellidos varchar(140),
@AreaId numeric(20),
@PersonalCodigo varchar (80),
@PersonalNacimiento date,
@PersonalIngreso varchar(20),
@PersonalDNI varchar(20),
@PersonalDireccion varchar(140),
@PersonalTelefono varchar(40),
@PersonalTelefonoAsi varchar(40),
@PersonalEmail varchar(100),
@PersonalSueldo decimal(18,2),
@PersonalEstado varchar(60),
@PersonalBajaFecha varchar(60),
@PersonalRuc varchar(20),
@PersonalImagen varchar(max),
@CompaniaId int,
@Licencia varchar(80)
as
begin
update Personal
set PersonalNombres=@PersonalNombres,PersonalApellidos=@PersonalApellidos,AreaId=@AreaId,PersonalCodigo=@PersonalCodigo,PersonalNacimiento=@PersonalNacimiento,
PersonalIngreso=@PersonalIngreso,PersonalDNI=@PersonalDNI,PersonalDireccion=@PersonalDireccion,PersonalTelefono=@PersonalTelefono,
PersonalTelefonoAsi=@PersonalTelefonoAsi,PersonalEmail=@PersonalEmail,PersonalSueldo=@PersonalSueldo,PersonalEstado=@PersonalEstado,
PersonalBajaFecha=@PersonalBajaFecha,PersonalRuc=@PersonalRuc,PersonalImagen=@PersonalImagen,CompaniaId=@CompaniaId,
PersonalLicencia=@Licencia
where PersonalId=@PersonalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarProducto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarProducto]    
 @IdProducto numeric(20),    
 @IdSubLinea numeric(20),    
 @ProductoCodigo varchar(300),    
 @ProductoNombre varchar(300),    
 @ProductoMarca varchar(80),    
 @ProductoTipoCambio decimal (18,3),    
 @ProductoCostoDolar decimal(18,4),    
 @ProductoUM varchar(60),    
 @ProductoCosto decimal(18,4),    
 @ProductoVenta decimal(18,2),    
 @ProductoVentaB decimal(18,2),    
 @AlmacenId numeric(20),    
 @ProductoUbicacion varchar(80),    
 @ProductoCantidad decimal(18,2),     
 @ProductoEstado varchar(60),    
 @ProductoUsuario varchar(60),    
 @ProductoImagen varchar(max),    
 @ValorCritico decimal(18,2),    
 @AVISO INT,    
 @AplicaTC nvarchar(1),    
 @AplicaFB nvarchar(1),  
 @AplicaINV nvarchar(1),
 @MaxCantVen decimal(18,2)     
 as    
 declare @inicial decimal(18,2)    
 set @inicial=(select p.ProductoCantidad   
 from Producto p (nolock)  
 where IdProducto=@IdProducto)    
 if(@AVISO=1)    
 begin    
 begin Tran    
 update Producto    
 set IdSubLinea=@IdSubLinea,ProductoCodigo=@ProductoCodigo,ProductoNombre=@ProductoNombre,    
 ProductoMarca=@ProductoMarca,ProductoTipoCambio=@ProductoTipoCambio,ProductoCostoDolar=@ProductoCostoDolar,    
 ProductoUM=@ProductoUM,ProductoCosto=@ProductoCosto,ProductoVenta=@ProductoVenta,    
 ProductoVentaB=@ProductoVentaB,AlmacenId=@AlmacenId,ProductoUbicacion=@ProductoUbicacion,    
 ProductoCantidad=ProductoCantidad,ProductoEstado=@ProductoEstado,    
 ProductoUsuario=@ProductoUsuario,ProductoFecha=GETDATE(),ProductoImagen=@ProductoImagen,ValorCritico=@ValorCritico,    
 AplicaTC=@AplicaTC,AplicaFB=@AplicaFB,AplicaINV=@AplicaINV,CantidadANT=@inicial,MaxCantVen=@MaxCantVen
 where IdProducto=@IdProducto    
 insert into Kardex values(@IdProducto,GETDATE(),'Edita Costo','Edita Costo',  
 @inicial,0,0,@ProductoCosto,@inicial,'INGRESO',@ProductoUsuario)    
 commit tran    
 end    
 else    
 begin    
 begin tran    
 update Producto    
 set IdSubLinea=@IdSubLinea,ProductoCodigo=@ProductoCodigo,ProductoNombre=@ProductoNombre,    
 ProductoMarca=@ProductoMarca,ProductoTipoCambio=@ProductoTipoCambio,ProductoCostoDolar=@ProductoCostoDolar,    
 ProductoUM=@ProductoUM,ProductoCosto=@ProductoCosto,ProductoVenta=@ProductoVenta,    
 ProductoVentaB=@ProductoVentaB,AlmacenId=@AlmacenId,ProductoUbicacion=@ProductoUbicacion,    
 ProductoCantidad=@ProductoCantidad,ProductoEstado=@ProductoEstado,    
 ProductoUsuario=@ProductoUsuario,ProductoFecha=GETDATE(),ProductoImagen=@ProductoImagen,ValorCritico=@ValorCritico,    
 AplicaTC=@AplicaTC,AplicaFB=@AplicaFB,AplicaINV=@AplicaINV,CantidadANT=@inicial,MaxCantVen=@MaxCantVen  
 where IdProducto=@IdProducto    
 insert into Kardex values(@IdProducto,GETDATE(),'Edita Cantidad',  
 'Edita Cantidad',@inicial,0,0,@ProductoCosto,@ProductoCantidad,'INGRESO',@ProductoUsuario)    
 commit tran    
 end
GO
/****** Object:  StoredProcedure [dbo].[editarTemLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarTemLiquida] 
@TemporalId numeric(38),
@EfectivoSoles decimal(18,2),
@EfectivoDolar decimal(18,2),
@DepositoSoles decimal(18,2),
@DepositoDolar decimal(18,2),
@TipoCambio decimal(18,3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18,2),
@TemporalFecha varchar(60)
as
begin
update TemporalLiquida
set EfectivoSoles=@EfectivoSoles,EfectivoDolar=@EfectivoDolar,
DepositoSoles=@DepositoSoles,DepositoDolar=@DepositoDolar,
TipoCambio=@TipoCambio,EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,
AcuentaGeneral=@AcuentaGeneral,TemporalFecha=@TemporalFecha
where TemporalId=@TemporalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarTemLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarTemLiVenta] 
@TemporalId numeric(38),
@EfectivoSoles decimal(18,2),
@EfectivoDolar decimal(18,2),
@DepositoSoles decimal(18,2),
@DepositoDolar decimal(18,2),
@TipoCambio decimal(18,3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18,2),
@TemporalFecha varchar(60)
as
begin
update TemporalLiVenta
set EfectivoSoles=@EfectivoSoles,EfectivoDolar=@EfectivoDolar,
DepositoSoles=@DepositoSoles,DepositoDolar=@DepositoDolar,
TipoCambio=@TipoCambio,EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,
AcuentaGeneral=@AcuentaGeneral,TemporalFecha=@TemporalFecha
where TemporalId=@TemporalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarUsuario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarUsuario] 
@UsuarioId int,
@UsuarioAlias varchar(60),
@UsuarioClave varchar(40),
@UsuarioEstado varchar(40)
as
begin
update Usuarios 
set UsuarioAlias=@UsuarioAlias,UsuarioClave=dbo.encriptar(@UsuarioClave),
UsuarioFechaReg=GETDATE(),Usuarioestado=@UsuarioEstado
where UsuarioID=@UsuarioId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaBloqueB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaBloqueB]
@ListaOrden varchar(Max),
@PKardex varchar(max)
as
begin
Declare @pos int
	Set @pos = CharIndex('[',@ListaOrden,0)
	Declare @BloqueId varchar(max)
	Declare @detalle varchar(max)
	Set @BloqueId=SUBSTRING(@ListaOrden,1,@pos-1)
	Set @detalle =SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @NotaId numeric(38)
		Declare @ps1 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @NotaId=@Columna
		update NotaPedido
        set NotaEstado='PENDIENTE',NotaSaldo=NotaPagar,NotaAcuenta=0,CajaId=''
        where NotaId=@NotaId
        delete from CajaDetalle
        where NotaId=@NotaId
Fetch Next From Tabla INTO @Columna
End
	Close Tabla;
	Deallocate Tabla;
	begin
	DECLARE @Kardex VARCHAR(MAX)
    Set @Kardex =@PKardex
	Declare TablaB Cursor For Select * From fnSplitString(@Kardex,';')	
Open TablaB
		Declare @ColumnaB varchar(max),
		@IdProducto numeric(20),
		@Documento varchar(150),
		@CantIngreso decimal(18,2),
		@PrecioCosto decimal(18,4),
		@Usuario varchar(80)
		Declare @p1 int
		Declare @p2 int
		Declare @p3 int
		declare @p4 int
		declare @p5 int
		declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)
Fetch Next From TablaB INTO @ColumnaB
	While @@FETCH_STATUS = 0
	Begin
		Set @p1 = CharIndex('|',@ColumnaB,0)
		Set @p2 = CharIndex('|',@ColumnaB,@p1+1)
		Set @p3 = CharIndex('|',@ColumnaB,@p2+1)
		Set @p4 = CharIndex('|',@ColumnaB,@p3+1)
		Set @p5 =Len(@ColumnaB)+1
        Set @IdProducto=Convert(numeric(20),SUBSTRING(@ColumnaB,1,@p1-1))
		Set @Documento= Convert(varchar(150),SUBSTRING(@ColumnaB,@p1+1,@p2-(@p1+1)))
		Set @CantIngreso= Convert(varchar(80),SUBSTRING(@ColumnaB,@p2+1,@p3-(@p2+1)))
		Set @PrecioCosto= Convert(varchar(80),SUBSTRING(@ColumnaB,@p3+1,@p4-(@p3+1)))
		Set @Usuario= Convert(varchar(80),SUBSTRING(@ColumnaB,@p4+1,@p5-@p4-1))
		set @IniciaStock=(select top 1 ProductoCantidad from Producto (nolock) where IdProducto=@IdProducto)
		set @StockFinal=@IniciaStock+@CantIngreso
		insert into Kardex values(@IdProducto,GETDATE(),'Anulacion por Venta',@Documento,@IniciaStock,
		@CantIngreso,0,@PrecioCosto,@StockFinal,'INGRESO',@Usuario)
		update producto 
	    set  ProductoCantidad =ProductoCantidad+@CantIngreso
	    where IDProducto=@IdProducto
		Fetch Next From TablaB INTO @ColumnaB
	End
	Close TablaB;
	Deallocate TablaB;
	delete from DetalleBloque
	where BloqueId=@BloqueId
	delete from BLOQUE
	where BloqueId=@BloqueId
end
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[eliminaCuenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaCuenta]
@Data varchar(max)
as
begin
    Set @Data = LTRIM(RTrim(@Data))
	Declare @pos1 int,@pos2 int
	declare @CuentaId numeric(38),@ProveedorId numeric(38)
	declare @contador int
Set @pos1 = CharIndex('|',@Data,0)
Set @CuentaId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 =Len(@Data)+1
Set @ProveedorId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
	delete from CuentaProveedor
	where CuentaId=@CuentaId
set @contador=(select COUNT(*) from CuentaProveedor where ProveedorId=@ProveedorId)	
if 	@contador<=0
begin
	select 'true'
end
else
begin
	select isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.CuentaId)+'|'+c.Entidad+'|'+
	c.TipoCuenta+'|'+c.Moneda+'|'+c.NroCuenta
	from CuentaProveedor c
	where c.ProveedorId=@ProveedorId
	order by c.CuentaId desc
	for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaCaja]   
@Data varchar(max)    
as    
begin     
Declare  @p1 int,@p2 int,  
         @p3 int,@p4 int,  
         @p5 int,@p6 int,  
         @p7 int,@p8 int    
Declare @DetalleId numeric(38),@NotaId numeric(38),    
  @Monto decimal(18,2),@Concepto varchar(80),    
  @Justificacion varchar(300),@Usuario varchar(80),    
  @Autoriza varchar(80),@CajaId varchar(38)        
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = CharIndex('|',@Data,@p3+1)  
Set @p5 = CharIndex('|',@Data,@p4+1)  
Set @p6 = CharIndex('|',@Data,@p5+1)  
Set @p7 = CharIndex('|',@Data,@p6+1)  
Set @p8= Len(@Data)+1  
Set @DetalleId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
Set @Monto=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))  
Set @Concepto=SUBSTRING(@Data,@p3+1,@p4-@p3-1)  
Set @Justificacion=SUBSTRING(@Data,@p4+1,@p5-@p4-1)  
Set @Usuario=SUBSTRING(@Data,@p5+1,@p6-@p5-1)  
Set @Autoriza=SUBSTRING(@Data,@p6+1,@p7-@p6-1)  
Set @CajaId=SUBSTRING(@Data,@p7+1,@p8-@p7-1)   

declare @Acuenta decimal(18,2),@Documento varchar(40),    
@EstadoDocu varchar(80)    

declare @DataA varchar(60)    
declare @c1 int,@c2 int  
    
update NotaPedido    
set NotaSaldo=NotaSaldo + @Monto,NotaAcuenta=NotaAcuenta-@Monto    
where NotaId=@NotaId    
  
set @Acuenta=(select NotaAcuenta from NotaPedido where NotaId=@NotaId)    
  
set @DataA=isnull((select top 1 d.DocuDocumento+'¬'+d.DocuEstado from   
DocumentoVenta d where d.NotaId=@NotaId order by DocuId desc),'0¬0')    
  
Set @DataA= LTRIM(RTrim(@DataA))    
Set @c1 = CharIndex('¬',@DataA,0)    
Set @c2 = Len(@DataA)+1    
  
Set @Documento=SUBSTRING(@DataA,1,@c1-1)    
Set @EstadoDocu=SUBSTRING(@DataA,@c1+1,@c2-@c1-1)    
  
if @EstadoDocu='ANULADO'    
begin    
 update NotaPedido     
 set NotaEstado='ANULADO'    
 where NotaId=@NotaId    
end    
else    
begin    
if(@Documento='FACTURA' or @Documento='BOLETA')    
begin    
if @Acuenta<=0    
begin    
 update NotaPedido     
 set NotaEstado='EMITIDO'    
 where NotaId=@NotaId    
end    
else    
begin    
 update NotaPedido     
 set NotaEstado='ACUENTA'    
 where NotaId=@NotaId    
end    
END    
else    
begin    
 if @Acuenta<=0    
 begin    
  update NotaPedido     
  set NotaEstado='PENDIENTE'    
  where NotaId=@NotaId    
 end    
 else    
 begin    
  update NotaPedido     
  set NotaEstado='ACUENTA'    
  where NotaId=@NotaId    
 end    
end    
end    
Begin Transaction  
  
delete from CajaDetalle     
where DetalleId=@DetalleId  
    
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'ELIMINA',    
@Concepto,@Justificacion,@Monto,@Usuario,@Autoriza,CONVERT(varchar,@NotaId))    
  
Commit Transaction;  
SELECT 'true'  
  
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaCajaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[eliminaDetaCajaB]
@Data varchar(max)
as
begin
Declare @p1 int,
        @p2 int
Declare @DetalleId numeric(38),
		@CajaId numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = Len(@Data)+1
Set @DetalleId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CajaId =convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
delete from CajaDetalle 
where DetalleId=@DetalleId
begin
select isnull((select stuff((select '¬'+
	convert(varchar,d.DetalleId)+'|'+convert(varchar,d.CajaId)+'|'+
	(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
	convert(varchar,d.NotaId)+'|'+d.DetalleMovimiento+'|'+d.DetalleReferencia+'|'+d.DetalleConcepto+'|SOLES|0|'+
	CONVERT(VarChar(50), cast(d.DetalleEfectivo as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleVuelto as money ), 1)+'|'+
	convert(varchar,d.DetalleEfectivo)+'|'+ISNULL(n.NotaEntrega,'INMEDIATA')
	from CajaDetalle d
	left join NotaPedido n
	on n.NotaId=d.NotaId
	where d.CajaId=@CajaId
	order by d.DetalleId desc
	for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaLiquida] 
@DetalleId numeric(38),
@CompraId numeric(18,2),
@Acuenta decimal(18,2),
@Concepto varchar(40)
as
begin
if(@Concepto='LETRA')
begin
update DetalleLetra
set DetalleSaldo=DetalleSaldo+@Acuenta,DetalleEstado='PENDIENTE DE PAGO'
where DetalleId=@CompraId
end
else
begin
update Compras
set CompraSaldo=CompraSaldo+@Acuenta,CompraEstado='PENDIENTE DE PAGO'
where CompraId=@CompraId
end
begin
delete from DetalleLiquida
where DetalleId=@DetalleId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaLiVenta] @DetalleId numeric(38),@DocuId numeric(38),@NotaId numeric(38),@Acuenta decimal(18,2)
as
BEGIN TRANSACTION
update DocumentoVenta
set DocuSaldo=DocuSaldo+@Acuenta,DocuEstado='EMITIDO'
where DocuId=@DocuId
update NotaPedido
set NotaSaldo=NotaSaldo + @Acuenta,NotaEstado='EMITIDO'
where NotaId=@NotaId
delete from DetaLiquidaVenta
where DetalleId=@DetalleId
commit
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaNota]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[eliminaDetaNota]  
@Data varchar(max)  
as  
begin  
declare @p0 int,@p1 int,  
        @p2 int,@p3 int  
declare @DetalleId numeric(38),  
        @Ganancia decimal(18,2),  
        @NotaId numeric(38),  
        @IdProducto numeric(20)  
Set @Data= LTRIM(RTrim(@Data))  
set @p0 = CharIndex('|',@Data,0)  
set @p1= CharIndex('|',@Data,@p0+1)  
set @p2= CharIndex('|',@Data,@p1+1)  
Set @p3= Len(@Data)+1  
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Data,1,@p0-1))  
Set @Ganancia= Convert(decimal(18,2),SUBSTRING(@Data,@p0+1,@p1-@p0-1))  
set @NotaId= Convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
set @IdProducto= Convert(numeric(20),SUBSTRING(@Data,@p2+1,@p3-@p2-1))  
begin  
    --update DetallePedido  
    --set DetalleEstado='ANULADO'  
    --where DetalleId=@DetalleId      
    update DetalleStock  
    set ESTADO='A'  
    where IdProducto=@IdProducto and NotaId=convert(varchar,@NotaId) 
      
 delete from DetallePedido   
 where DetalleId=@DetalleId  
 delete from DetalleStock  
 where IdProducto=@IdProducto and NotaId=convert(varchar,@NotaId)  
 update NotaPedido  
 set NotaGanancia=NotaGanancia-@Ganancia  
 where NotaId=convert(varchar,@NotaId)
 select 'true'  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaGuiaRe]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[eliminaGuiaRe]
@GuiaId numeric(38),
@NotaId numeric(38)
as
begin
begin
update GuiaRemision
set GuiaEstado=''
where GuiaId=@GuiaId
end
begin
delete from GuiaRelacion
where NotaId=@NotaId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaliquiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaliquiVenta] 
@LiquidacionId numeric(38),
@NotaId numeric(38),
@Acuenta decimal(18,2)
as
update NotaPedido
set NotaSaldo=NotaSaldo + @Acuenta,NotaEstado='EMITIDO'
where NotaId=@NotaId
delete from DetaLiquidaVenta
where LiquidacionId=@LiquidacionId
delete from LiquidacionVenta
where LiquidacionId=@LiquidacionId
GO
/****** Object:  StoredProcedure [dbo].[eliminarCajaPrin]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[eliminarCajaPrin]
@Data varchar(max)
as
begin
Declare  @p1 int,@p2 int
Declare @IdCaja numeric(38),
        @GastoId nvarchar(40)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 =Len(@Data)+1
Set @IdCaja=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @GastoId=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
begin
delete from GastosFijos
where GastoId=@GastoId
delete from CajaPincipal 
where IdCaja=@IdCaja
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId 
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId 
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarCanje]
@CanjeId numeric(38),@CompraId numeric(38),@GTCSunat decimal(18,3),
@GCompania int,@GSerie varchar(80),
@GNumero varchar(80),@GEmision date,
@GComputo date,@GCorrelativo varchar(80),
@GTipo varchar(80),@GOBS varchar(max),
@Usuario varchar(60),@Monto decimal(18,2)
as
declare @Subtotal decimal(18,2),@Igv decimal(18,2),@Total decimal(18,2)
IF @GTipo ='DISGREGADO'
begin
set @Subtotal=@Monto
set @Igv=@Subtotal * 0.18
set @Total=@Subtotal + @Igv
end   
ELSE If @GTipo='INCLUIDO'
begin
set @Subtotal=@Monto/1.18
set @Igv=@Monto-(@Monto/1.18)
set @Total=@Monto
end
Else
begin
set @Subtotal=@Monto
set @Igv=0
set @Total=@Monto
end
begin
update Compras
set CompaniaId=@GCompania,CompraTipoSunat=@GTCSunat,CompraSerie=@GSerie,CompraNumero=@GNumero,CompraEmision=@GEmision,
CompraComputo=@GComputo,CompraCorrelativo=@GCorrelativo,CompraTipoIgv=@GTipo,CompraOBS=@GOBS,TipoCodigo='09',CompraUsuario=@Usuario,
CompraSubtotal=@Subtotal,CompraIgv=@Igv,CompraTotal=@Total
where CompraId=@CompraId
begin
delete from GuiaCanje
where CanjeId=@CanjeId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarCompra]   
@CompraId numeric(38)  
as  
begin  
delete from DetalleCompra   
where CompraId=@CompraId  
delete from Compras  
where CompraId=@CompraId  
select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarGeneral]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarGeneral]
@Data varchar(max)
as
begin
Declare @IdGeneral numeric(38)
set @IdGeneral=@Data
	delete from CajaGeneral
	where IdGeneral=@IdGeneral
	update CajaPincipal
	set IdGeneral=0
	where IdGeneral=@IdGeneral
end
begin
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarGuia] 
@GuiaId numeric(38)
as
begin
delete from DetalleGuia
where GuiaId=@GuiaId
end
begin
delete from GuiaRemision
where GuiaId=@GuiaId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarletra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarletra] @LetraId numeric(38)
as
begin
delete from DocumentoCanje
where LetraId=@LetraId
begin
delete from DetalleLetra
where LetraId=@LetraId
begin
delete from Letra
where LetraId=@LetraId
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarliquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarliquida]
@LiquidacionId numeric(38),
@CompraId numeric(18,2),
@Acuenta decimal(18,2),
@Concepto varchar(40)
as
begin
if(@Concepto='LETRA')
begin
update DetalleLetra
set DetalleSaldo=DetalleSaldo+@Acuenta,DetalleEstado='PENDIENTE DE PAGO'
where DetalleId=@CompraId
end
else
begin
update Compras
set CompraSaldo=CompraSaldo+@Acuenta,CompraEstado='PENDIENTE DE PAGO'
where CompraId=@CompraId
end
end
begin
delete from DetalleLiquida
where LiquidacionId=@LiquidacionId
end
begin
delete from Liquidacion
where LiquidacionId=@LiquidacionId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarNotaPedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarNotaPedido]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @NotaId numeric(38)
set @NotaId=CONVERT(numeric(38),@orden)
if(@detalle='~')
begin
Begin Transaction
	delete from DetallePedido  
    where NotaId=@NotaId 
    delete from NotaPedido  
    where NotaId=@NotaId
    Commit Transaction;
	select 'true'
end
else
begin
Begin Transaction
	delete from DetallePedido  
    where NotaId=@NotaId 
    delete from NotaPedido  
    where NotaId=@NotaId    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @GuiaId  numeric(38)
Declare @p1 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
	Set @p1 = Len(@Columna)+1
	Set @GuiaId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))       
    update GuiaRemision  
	set GuiaEstado=''  
	where GuiaId=@GuiaId     
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	delete from GuiaRelacion  
	where NotaId=@NotaId   
	Commit Transaction;
	select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarRenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[eliminarRenta] 
@Data varchar(max)
as
begin
Declare @RentaId numeric(38),
@Cantidad int
Set @Data = LTRIM(RTrim(@Data))
Set @RentaId=convert(numeric(38),@Data)
delete from RentaMensual
where RentaId=@RentaId
set @Cantidad=(select COUNT(r.RentaId) from RentaMensual r)
if @Cantidad<=0
begin
select 'true'
end
else
begin
(select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminartemporales]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminartemporales] @usuarioId int
as
begin
delete from temporalLetra
where UsuarioId=@usuarioId
begin
delete from TemporalCanje
where UsuarioId=@usuarioId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarUM]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[eliminarUM]
@Data varchar(max)
as
begin
    Set @Data = LTRIM(RTrim(@Data))
	Declare @pos1 int,@pos2 int
	declare @IdUm int,@IdProducto numeric(20)
	declare @contador int
Set @pos1 = CharIndex('|',@Data,0)
Set @IdUm =convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 =Len(@Data)+1
Set @IdProducto=convert(numeric,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
	delete from UnidadMedida
	where IdUm=@IdUm
set @contador=(select COUNT(*) from UnidadMedida where IdProducto=@IdProducto)	
if 	@contador<=0
begin
	select 'true'
end
else
begin
	(select STUFF ((select '¬'+convert(varchar,m.IdUm)+'|'+CONVERT(varchar,m.IdProducto)+'|'+m.UMDescripcion+'|'+
	CONVERT(VarChar(50), cast(m.ValorUM as money ),2)+'|'+CONVERT(VarChar(50),cast(m.PrecioVenta as money ), 1)+'|'+CONVERT(VarChar(50), cast(m.PrecioVentaB as money ), 1)+'|'+
	CONVERT(varchar(50),m.PrecioCosto)
	from UnidadMedida m
	where m.IdProducto=@IdProducto
	order by m.ValorUM asc
	for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaTipoCambio]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaTipoCambio]
@Data varchar(max)
as
begin
    Set @Data = LTRIM(RTrim(@Data))
	declare @IdTipo numeric(38)
	declare @TipoEmpresa decimal(18,3)
	set @IdTipo=convert(numeric(38),@Data)
	delete from TipoCambio 
	where IdTipo=@IdTipo
	set @TipoEmpresa=(select top 1 TipoEmpresa from TipoCambio order by IdTipo desc)
	update Producto
	set ProductoCosto=ProductoCostoDolar*@TipoEmpresa,ProductoTipoCambio=@TipoEmpresa
	where AplicaTC='S'
	select 'true'	
end
GO
/****** Object:  StoredProcedure [dbo].[equivalenteProducto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[equivalenteProducto]
as
begin
select 'IdPro|Descripcion|UM|Valor|UB|PrecioVenta|PrecioVentaB|PrecioCosto¬100|450|100|100|100|100|100|100¬String|String|String|Decimal|String|Decimal|Decimal|Decimal¬'+
isnull((select STUFF ((select '¬'+convert(varchar,p.IdProducto)+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+u.UMDescripcion+'|'+
convert(varchar,u.ValorUM)+'|'+p.ProductoUM+'|'+
convert(varchar,u.PrecioVenta)+'|'+
convert(varchar,u.PrecioVentaB)+'|'+
convert(varchar,u.PrecioCosto)
from UnidadMedida u
inner join Producto p
on p.IdProducto=u.IdProducto
order by p.ProductoNombre+' '+p.ProductoMarca asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarCompra]
@CompaniaId int,
@CompraCorrelativo varchar(80),
@ProveedorId numeric(38),
@CompraEmision date,
@CompraComputo date,
@TipoCodigo char(20),
@CompraSerie varchar(60),
@CompraNumero varchar(80),
@CompraCondicion varchar(60),
@CompraMoneda varchar(60),
@CompraTipoCambio decimal(18,3),
@CompraDias int,
@CompraFechaPago date,
@CompraUsuario varchar(80),
@CompraTipoIgv varchar(60),
@CompraValorVenta decimal(18,2),
@CompraDescuento decimal(18,2),
@CompraSubtotal decimal(18,2),
@CompraIgv decimal(18,2),
@CompraTotal decimal(18,2),
@CompraEstado varchar(60),
@CompraAsociado varchar(60),
@compraSaldo decimal(18,2),
@CompraOBS varchar(max),
@CompraTipoSunat decimal(18,3),
@CompraConcepto varchar(60)
as
begin
insert into Compras values(@CompaniaId,@CompraCorrelativo,@ProveedorId,GETDATE(),
@CompraEmision,@CompraComputo,@TipoCodigo,@CompraSerie,@CompraNumero,@CompraCondicion,
@CompraMoneda,@CompraTipoCambio,@CompraDias,@CompraFechaPago,@CompraUsuario,@CompraTipoIgv,
@CompraValorVenta,@CompraDescuento,@CompraSubtotal,@CompraIgv,@CompraTotal,@CompraEstado,
@CompraAsociado,@compraSaldo,@CompraOBS,@CompraTipoSunat,@CompraConcepto)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarDetaCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarDetaCaja]
@CajaId varchar(40),
@NotaId numeric(38),
@DetalleMovimiento varchar(80),
@DetalleReferencia varchar(80),
@DetalleConcepto varchar(250),
@DetalleMonto decimal(18,2),
@DetalleEfectivo decimal(18,2),
@DetalleVuelto decimal(18,2),
@BloqueId numeric(38)=0,
@Avisa char(1)='S',
@Usuario VARCHAR(80)
as
begin
declare @saldoA decimal(18,2)
insert into CajaDetalle values(
@CajaId,GETDATE(),@NotaId,@DetalleMovimiento,
@DetalleReferencia,@DetalleConcepto,
@DetalleMonto,@DetalleEfectivo,@DetalleVuelto,'','T','',@Usuario,'','')
END
BEGIN
update NotaPedido 
set NotaSaldo=NotaSaldo - @DetalleMonto,NotaAcuenta=NotaAcuenta+@DetalleMonto
where NotaId=@NotaId
set @saldoA=(select NotaSaldo from NotaPedido where NotaId=@NotaId)
if @saldoA<=0
begin
update NotaPedido 
set NotaEstado='CANCELADO',CajaId=@CajaId
where NotaId=@NotaId
end
else
begin
update NotaPedido 
set NotaEstado='ACUENTA',CajaId=@CajaId
where NotaId=@NotaId
end
begin
if @Avisa='B'
begin
insert into DetalleBloque values(@BloqueId,@NotaId)
end
end
END
GO
/****** Object:  StoredProcedure [dbo].[ingresarDetaCajaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarDetaCajaB]    
@Data varchar(max)    
as    
begin    
Declare @p1 int,@p2 int,    
  @p3 int,@p4 int,    
  @p5 int,@p6 int,    
  @p7 int,@p8 int,    
  @p9 int,@p10 int,    
  @p11 int,@p12 int,    
  @p13 int    
Declare @CajaId numeric(38),@NotaId numeric(38),    
  @Movimiento varchar(80),    
  @Concepto varchar(250),@Monto decimal(18,2),    
  @Efectivo decimal(18,2),@Vuelto decimal(18,2),    
  @DetalleId numeric(38),@RutaImagen varchar(max),    
  @Usuario VARCHAR(80),@GastoIdB varchar(40),    
  @Justificacion varchar(300),@Autoriza varchar(80)    
Set @Data = LTRIM(RTrim(@Data))    
Set @p1 = CharIndex('|',@Data,0)    
Set @p2 = CharIndex('|',@Data,@p1+1)    
Set @p3 = CharIndex('|',@Data,@p2+1)    
Set @p4 = CharIndex('|',@Data,@p3+1)    
Set @p5 = CharIndex('|',@Data,@p4+1)    
Set @p6 =CharIndex('|',@Data,@p5+1)    
Set @p7 = CharIndex('|',@Data,@p6+1)    
Set @p8 = CharIndex('|',@Data,@p7+1)    
Set @p9 = CharIndex('|',@Data,@p8+1)    
Set @p10= CharIndex('|',@Data,@p9+1)    
Set @p11= CharIndex('|',@Data,@p10+1)    
Set @p12= CharIndex('|',@Data,@p11+1)    
Set @p13= Len(@Data)+1    
Set @CajaId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))    
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))    
Set @Movimiento=SUBSTRING(@Data,@p2+1,@p3-@p2-1)    
Set @Concepto=SUBSTRING(@Data,@p3+1,@p4-@p3-1)    
Set @Monto=convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))    
Set @Efectivo=convert(decimal(18,2),SUBSTRING(@Data,@p5+1,@p6-@p5-1))    
Set @Vuelto=convert(decimal(18,2),SUBSTRING(@Data,@p6+1,@p7-@p6-1))    
Set @DetalleId=convert(numeric(38),SUBSTRING(@Data,@p7+1,@p8-@p7-1))    
Set @RutaImagen=SUBSTRING(@Data,@p8+1,@p9-@p8-1)    
Set @Usuario=SUBSTRING(@Data,@p9+1,@p10-@p9-1)    
Set @GastoIdB=SUBSTRING(@Data,@p10+1,@p11-@p10-1)    
Set @Justificacion=SUBSTRING(@Data,@p11+1,@p12-@p11-1)    
Set @Autoriza=SUBSTRING(@Data,@p12+1,@p13-@p12-1)    
Declare @Referencia varchar(80)    
set @Referencia=@Movimiento    
if(@Movimiento='INGRESO')SET @Movimiento='INGRESO'    
else set @Movimiento='SALIDA'    
if(@DetalleId=0)    
begin    
Declare @GastoId numeric(38)    
set @CajaId=isnull((select top 1 CajaId from Caja c    
where c.CajaEstado='ACTIVO'    
order by c.CajaId desc),0)    
if(@CajaId=0)    
begin    
select 'CERRADO'    
end    
else    
begin    
if(@Referencia='GASTO INTERNO')    
begin    
insert into GastosFijos values(GETDATE(),@Concepto,@Monto,GETDATE(),@Usuario)    
Set @GastoId= @@identity    
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,@Referencia,    
@Concepto,@Monto,@Efectivo,@Vuelto,@RutaImagen,'T','',@Usuario,CONVERT(varchar,@GastoId),'')    
select 'true'    
end    
else    
begin    
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,@Referencia,    
@Concepto,@Monto,@Efectivo,@Vuelto,@RutaImagen,'T','',@Usuario,'','')    
select 'true'    
end    
end    
end    
else    
begin    
Begin Transaction    
if(@GastoIdB='')    
begin    
if(@Referencia='GASTO INTERNO')    
begin    
insert into GastosFijos values(GETDATE(),@Concepto,@Monto,GETDATE(),@Usuario)    
Set @GastoId= @@identity    
update CajaDetalle    
set DetalleFecha=getdate(),DetalleMovimiento=@Movimiento,    
DetalleReferencia=@Referencia,    
DetalleConcepto=@Concepto,DetalleMonto=@Monto,DetalleEfectivo=@Efectivo,    
RutaImagen=@RutaImagen,Usuario=@Usuario,GastoId=convert(varchar,@GastoId)    
where DetalleId=@DetalleId    
--select 'true'    
end    
else    
begin    
delete from GastosFijos     
where GastoId=@GastoIdB    
update CajaDetalle    
set DetalleFecha=getdate(),DetalleMovimiento=@Movimiento,    
DetalleReferencia=@Referencia,    
DetalleConcepto=@Concepto,DetalleMonto=@Monto,DetalleEfectivo=@Efectivo,    
RutaImagen=@RutaImagen,Usuario=@Usuario,GastoId=''    
where DetalleId=@DetalleId    
--select 'true'    
end    
end    
else    
begin    
if(@Referencia='GASTO INTERNO')    
begin    
update GastosFijos    
set GastoFecha=GETDATE(),GsstoDesc=@Concepto,GstoMonto=@Monto,    
GastoReg=GETDATE(),GastoUsuario=@Usuario    
where GastoId=@GastoIdB    
update CajaDetalle    
set DetalleFecha=getdate(),DetalleMovimiento=@Movimiento,DetalleReferencia=@Referencia,    
DetalleConcepto=@Concepto,DetalleMonto=@Monto,DetalleEfectivo=@Efectivo,    
RutaImagen=@RutaImagen,Usuario=@Usuario,GastoId=@GastoIdB    
where DetalleId=@DetalleId    
--select 'true'    
end    
else    
begin    
delete from GastosFijos     
where GastoId=@GastoIdB    
update CajaDetalle    
set DetalleFecha=getdate(),DetalleMovimiento=@Movimiento,DetalleReferencia=@Referencia,    
DetalleConcepto=@Concepto,DetalleMonto=@Monto,DetalleEfectivo=@Efectivo,    
RutaImagen=@RutaImagen,Usuario=@Usuario,GastoId=''    
where DetalleId=@DetalleId    
--select 'true'    
end    
end    
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'MODIFICA',    
@Referencia,@Justificacion,@Monto,@Usuario,@Autoriza,'-')    
Commit Transaction;    
select 'true'    
end    
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarPersonal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarPersonal]  
@PersonalNombres varchar(140),  
@PersonalApellidos varchar(140),  
@AreaId numeric(20),  
@PersonalCodigo varchar (80),  
@PersonalNacimiento date,  
@PersonalIngreso varchar(20),  
@PersonalDNI varchar(20),  
@PersonalDireccion varchar(140),  
@PersonalTelefono varchar(40),  
@PersonalTelefonoAsi varchar(40),  
@PersonalEmail varchar(100),  
@PersonalSueldo decimal(18,2),  
@PersonalEstado varchar(60),  
@PersonalBajaFecha varchar(60),  
@PersonalRuc varchar(20),  
@PersonalImagen varchar(max),  
@CompaniaId int,  
@Licencia varchar(80)  
as  
begin  
insert into Personal values  
(@PersonalNombres,@PersonalApellidos,@AreaId,@PersonalCodigo,  
@PersonalNacimiento,@PersonalIngreso,@PersonalDNI,@PersonalDireccion,  
@PersonalTelefono,@PersonalTelefonoAsi,@PersonalEmail,  
@PersonalSueldo,@PersonalEstado,@PersonalBajaFecha,@PersonalRuc,  
@PersonalImagen,@CompaniaId,@Licencia,'')  
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarProducto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarProducto]        
 @IdSubLinea numeric(20),        
 @ProductoCodigo varchar(300),        
 @ProductoNombre varchar(300),        
 @ProductoMarca varchar(80),        
 @ProductoTipoCambio decimal (18,3),        
 @ProductoCostoDolar decimal(18,4),        
 @ProductoUM varchar(60),        
 @ProductoCosto decimal(18,4),        
 @ProductoVenta decimal(18,2),        
 @ProductoVentaB decimal(18,2),        
 @AlmacenId numeric(20),        
 @ProductoUbicacion varchar(80),        
 @ProductoCantidad decimal(18,2),      
 @ProductoEstado varchar(60),        
 @ProductoUsuario varchar(60),        
 @ProductoImagen varchar(max),        
 @ValorCritico decimal(18,2),        
 @AplicaTC nvarchar(1),        
 @AplicaFB nvarchar(1),      
 @AplicaINV nvarchar(1),    
 @MaxCantVen decimal(18,2)       
 as        
 begin        
 insert into Producto values(        
 @IdSubLinea,@ProductoCodigo,@ProductoNombre,        
 @ProductoMarca,@ProductoTipoCambio,@ProductoCostoDolar,        
 @ProductoUM,@ProductoCosto,@ProductoVenta,        
 @ProductoVentaB,@AlmacenId,@ProductoUbicacion,        
 @ProductoCantidad,@ProductoEstado,        
 @ProductoUsuario,GETDATE(),@ProductoImagen,@ValorCritico,        
 @AplicaTC,@AplicaFB,@AplicaINV,@ProductoCantidad,GETDATE(),@MaxCantVen,0,'')        
 select @@identity        
 begin        
 insert into Kardex values(@@identity,GETDATE(),'Nuevo Registro','Nuevo Registro',        
 0,@ProductoCantidad,0,@ProductoCosto,@ProductoCantidad,'INGRESO',@ProductoUsuario)        
 end        
 end
GO
/****** Object:  StoredProcedure [dbo].[ingresarProveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarProveedor]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int,@p6 int,
		@p7 int,@p8 int,
		@p9 int	
Declare @ProveedorId numeric(38),
        @Razon varchar(250),
		@Ruc varchar(20),
		@Contacto varchar(140),
		@Celular varchar(140),
		@Telefono varchar(140),
		@Correo varchar(140),
		@Direccion varchar(140),
		@Estado varchar(40)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5 = CharIndex('|',@Data,@p4+1)
Set @p6 = CharIndex('|',@Data,@p5+1)
Set @p7 = CharIndex('|',@Data,@p6+1)
Set @p8 = CharIndex('|',@Data,@p7+1)
Set @p9 =Len(@Data)+1
set @ProveedorId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
set @Razon=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
set @Ruc=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
set @Contacto=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
set @Celular=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
set @Telefono=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
set @Correo=SUBSTRING(@Data,@p6+1,@p7-@p6-1)
set @Direccion=SUBSTRING(@Data,@p7+1,@p8-@p7-1)
set @Estado=SUBSTRING(@Data,@p8+1,@p9-@p8-1)
if @ProveedorId=0
begin
insert into Proveedor values(@Razon,@Ruc,@Contacto,@Celular,@Telefono,@Correo,@Direccion,@Estado)
end
else
begin
update Proveedor
set ProveedorRazon=@Razon,ProveedorRuc=@Ruc,ProveedorContacto=@Contacto,
ProveedorCelular=@Celular,ProveedorTelefono=@Telefono,ProveedorCorreo=@Correo,
ProveedorDireccion=@Direccion,ProveedorEstado=@Estado
where ProveedorId=@ProveedorId
end
	select isnull((select stuff((SELECT '¬'+ CONVERT(varchar,p.ProveedorId)+'|'+p.ProveedorRazon+'|'+p.ProveedorRuc+'|'+
	p.ProveedorContacto+'|'+p.ProveedorCelular+'|'+p.ProveedorTelefono+'|'+p.ProveedorCorreo+'|'+
	p.ProveedorDireccion+'|'+p.ProveedorEstado
	from Proveedor p
	order by p.ProveedorId desc
	for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarUsuario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarUsuario]
@PersonalId numeric(20),
@UsuarioAlias varchar(60),
@UsuarioClave varchar(40),
@UsuarioEstado varchar(40)
as
begin
insert into Usuarios values(@PersonalId,@UsuarioAlias,
dbo.encriptar(@UsuarioClave),GETDATE(),@UsuarioEstado,
'',0,0,0,0,0)
end
GO
/****** Object:  StoredProcedure [dbo].[insertaClienteLD]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaClienteLD]
@Columna varchar(max) 
 as
 begin
 declare @p0 int, 
     @p1 int,
	 @p2 int,
	 @p3 int,
	 @p4 int,
	 @p5 int,
	 @p6 int,
	 @p7 int,
	 @p8 int,
	 @p9 int,
	 @p10 int
     declare @ClienteId numeric(20), 
     @ClienteRazon varchar(140),
	 @ClienteRuc varchar(40),
	 @ClienteDni varchar(40),
	 @ClienteDireccion varchar(max),
	 @ClienteMovil varchar(80),
	 @ClienteTelefono varchar(80),
	 @ClienteCorreo varchar(80),
	 @Usuario varchar(80),
	 @ClienteEstado varchar(40),
	 @ClienteDespacho varchar(max)
	Set @Columna= LTRIM(RTrim(@Columna))
	set @p0 = CharIndex('|',@Columna,0)
	Set @p1 = CharIndex('|',@Columna,@p0+1)
	Set @p2 = CharIndex('|',@Columna,@p1+1)
	Set @p3 = CharIndex('|',@Columna,@p2+1)
	Set @p4 = CharIndex('|',@Columna,@p3+1)
	Set @p5 = CharIndex('|',@Columna,@p4+1)
	Set @p6 = CharIndex('|',@Columna,@p5+1)
	Set @p7 = CharIndex('|',@Columna,@p6+1)
	Set @p8= CharIndex('|',@Columna,@p7+1)
	Set @p9 = CharIndex('|',@Columna,@p8+1)
	Set @p10 = Len(@Columna)+1
	Set @ClienteId=Convert(numeric(20),SUBSTRING(@Columna,1,@p0-1))
	Set @ClienteRazon=SUBSTRING(@Columna,@p0+1,@p1-(@p0+1))
	Set @ClienteRuc=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
	Set @ClienteDni=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))
	Set @ClienteDireccion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
	Set @ClienteMovil=SUBSTRING(@Columna,@p4+1,@p5-(@p4+1))
	Set @ClienteTelefono=SUBSTRING(@Columna,@p5+1,@p6-(@p5+1))
	Set @ClienteCorreo=SUBSTRING(@Columna,@p6+1,@p7-(@p6+1))
	Set @ClienteEstado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))
	Set @ClienteDespacho=SUBSTRING(@Columna,@p8+1,@p9-@p8-1)
    Set @Usuario=SUBSTRING(@Columna,@p9+1,@p10-(@p9+1))
if(@ClienteId=0)
begin
	insert into Cliente values(@ClienteRazon,@ClienteRuc,@ClienteDni,@ClienteDireccion,@ClienteMovil,@ClienteTelefono,@ClienteCorreo,@ClienteEstado,@ClienteDespacho,@Usuario,GETDATE())
end
else
begin
	update Cliente
	set ClienteRazon=@ClienteRazon,ClienteRuc=@ClienteRuc,ClienteDni=@ClienteDni,ClienteDireccion=@ClienteDireccion,
	ClienteMovil=@ClienteMovil,ClienteTelefono=@ClienteTelefono,ClienteCorreo=@ClienteCorreo,ClienteUsuario=@Usuario,
	clienteEstado=@ClienteEstado,ClienteDespacho=@ClienteDespacho,clienteFecha=GETDATE()
	where ClienteId=@ClienteId
end
Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[insertaDetaLiquiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaDetaLiquiVenta]
@LiquidacionId numeric(38),
@DocuId numeric(38),
@NotaId numeric(38),
@SaldoDocu decimal(18,2),
@EfectivoSoles decimal(18, 2),
@EfectivoDolar decimal(18, 2),
@DepositoSoles decimal(18, 2),
@DepositoDolar decimal(18, 2),
@TipoCambio decimal(18, 3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18, 2),
@SaldoActual decimal(18, 2),
@FechaPago varchar(60),
@DocuEstado varchar(60)
as
insert into DetaLiquidaVenta values(
@LiquidacionId,@DocuId,@NotaId,@SaldoDocu,@EfectivoSoles,
@EfectivoDolar,@DepositoSoles,@DepositoDolar,
@TipoCambio,@EntidadBanco,@NroOperacion,
@AcuentaGeneral,@SaldoActual,@FechaPago
)
update NotaPedido
set NotaSaldo=NotaSaldo-@AcuentaGeneral,NotaEstado=@DocuEstado
where NotaId=@NotaId
GO
/****** Object:  StoredProcedure [dbo].[insertaGuiaCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaGuiaCanje]
@CompraId numeric(38),
@CompaniaId int,
@CanjeFecha date,
@CanjeRegistro datetime,
@CanjeSerie varchar(80),
@CanjeNumero varchar(80),
@CanjeEmision date,
@CanjeComputo date,
@CanjeCorrelativo varchar(80),
@CanjeTipo varchar(80),
@CanjeOBS varchar(max),
@TCSunat decimal(18,3),
@GCompania int,
@GSerie varchar(80),
@GNumero varchar(80),
@GEmision date,
@GCanjeComputo date,
@GCanjeCorrelativo varchar(80),
@GCanjeTipo varchar(80),
@GCanjeOBS varchar(max),
@GTCSunat decimal(18,3),
@CanjeUsuario varchar(60),
@Subtotal decimal(18,2),
@Igv decimal(18,2),
@Total decimal(18,2)
as
begin
insert into GuiaCanje values(@CompraId,@CompaniaId,@CanjeFecha,@CanjeRegistro,@CanjeSerie,@CanjeNumero,
@CanjeEmision,@CanjeComputo,@CanjeCorrelativo,@CanjeTipo,@CanjeOBS,@TCSunat,@GCompania,@GSerie,@GNumero,@GEmision,
@GCanjeComputo,@GCanjeCorrelativo,@GCanjeTipo,@GCanjeOBS,@GTCSunat,@CanjeUsuario)
begin
update Compras
set CompaniaId=@CompaniaId,CompraTipoSunat=@TCSunat,CompraSerie=@CanjeSerie,CompraNumero=@CanjeNumero,CompraEmision=@CanjeEmision,
CompraComputo=@CanjeComputo,CompraCorrelativo=@CanjeCorrelativo,CompraTipoIgv=@CanjeTipo,CompraOBS=@CanjeOBS,TipoCodigo='01',
CompraSubtotal=@Subtotal,CompraIgv=@Igv,CompraTotal=@Total
where CompraId=@CompraId
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertaLiquidaVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaLiquidaVenta]
@LiquidacionNumero varchar(80),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
insert into LiquidacionVenta values(@LiquidacionNumero,
@LiquidacionRegistro,@LiquidacionFecha,@LiquidacionDescripcion,
@LiquidacionCambio,@LiquidaEfectivoSol,@LiquidaDepositoSol,
@LiquidaTotalSol,@LiquidaEfectivoDol,@LiquidaDepositoDol,
@LiquidaTotalDol,@LiquidaUsuario)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insertarAlmacen]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
Declare @pos7 int
Declare @AlmacenId numeric(20)
Declare @AlmacenNombre varchar(80)
Declare @AlmacenDepartamento varchar(80)
Declare @AlmacenProvincia varchar(80)
Declare @AlmacenDistrito varchar(80)
Declare @AlmacenDireccion varchar(300)
Declare @AlmacenEstado varchar(20)
Declare @AlmacenBD varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @AlmacenId =convert(numeric,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @AlmacenNombre = SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1)
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @AlmacenDepartamento=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @AlmacenProvincia=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @AlmacenDistrito=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @AlmacenDireccion=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)
Set @pos7 = Len(@Data)+1
Set @AlmacenEstado=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)
set @AlmacenBD=(select top 1 a.AlmacenNombre from Almacen a where AlmacenNombre=@AlmacenNombre)
if @AlmacenId=0
begin
if(@AlmacenBD=@AlmacenNombre)
begin
select 'existe'
end
else
begin
insert into Almacen values(@AlmacenNombre,@AlmacenDepartamento,@AlmacenProvincia,@AlmacenDistrito,@AlmacenDireccion,@AlmacenEstado)
(select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre+'|'+a.AlmacenDepartamento+'|'+
a.AlmacenProvincia+'|'+a.AlmacenDistrito+'|'+a.AlmacenDireccion+'|'+a.AlmacenEstado
from Almacen a
order by AlmacenId desc
for xml path('')),1,1,''))
end
end
else
begin
update Almacen
set AlmacenNombre=@AlmacenNombre,AlmacenDepartamento=@AlmacenDepartamento,AlmacenProvincia=@AlmacenProvincia,AlmacenDistrito=@AlmacenDistrito,AlmacenDireccion=@AlmacenDireccion,AlmacenEstado=@AlmacenEstado
where AlmacenId=@AlmacenId
(select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre+'|'+a.AlmacenDepartamento+'|'+
a.AlmacenProvincia+'|'+a.AlmacenDistrito+'|'+a.AlmacenDireccion+'|'+a.AlmacenEstado
from Almacen a
order by AlmacenId desc
for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarCajaPri]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarCajaPri]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int,@p6 int,
		@p7 int,@p8 int
declare @CajaConcepto varchar(80),
		@CajaId numeric(38),
		@CajaDescripcion varchar(250),
		@CajaMonto decimal(18,2),
		@CajaUsuario varchar(20),
		@Aviso char(1),
		@IdCaja nvarchar(38),
		@GastoIdB nvarchar(38)
Set @Data = LTRIM(RTrim(@Data))
		Set @p1 = CharIndex('|',@Data,0)
		Set @p2 = CharIndex('|',@Data,@p1+1)
		Set @p3 = CharIndex('|',@Data,@p2+1)
		Set @p4 = CharIndex('|',@Data,@p3+1)
		Set @p5= CharIndex('|',@Data,@p4+1)
		Set @p6= CharIndex('|',@Data,@p5+1)
		Set @p7= CharIndex('|',@Data,@p6+1)
		Set @p8= Len(@Data)+1
		Set @CajaConcepto=SUBSTRING(@Data,1,@p1-1)
		Set @CajaId=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
		Set @CajaDescripcion=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
		Set @CajaMonto=convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-@p3-1))
		Set @CajaUsuario=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
		Set @Aviso=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
		Set @IdCaja=SUBSTRING(@Data,@p6+1,@p7-@p6-1)
		Set @GastoIdB=SUBSTRING(@Data,@p7+1,@p8-@p7-1)			
		Declare @Movimiento nvarchar(20)
		if(@CajaConcepto='INGRESO')SET @Movimiento='INGRESO'
		else set @Movimiento='SALIDA'
		Declare @GastoId numeric(38)		
if(@IdCaja='0')
begin
    if(@CajaConcepto='GASTO INTERNO')
    begin
    insert into GastosFijos values(GETDATE(),@CajaDescripcion,@CajaMonto,GETDATE(),@CajaUsuario)
    Set @GastoId= @@identity
    insert into CajaPincipal values(@Movimiento,GETDATE(),
	@CajaId,@CajaDescripcion,@CajaMonto,@CajaUsuario,0,@CajaConcepto,CONVERT(varchar,@GastoId))
    end
    else
    begin
	insert into CajaPincipal values(@Movimiento,GETDATE(),
	@CajaId,@CajaDescripcion,@CajaMonto,@CajaUsuario,0,@CajaConcepto,'')
	end
end
else
begin
if(@GastoIdB='')
begin
    if(@CajaConcepto='GASTO INTERNO')
    begin
    insert into GastosFijos values(GETDATE(),@CajaDescripcion,@CajaMonto,GETDATE(),@CajaUsuario)
    Set @GastoId= @@identity
    update CajaPincipal
	set CajaConcepto=@Movimiento,CajaFecha=GETDATE(),
	CajaDescripcion=@CajaDescripcion,CajaMonto=@CajaMonto,
	CajaUsuario=@CajaUsuario,Referencia=@CajaConcepto,GastoId=convert(varchar,@GastoId)
	where IdCaja=@IdCaja
	end
	else
	begin
	delete from GastosFijos 
    where GastoId=@GastoId
    update CajaPincipal
	set CajaConcepto=@Movimiento,CajaFecha=GETDATE(),
	CajaDescripcion=@CajaDescripcion,CajaMonto=@CajaMonto,
	CajaUsuario=@CajaUsuario,Referencia=@CajaConcepto,GastoId=''
	where IdCaja=@IdCaja
	end	
end
else
begin
if(@CajaConcepto='GASTO INTERNO')
begin
update GastosFijos
set GastoFecha=GETDATE(),GsstoDesc=@CajaDescripcion,GstoMonto=@CajaMonto,
GastoReg=GETDATE(),GastoUsuario=@CajaUsuario
where GastoId=@GastoIdB
update CajaPincipal
set CajaConcepto=@Movimiento,CajaFecha=GETDATE(),
CajaDescripcion=@CajaDescripcion,CajaMonto=@CajaMonto,
CajaUsuario=@CajaUsuario,Referencia=@CajaConcepto,GastoId=@GastoIdB
where IdCaja=@IdCaja
end
else
begin
delete from GastosFijos 
where GastoId=@GastoIdB
update CajaPincipal
set CajaConcepto=@Movimiento,CajaFecha=GETDATE(),
CajaDescripcion=@CajaDescripcion,CajaMonto=@CajaMonto,
CajaUsuario=@CajaUsuario,Referencia=@CajaConcepto,GastoId=''
where IdCaja=@IdCaja
end
end
end
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[insertarCanje]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarCanje]
@temporalCanje varchar(80),
@temporalDias int,
@temporalVencimiento varchar(20),
@temporalMonto decimal(18,2),
@usuarioId int
as
begin
insert into TemporalCanje values(@temporalCanje,
@temporalDias,@temporalVencimiento,@temporalMonto,@usuarioId)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetaGuia]
@GuiaId numeric(38),
@IdProducto numeric(20),
@DetalleCantidad decimal(18,2),
@DetalleCosto decimal(18,4),
@DetallePrecio decimal(18, 2),
@DetalleImporte decimal(18, 2),
@DetalleEstado varchar(60),
@flac int,
@IdDetalle numeric(38),
@Documento varchar(80),
@Usuario varchar(80),
@Concepto varchar(80),
@ValorUM decimal(18,4),
@UniMedida varchar(40)
as
declare @Inicial decimal(18,2),@final decimal(18,2),@cantidad decimal(18,2)
set @Inicial=(select p.ProductoCantidad from Producto p where p.IdProducto=@IdProducto)
set @cantidad=(@DetalleCantidad * @ValorUM)
if(@Concepto='INGRESO')
begin
set @final=@Inicial+@cantidad
end
else
begin
set @final=@Inicial-@cantidad
end
begin
begin
insert into DetalleGuia values(@GuiaId,@IdProducto,@DetalleCantidad,@DetalleCosto,
@DetallePrecio,@DetalleImporte,@DetalleEstado,@IdDetalle,@ValorUM,@UniMedida)
if(@flac=1)
update DetallePedido
set CantidadSaldo=CantidadSaldo-@DetalleCantidad
where DetalleId=@IdDetalle
end
begin
update producto 
set ProductoCantidad =@final
where IDProducto=@IDProducto
end
begin
if(@Concepto='INGRESO')
begin
insert into Kardex values(@IdProducto,GETDATE(),
'Ingreso por Guia',@Documento,@inicial,@Cantidad,0,@DetalleCosto,@final,'INGRESO',@Usuario)
end
else
begin
insert into Kardex values(@IdProducto,GETDATE(),
'Salida por Guia',@Documento,@inicial,0,@cantidad,@DetalleCosto,@final,'SALIDA',@Usuario)
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaLetra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetaLetra]
@LetraId  numeric(38),
@LetraCanje varchar(80),
@LetraDias int,
@LetraVencimiento date,
@DetalleSaldo decimal(18,2),
@DetalleMonto decimal(18,2),
@DetalleEstado varchar(60)
as
begin
insert into DetalleLetra values(@LetraId,@LetraCanje,
@LetraDias,@LetraVencimiento,@DetalleMonto,
@DetalleSaldo,@DetalleEstado)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetaLiquida]
@LiquidacionId numeric(38),
@CompraId numeric(38),
@SaldoDocu decimal(18,2),
@EfectivoSoles decimal(18, 2),
@EfectivoDolar decimal(18, 2),
@DepositoSoles decimal(18, 2),
@DepositoDolar decimal(18, 2),
@TipoCambio decimal(18, 3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18, 2),
@SaldoActual decimal(18, 2),
@FechaPago varchar(60),
@Numero varchar(60),
@Proveedor varchar(255),
@Moneda varchar(20),
@Concepto varchar(40),
@CompraEstado varchar(60)
as
begin
insert into DetalleLiquida values(
@LiquidacionId,@CompraId,@SaldoDocu,@EfectivoSoles,@EfectivoDolar,@DepositoSoles,
@DepositoDolar,@TipoCambio,@EntidadBanco,@NroOperacion,@AcuentaGeneral,@SaldoActual,@FechaPago,@Numero,
@Proveedor,@Moneda,@Concepto
)
begin
if(@Concepto='COMPRA')
begin
update Compras
set CompraSaldo=CompraSaldo - @AcuentaGeneral,CompraEstado=@CompraEstado
where CompraId=@CompraId
end
else
begin
update DetalleLetra
set DetalleSaldo=DetalleSaldo-@AcuentaGeneral,DetalleEstado=@CompraEstado
where DetalleId=@CompraId
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetalleCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetalleCompra]
@CompraId numeric(38),
@IdProducto numeric(20),
@DetalleCodigo varchar(80),
@Descripcion varchar(255),
@DetalleUM   varchar(60),
@DetalleCantidad decimal(18,2),
@PrecioCosto  decimal(18,4),
@DetalleImprte decimal(18,4),
@DetalleDescuento decimal(18,4),
@DetalleEstado varchar(60)
as
begin
insert into DetalleCompra values(@CompraId,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImprte,
@DetalleDescuento,@DetalleEstado,0,'',1)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetalleNota]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetalleNota]    
@Data varchar(max)    
as    
begin    
Declare @p1 int,@p2 int,@p3 int,@p4 int,    
        @p5 int,@p6 int,@p7 int,@p8 int,    
        @p9 int,@p10 int,@p11 int,@p12 int    
Declare @NotaId numeric(38),    
  @IdProducto numeric(20),    
  @Cantidad decimal(18,2),    
  @DetalleUm varchar(40),    
  @Descripcion varchar(140),    
  @Costo decimal(18,2),     
  @Precio decimal(18,2),    
  @Importe decimal(18,2),    
  @Estado varchar(60),    
  @CantidadSaldo decimal(18,2),    
  @ValorUM decimal(18,4),    
  @DocuId numeric(38)=0    
Declare @DetalleNotaId numeric(38),    
        @Aviso varchar(max),    
        @Stock decimal(18,2),    
        @Existe int    
Set @Data= LTRIM(RTrim(@Data))    
set @p1=CharIndex('|',@Data,0)    
Set @p2=CharIndex('|',@Data,@p1+1)    
Set @p3=CharIndex('|',@Data,@p2+1)    
Set @p4=CharIndex('|',@Data,@p3+1)    
Set @p5=CharIndex('|',@Data,@p4+1)    
Set @p6=CharIndex('|',@Data,@p5+1)    
Set @p7=CharIndex('|',@Data,@p6+1)    
Set @p8=CharIndex('|',@Data,@p7+1)    
Set @p9=CharIndex('|',@Data,@p8+1)    
Set @p10=CharIndex('|',@Data,@p9+1)    
Set @p11=CharIndex('|',@Data,@p10+1)    
Set @p12=Len(@Data)+1    
    
Set @NotaId=Convert(numeric(38),SUBSTRING(@Data,1,@p1-1))    
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-(@p1+1)))    
Set @Cantidad= Convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-(@p2+1)))    
Set @DetalleUm=SUBSTRING(@Data,@p3+1,@p4-(@p3+1))    
Set @Descripcion=SUBSTRING(@Data,@p4+1,@p5-(@p4+1))    
Set @Costo=Convert(decimal(18,2),SUBSTRING(@Data,@p5+1,@p6-(@p5+1)))    
Set @Precio= Convert(decimal(18,2),SUBSTRING(@Data,@p6+1,@p7-(@p6+1)))    
Set @Importe= Convert(decimal(18,2),SUBSTRING(@Data,@p7+1,@p8-(@p7+1)))    
Set @Estado=SUBSTRING(@Data,@p8+1,@p9-(@p8+1))    
Set @CantidadSaldo=Convert(decimal(18,2),SUBSTRING(@Data,@p9+1,@p10-(@p9+1)))    
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Data,@p10+1,@p11-(@p10+1)))    
Set @DocuId=Convert(numeric(38),SUBSTRING(@Data,@p11+1,@p12-(@p11+1)))    
    
insert into DetallePedido values(@NotaId,@IdProducto,@Cantidad,    
@DetalleUm,@Descripcion,@Costo, @Precio,    
@Importe,@Estado,@CantidadSaldo,@ValorUM,'E')    
set @DetalleNotaId=(select @@IDENTITY)    
    
if(@DocuId<>'0')    
begin    
insert into DetalleDocumento values    
(@DocuId,@IdProducto,@Cantidad,@Precio,@Importe,    
@DetalleNotaId,@DetalleUm,@ValorUM)    
end    
set @Aviso=isnull((select top 1 convert(varchar,p.ProductoCantidad)   
from Producto p (nolock)  
where p.IdProducto=@IdProducto and p.ProductoUM=@DetalleUm),'false')    
    
if(@Aviso='false')    
begin    
set @Stock=isnull((select top 1 cast((p.ProductoCantidad/u.ValorUM) as decimal(18,2))  
from Producto p (nolock)  
inner join UnidadMedida u (nolock)    
on p.IdProducto=u.IdProducto    
where p.IdProducto=@IdProducto and u.UMDescripcion=@DetalleUm),0)    
end    
else    
begin    
set @Stock=@Aviso    
end    
if(@Cantidad>@Stock)    
begin    
SET @Existe=ISNULL((select top 1 s.IdProducto   
from Stock s (nolock)    
where s.IdProducto=@IdProducto and s.Estado='BUENO'),0)     
if(@Existe=0)select 'true'    
else select 'A'     
end    
else    
begin    
select 'true'    
end    
end
GO
/****** Object:  StoredProcedure [dbo].[insertarGeneral]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarGeneral]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int
Declare
		@IdGeneral numeric(38),
		@Usuario varchar(80),
		@Ingresos decimal(18,2),
		@Salidas decimal(18,2),
		@Total decimal(18,2),
		@Codigo numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5 =Len(@Data)+1
set @IdGeneral=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
set @Usuario=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
set @Ingresos=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))
set @Salidas=convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-@p3-1))
set @Total=convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))
if(@IdGeneral=0)
begin
insert into CajaGeneral values(GETDATE(),@Usuario,@Ingresos,@Salidas,@Total)
set @Codigo=(select @@IDENTITY)
update CajaPincipal
set IdGeneral=@Codigo
where IdGeneral=0
end
else
begin
update CajaGeneral
set FechaCierre=GETDATE(),Ingresos=@Ingresos,Salidas=@Salidas,Total=@Total,Usuario=@Usuario
where IdGeneral=@IdGeneral
end
begin
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarGR]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarGR]
@GuiaId numeric(38),
@NotaId numeric(38)
as
begin
begin
insert into GuiaRelacion values(@GuiaId,@NotaId)
end
begin
update GuiaRemision
set GuiaEstado='CANJEADO'
where GuiaId=@GuiaId
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarKardexB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarKardexB]
	 @IdProducto numeric(20),
	 @KardexMotivo  varchar(60),
	 @KardexDocumento varchar(60),
	 @CantidadIngreso decimal(18, 2),
	 @CantidadSalida decimal(18, 2),
	 @PrecioCosto decimal(18,4),
	 @Usuario varchar(60),
	 @Aviso char(1)
	as
	begin
	begin
	declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2),@Concepto varchar(40)
	set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)
	if @Aviso='S'
	begin
	set @StockFinal=@IniciaStock-@CantidadSalida
	set @concepto='SALIDA'
	end
	else if @Aviso='I'
	begin
	set @StockFinal=@IniciaStock+@CantidadIngreso
	set @concepto='INGRESO'
	end
	else
	begin
	set @StockFinal=@IniciaStock
	set @concepto='INGRESO'
	end
	insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,
	@CantidadIngreso,@CantidadSalida,@PrecioCosto,@StockFinal,@Concepto,@Usuario)
	end
	begin
	if @Aviso='S'
	begin
	update producto 
	set  ProductoCantidad =ProductoCantidad - @CantidadSalida
	where IDProducto=@IdProducto
	end
	else if @Aviso='I'
	begin
	update producto
	set ProductoCantidad =ProductoCantidad + @CantidadIngreso
	where IDProducto=@IdProducto
	end
	end
	end
GO
/****** Object:  StoredProcedure [dbo].[insertarKardexCompras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarKardexCompras]  
  @IdProducto numeric(20),  
  @KardexMotivo  varchar(60),  
  @KardexDocumento varchar(60),  
  @CantidadIngreso decimal(18, 2),  
  @CantidadSalida decimal(18, 2),  
  @PrecioCosto decimal(18,4),  
  @Usuario varchar(60),  
  @Aviso char(1)  
 as  
 begin
    Declare @AplicaINV nvarchar(1) 
    
	set @AplicaINV=(select top 1 p.AplicaINV
	from Producto p (nolock) 
	where p.IdProducto=@IdProducto)
if(@AplicaINV='S')
begin  	
 begin  
	 declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2),@Concepto varchar(40)  
	 set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)  
	 if @Aviso='S'  
	 begin  
		 set @StockFinal=@IniciaStock-@CantidadSalida  
		 set @concepto='SALIDA'  
	 end  
	 else if @Aviso='I'  
	 begin  
		 set @StockFinal=@IniciaStock+@CantidadIngreso  
		 set @concepto='INGRESO'  
	 end  
	 else  
	 begin  
		 set @StockFinal=@IniciaStock  
		 set @concepto='INGRESO'  
	 end 
	  
	 insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,  
	 @CantidadIngreso,@CantidadSalida,@PrecioCosto,@StockFinal,@Concepto,@Usuario)  
 end  
 begin  
 if @Aviso='S'  
 begin  
	 update producto   
	 set  ProductoCantidad =ProductoCantidad - @CantidadSalida  
	 where IDProducto=@IdProducto  
	 end  
	 else if @Aviso='I'  
	 begin  
	 update producto  
	 set ProductoCantidad =ProductoCantidad + @CantidadIngreso  
	 where IDProducto=@IdProducto  
 end  
 end  
 end
 end
GO
/****** Object:  StoredProcedure [dbo].[insertarLetra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarLetra]
@ProveedorId numeric(38),
@LetraFechaReg datetime,
@LetraFechaGiro date,
@LetraMoneda varchar(40),
@LetraSaldo decimal(18,2),
@LetraTotal decimal(18,2),
@letraUsuario varchar(60),
@LetraEstado varchar(60),
@CompaniaId INT 
as
begin
insert into Letra values(@ProveedorId,@LetraFechaReg,@LetraFechaGiro,
@LetraMoneda,@LetraSaldo,@LetraTotal,@letraUsuario,@LetraEstado,@CompaniaId)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarLiquida]
@LiquidacionNumero varchar(80),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
insert into Liquidacion values(@LiquidacionNumero,
@LiquidacionRegistro,@LiquidacionFecha,@LiquidacionDescripcion,
@LiquidacionCambio,@LiquidaEfectivoSol,@LiquidaDepositoSol,
@LiquidaTotalSol,@LiquidaEfectivoDol,@LiquidaDepositoDol,
@LiquidaTotalDol,@LiquidaUsuario)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarRenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insertarRenta] 
@Data varchar(max)
as
declare @existe int
		Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,
		@pos5 int,@pos6 int,@pos7 int,@pos8 int,@pos9 int,
		@pos10 int,@pos11 int,@pos12 int,@pos13 int,@pos14 int,
		@pos15 int,@pos16 int,@pos17 int,@pos18 int
Declare @RentaId numeric(38),@CompaniaId int,@RentaUsuario varchar(80),
		@RentaANNO int,@RentaMes int,@IGV decimal(18,2),@Renta decimal(18,2),
		@SaldoIGV decimal(18,2),@SaldoRenta decimal(18,2),@InteresIgv decimal(18,2),
		@InteresRenta decimal(18,2),@TributoIgv decimal(18,2),@TributoRenta decimal(18,2),
		@FormaPago bit,@FechaCancelacion datetime,@EntidadBancaria varchar(80),
		@NroOperacion varchar(80),@PagoTotal decimal(18,2)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @RentaId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @CompaniaId= convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @RentaUsuario=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @RentaANNO=convert(int,SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @RentaMes=convert(int,SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @IGV=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
Set @pos7 =CharIndex('|',@Data,@pos6+1)
Set @Renta=convert(decimal(18,2),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))
Set @pos8 =CharIndex('|',@Data,@pos7+1)
Set @SaldoIGV=convert(decimal(18,2),SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1))
Set @pos9 =CharIndex('|',@Data,@pos8+1)
Set @SaldoRenta=convert(decimal(18,2),SUBSTRING(@Data,@pos8+1,@pos9-@pos8-1))
Set @pos10=CharIndex('|',@Data,@pos9+1)
Set @InteresIgv=convert(decimal(18,2),SUBSTRING(@Data,@pos9+1,@pos10-@pos9-1))
Set @pos11=CharIndex('|',@Data,@pos10+1)
Set @InteresRenta=convert(decimal(18,2),SUBSTRING(@Data,@pos10+1,@pos11-@pos10-1))
Set @pos12=CharIndex('|',@Data,@pos11+1)
Set @TributoIgv=convert(decimal(18,2),SUBSTRING(@Data,@pos11+1,@pos12-@pos11-1))
Set @pos13=CharIndex('|',@Data,@pos12+1)
Set @TributoRenta=convert(decimal(18,2),SUBSTRING(@Data,@pos12+1,@pos13-@pos12-1))
Set @pos14=CharIndex('|',@Data,@pos13+1)
Set @FormaPago=convert(bit,SUBSTRING(@Data,@pos13+1,@pos14-@pos13-1))
Set @pos15=CharIndex('|',@Data,@pos14+1)
Set @FechaCancelacion=convert(date,SUBSTRING(@Data,@pos14+1,@pos15-@pos14-1))
Set @pos16=CharIndex('|',@Data,@pos15+1)
Set @EntidadBancaria=SUBSTRING(@Data,@pos15+1,@pos16-@pos15-1)
Set @pos17=CharIndex('|',@Data,@pos16+1)
Set @NroOperacion=SUBSTRING(@Data,@pos16+1,@pos17-@pos16-1)
Set @pos18= Len(@Data)+1
Set @PagoTotal=convert(decimal(18,2),SUBSTRING(@Data,@pos17+1,@pos18-@pos17-1))
set @existe=(select count(RentaId)as Codigo from RentaMensual
             where CompaniaId=@CompaniaId and(RentaANNO=@RentaANNO and RentaMes=@RentaMes))
begin
if @RentaId=0
begin  
if @existe=0
begin
insert into RentaMensual values
(@CompaniaId,@RentaUsuario,
@RentaANNO,@RentaMes,@IGV,@Renta,@SaldoIGV,
@SaldoRenta,@InteresIgv,@InteresRenta,@TributoIgv,@TributoRenta,@FormaPago,@FechaCancelacion,
@EntidadBancaria,@NroOperacion,@PagoTotal
)
(select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,''))
end
else
begin
select 'existe'
end
end
else
begin
update RentaMensual
set IGV=@IGV,Renta=@Renta,SaldoIGV=@SaldoIGV,SaldoRenta=@SaldoRenta,InteresIgv=@InteresIgv,
InteresRenta=@InteresRenta,TributoIgv=@TributoIgv,TributoRenta=@TributoRenta,FormaPago=@FormaPago,
FechaCancelacion=@FechaCancelacion,EntidadBancaria=@EntidadBancaria,NroOperacion=@NroOperacion,PagoTotal=@PagoTotal
where RentaId=@RentaId
(select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertartemLetra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertartemLetra]
@CompraId numeric(38),
@ProveedorId numeric(38),
@TemporalDocumento varchar(60),
@TemporalMoneda varchar(20),
@TemporalMonto decimal(18,2),
@UsuarioId int,
@TemporalCanje varchar(80)
as
begin
insert into temporalLetra values(@CompraId,@ProveedorId,@TemporalDocumento,@TemporalMoneda,
@TemporalMonto,@UsuarioId,@TemporalCanje)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempCompra]
@UsuarioID int,
@IdProducto numeric(20),
@DetalleCodigo varchar(80),
@Descripcion varchar(255),
@DetalleUM   varchar(60),
@DetalleCantidad decimal(18,2),
@PrecioCosto  decimal(18,4),
@DetalleImporte decimal(18,2),
@DetalleDescuento decimal(18,4),
@DetalleEstado varchar(40),
@ValorUM decimal(18,4)
as
begin
insert into TemporalCompra values(@UsuarioID,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImporte,
@DetalleDescuento,@DetalleEstado,@ValorUM)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempCompraB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempCompraB]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
        @p3 int,@p4 int,
        @p5 int,@p6 int,
        @p7 int,@p8 int,
        @p9 int,@p10 int,
        @p11 int
Declare @UsuarioID int,@IdProducto numeric(20),
		@DetalleCodigo varchar(80),@Descripcion varchar(255),
		@DetalleUM varchar(60),@DetalleCantidad decimal(18,2),
		@PrecioCosto  decimal(18,4),@DetalleImporte decimal(18,2),
		@DetalleDescuento decimal(18,4),@DetalleEstado varchar(40),
		@ValorUM decimal(18,4)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3= CharIndex('|',@Data,@p2+1)
Set @p4= CharIndex('|',@Data,@p3+1)
Set @p5= CharIndex('|',@Data,@p4+1)
Set @p6= CharIndex('|',@Data,@p5+1)
Set @p7= CharIndex('|',@Data,@p6+1)
Set @p8= CharIndex('|',@Data,@p7+1)
Set @p9= CharIndex('|',@Data,@p8+1)
Set @p10= CharIndex('|',@Data,@p9+1)
Set @p11 = Len(@Data)+1
Set @UsuarioID =convert(int,SUBSTRING(@Data,1,@p1-1))
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @DetalleCodigo=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
Set @Descripcion=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
Set @DetalleUM=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Data,@p5+1,@p6-@p5-1))
Set @PrecioCosto=convert(decimal(18,4),SUBSTRING(@Data,@p6+1,@p7-@p6-1))
Set @DetalleImporte=convert(decimal(18,2),SUBSTRING(@Data,@p7+1,@p8-@p7-1))
Set @DetalleDescuento=convert(decimal(18,4),SUBSTRING(@Data,@p8+1,@p9-@p8-1))
Set @DetalleEstado=SUBSTRING(@Data,@p9+1,@p10-@p9-1)
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@p10+1,@p11-@p10-1))
insert into TemporalCompra values(@UsuarioID,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImporte,
@DetalleDescuento,@DetalleEstado,@ValorUM)
select
isnull((select STUFF ((select '¬'+convert(varchar,t.TemporalId)+'|'+convert(varchar,t.IdProducto)+'|'+
t.DetalleCodigo+'|'+t.Descripcion+'|'+t.DetalleUM+'|'+
CONVERT(VarChar(50),cast(t.DetalleCantidad as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)+'|'+convert(varchar,t.DetalleDescuento)
+'|'+convert(varchar,t.DetalleImporte)+'|'+CONVERT(varchar,t.ValorUM)+'|'+
t.DetalleEstado
from TemporalCompra t 
inner join Producto p 
on p.IdProducto=t.IdProducto 
where t.UsuarioID=@UsuarioID
order by t.TemporalId asc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempoGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempoGuia]
@UsuarioID int,
@IdProducto numeric(20),
@cantidad decimal(18,2),
@precioventa decimal(18,2),
@importe decimal(18,2),
@Concepto varchar(60),
@CantidadSaldo decimal(18,2),
@ClienteId numeric(20),
@DetalleId numeric(38),
@DetalleUM varchar(40),
@ValorUM decimal(18,4)
as
begin
insert into TemporalGuia values(@UsuarioID,@IdProducto,@cantidad,
@precioventa,@importe,@Concepto,@CantidadSaldo,@ClienteId,@DetalleId,@DetalleUM,@ValorUM)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempoVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempoVenta]    
@Data varchar(max)    
as    
begin    
Declare @pos1 int,@pos2 int,    
  @pos3 int,@pos4 int,    
  @pos5 int,@pos6 int,    
  @pos7 int,@pos8 int    
Declare @UsuarioID int,    
  @IdProducto numeric(20),    
  @cantidad decimal(18,2),    
  @precioventa decimal(18,2),    
  @importe decimal(18,2),    
  @ValorUM decimal(18,4),    
  @Unidad varchar(40),    
  @Codigo varchar(300),    
  @Aviso varchar(max),    
  @Stock decimal(18,2),    
  @Existe int    
Set @Data = LTRIM(RTrim(@Data))    
Set @pos1 = CharIndex('|',@Data,0)    
Set @pos2 = CharIndex('|',@Data,@pos1+1)    
Set @pos3 = CharIndex('|',@Data,@pos2+1)    
Set @pos4 = CharIndex('|',@Data,@pos3+1)    
Set @pos5= CharIndex('|',@Data,@pos4+1)    
Set @pos6= CharIndex('|',@Data,@pos5+1)    
Set @pos7= CharIndex('|',@Data,@pos6+1)    
Set @pos8=Len(@Data)+1    
Set @UsuarioID=convert(int,SUBSTRING(@Data,1,@pos1-1))    
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))    
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))    
Set @precioventa=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))    
Set @importe=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))    
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))    
Set @Unidad=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)    
Set @Codigo=SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1)    
insert into TemporalVenta values(@UsuarioID,@IdProducto,@cantidad,@precioventa,@importe,    
@ValorUM,@Unidad,'E')    
set @Aviso=isnull((select top 1 convert(varchar,p.ProductoCantidad)     
from Producto p (nolock)     
where p.IdProducto=@IdProducto and p.ProductoUM=@Unidad),'false')    
if(@Aviso='false')    
begin    
set @Stock=isnull((select top 1 cast((p.ProductoCantidad/u.ValorUM) as decimal(18,2))   
from Producto p (nolock)   
inner join UnidadMedida u (nolock)    
on p.IdProducto=u.IdProducto    
where p.IdProducto=@IdProducto and u.UMDescripcion=@Unidad),0)    
end    
else    
begin    
set @Stock=@Aviso    
end    
if(@Cantidad>@Stock)    
begin    
SET @Existe=ISNULL((select top 1 s.IdProducto   
from Stock s (nolock)    
where s.IdProducto=@IdProducto and s.Estado='BUENO'),0)   
if(@Existe=0)select'true'    
else select 'A'     
end    
else    
begin    
select 'true'    
end    
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTemUMGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTemUMGuia]
@Data varchar(max)
as
	Declare @pos1 int
	Declare @pos2 int
	Declare @pos3 int
	Declare @pos4 int
	Declare @pos5 int
	Declare @pos6 int
	Declare @pos7 int
	Declare @pos8 int
Declare 
@UsuarioID int,
@IdProducto numeric(20),
@cantidad decimal(18,2),
@precioventa decimal(18,2),
@importe decimal(18,2),
@Concepto varchar(60),
@DetalleUM varchar(40),
@ValorUM decimal(18,4)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @UsuarioID=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @precioventa=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @importe=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @Concepto=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)
Set @pos7=CharIndex('|',@Data,@pos6+1)
Set @DetalleUM=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)
Set @pos8= Len(@Data)+1
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1))
IF EXISTS(select t.DetalleUM from TemporalGuia t where (t.IdProducto=@IdProducto and t.DetalleUM=@DetalleUM)and t.UsuarioID=@UsuarioID)
begin
select 'UM'
end
else
begin
insert into TemporalGuia values(@UsuarioID,@IdProducto,@cantidad,
@precioventa,@importe,@Concepto,0,0,0,@DetalleUM,@ValorUM)
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[InsertarUM]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InsertarUM]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
Declare @pos7 int
declare @IdUm int,
@IdProducto numeric(20),
@UMDescripcion varchar(80),
@ValorUM decimal(18,4),
@PrecioVenta decimal(18,2),
@PrecioVentaB decimal(18,2),
@PrecioCosto decimal(18,4)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @pos7 = Len(@Data)+1
Set @IdUm =convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @IdProducto=convert(numeric,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @UMDescripcion=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @PrecioVenta=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @PrecioVentaB=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
Set @PrecioCosto=convert(decimal(18,4),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))
declare @CostoPro decimal(18,4),@costoTotal decimal(18,4)
set @CostoPro=(select top 1 p.ProductoCosto from Producto p where p.IdProducto=@IdProducto)
set @costoTotal=@ValorUM * @CostoPro
if @IdUm=0
begin
IF EXISTS(select u.UMDescripcion from UnidadMedida u where u.IdProducto=@IdProducto and u.UMDescripcion=@UMDescripcion)
select 'UM'
else IF EXISTS(select u.ValorUM from UnidadMedida u where u.IdProducto=@IdProducto and u.ValorUM=@ValorUM)
select 'VALOR'
else
begin
insert into UnidadMedida values(@IdProducto,@UMDescripcion,@ValorUM,@PrecioVenta,@PrecioVentaB,@costoTotal)
(select STUFF ((select '¬'+convert(varchar,m.IdUm)+'|'+CONVERT(varchar,m.IdProducto)+'|'+m.UMDescripcion+'|'+
CONVERT(VarChar(50),cast(m.ValorUM as money ),2)+'|'+CONVERT(VarChar(50),cast(m.PrecioVenta as money ), 1)+'|'+CONVERT(VarChar(50), cast(m.PrecioVentaB as money ), 1)+'|'+
CONVERT(varchar(50),m.PrecioCosto)
from UnidadMedida m
where m.IdProducto=@IdProducto
order by m.ValorUM asc
for xml path('')),1,1,''))
end
end
else
begin
update UnidadMedida
set PrecioVenta=@PrecioVenta,PrecioVentaB=@PrecioVentaB,PrecioCosto=@PrecioCosto
where IdUm=@IdUm
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTemLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTemLiVenta]
@DocuId numeric(38),
@NotaId numeric(38),
@UsuarioId int,
@SaldoDocu decimal(18,2),
@TipoCambio decimal(18,3),
@EfectivoSoles decimal(18,2),
@EfectivoDolar decimal(18,2),
@DepositoSoles decimal(18,2),
@DepositoDolar decimal(18,2),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18,2),
@TemporalFecha varchar(60)
as
begin
insert into TemporalLiVenta values(@DocuId,@NotaId,@UsuarioId,@SaldoDocu,@TipoCambio,@EfectivoSoles,
@EfectivoDolar,@DepositoSoles,@DepositoDolar,@EntidadBanco,@NroOperacion,@AcuentaGeneral,
@TemporalFecha)
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTempoLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTempoLiquida]
@IdDeuda numeric(38, 0),
@Numero varchar(60),
@Proveedor varchar(255),
@SaldoDocu decimal(18, 2),
@Moneda varchar(20),
@TipoCambio decimal(18, 3),
@EfectivoSoles decimal(18, 2),
@EfectivoDolar decimal(18, 2),
@DepositoSoles decimal(18, 2),
@DepositoDolar decimal(18, 2),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18, 2),
@TemporalFecha varchar(60),
@UsuarioId int,
@Concepto varchar(40)
as
begin
insert into TemporalLiquida values
(@IdDeuda,@Numero,@Proveedor,@SaldoDocu,@Moneda,@TipoCambio,
@EfectivoSoles,@EfectivoDolar,@DepositoSoles,@DepositoDolar,
@EntidadBanco,@NroOperacion,@AcuentaGeneral,@TemporalFecha,@UsuarioId,@Concepto)
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTipoCambio]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTipoCambio]
@Data varchar(max)
as
begin
	Declare @pos1 int
	Declare @pos2 int
	Declare @pos3 int
	Declare @pos4 int
	Declare @pos5 int
declare @IdTipo numeric(38),@TipoFecha date,@TipoCompra decimal(18,3),
@TipoVenta decimal(18,3),@TipoEmpresa decimal(18,3)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @pos5= Len(@Data)+1
Set @IdTipo =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @TipoFecha=convert(date,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @TipoCompra=convert(decimal(18,3),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @TipoVenta=convert(decimal(18,3),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @TipoEmpresa=convert(decimal(18,3),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
if(@IdTipo=0)
begin
IF EXISTS(select * from TipoCambio where TipoFecha=@TipoFecha)
	select 'false'
else
begin
	insert TipoCambio values(@TipoFecha,@TipoCompra,@TipoVenta,@TipoEmpresa)
	update Producto
	set ProductoCosto=ProductoCostoDolar*@TipoEmpresa,ProductoTipoCambio=@TipoEmpresa
	where AplicaTC='S'
	select 'true'
end
end
else
begin
Declare @UltimoId numeric(38)
set @UltimoId=(select top 1 IdTipo from TipoCambio order by IdTipo desc)
update TipoCambio
set TipoFecha=@TipoFecha,TipoCompra=@TipoCompra,TipoVenta=@TipoVenta,TipoEmpresa=@TipoEmpresa
where IdTipo=@IdTipo
if(@UltimoId=@IdTipo)
begin
update Producto
set ProductoCosto=ProductoCostoDolar*@TipoEmpresa,ProductoTipoCambio=@TipoEmpresa
where AplicaTC='S'
end
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[KardeProveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[KardeProveedor] 
@IdProducto numeric(20),
@fechainicio date,
@fechafin date
as
begin
select p.ProveedorId,p.ProveedorRazon,(Convert(char(10),c.CompraEmision,103)) as FechaEmision,
substring(t.TipoDescripcion,1,1)+'-C  '+c.CompraSerie+'-'+c.CompraNumero as Numero,
c.CompraTipoCambio as TipoCambio,CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)as Cantidad,
substring(d.DetalleUM,1,3) as UM,	
case when(CompraMoneda='DOLARES')then 
case when(CompraTipoIgv='DISGREGADO')then
cast((((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)* c.CompraTipoCambio)*1.18)- d.DescuentoB) as decimal(18,4))
else
cast(((cast(((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)as decimal(18,4))-d.DescuentoB)*c.CompraTipoCambio) as decimal(18,4))
end
else
case when(CompraTipoIgv='DISGREGADO') then
cast(((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)*1.18)-d.DescuentoB) as decimal(18,4))
else 
cast((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)-d.DescuentoB)as decimal(18,4)) 
end end as CostoSoles,
------
case when(CompraMoneda='DOLARES')then 
case when(CompraTipoIgv='DISGREGADO')then
cast(((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)*1.18)-d.DescuentoB) as decimal(18,4))
else 
cast((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)-d.DescuentoB) as decimal(18,4))
end
else 
case when(CompraTipoIgv='DISGREGADO')then 
cast((((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)/c.CompraTipoCambio)*1.18)-d.DescuentoB) as decimal(18,4))
else 
cast(((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)/c.CompraTipoCambio)-d.DescuentoB) as decimal(18,4))
end end as CostoDolar
from DetalleCompra d
inner join Compras c
on c.CompraId=d.CompraId
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where(Convert(char(10),c.CompraEmision,103) BETWEEN @fechainicio AND @fechafin) and d.IdProducto=@IdProducto
order by 1 desc,c.CompraEmision desc
end
GO
/****** Object:  StoredProcedure [dbo].[kardexCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[kardexCompra]   
@ProveedorId numeric(38),  
@Asociado varchar(max),  
@CompraId numeric(38)  
as  
begin  
select (Convert(char(10),c.CompraEmision,103)) as FechaPago,c.CompraId,  
case when (c.CompraEstado='DESCUENTO INTERNO')then  
'NI '+c.CompraSerie+'-'+c.CompraNumero else   
'NC '+c.CompraSerie+'-'+c.CompraNumero end as Documento,c.CompraMoneda as Moneda,  
CONVERT(VarChar(max), cast(f.Acuenta as money ), 1)as Acuenta,c.CompraTotal,  
c.CompraEstado as Concepto  
from Compras c 
inner join FacturasNC f
on f.CompraId=c.CompraId 
where (c.ProveedorId=@ProveedorId and f.Factura=@Asociado) --and c.CompraEstado<>'DESCUENTO INTERNO'  
union all(  
select d.FechaPago,d.CompraId,'LQ '+l.LiquidacionNumero as Documento,c.CompraMoneda as Moneda,  
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1)as Acuenta,d.AcuentaGeneral,'LIQUIDACION'  
from DetalleLiquida d  
inner join Liquidacion l  
on l.LiquidacionId=d.LiquidacionId  
inner join Compras c  
on c.CompraId=d.CompraId  
where c.CompraId=@CompraId)  
union all  
(  
select (Convert(char(10),l.LetraFechaGiro,103)) as FechaPago,  
d.CompraId,'LT '+dl.LetraCanje as Documento,l.LetraMoneda as Moneda,  
CONVERT(VarChar(max), cast(dl.DetalleMonto as money ), 1)as Acuenta,  
dl.DetalleMonto,'LETRA'  
from DocumentoCanje d  
inner join Letra l  
on l.LetraId=d.LetraId  
inner join DetalleLetra dl  
on dl.LetraId=l.LetraId  
where d.CompraId=@CompraId  
)  
order by 6 desc  
end
GO
/****** Object:  StoredProcedure [dbo].[Ld_listaAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Ld_listaAlmacen]
as
begin
select 
'Id|Almacen|Departamento|Provincia|Distrito|Direccion|Estado¬80|435|100|100|100|100|100¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre+'|'+a.AlmacenDepartamento+'|'+
a.AlmacenProvincia+'|'+a.AlmacenDistrito+'|'+a.AlmacenDireccion+'|'+a.AlmacenEstado
from Almacen a
order by AlmacenId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[ldBloques]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ldBloques]
as
begin
declare @fechaReferencia date
set @fechaReferencia=(select top 1 n.NotaFecha from NotaPedido n
where (n.NotaCondicion='ALCONTADO' and n.NotaEntrega='INMEDIATA')and
(n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and(((n.NotaEstado<>'CANCELADO' and n.NotaAcuenta<=0) AND n.NotaDocu <>'PROFORMA'))))
group by n.NotaFecha
order by n.NotaFecha asc)
select
'NotaId|Usuario|FechaEmision|Documento|ClienteRazon|Saldo|Total¬100|150|150|135|400|120|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,n.NotaId)+'|'+n.NotaUsuario+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+c.ClienteRazon+'|'+
CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)+'|'+
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)
from NotaPedido n
inner join Cliente c
on c.ClienteId=n.ClienteId
where convert(date,n.NotaFecha)=@fechaReferencia and(n.NotaCondicion='ALCONTADO' and n.NotaEntrega='INMEDIATA')and
(n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and(((n.NotaEstado<>'CANCELADO' and n.NotaAcuenta<=0) AND n.NotaDocu <>'PROFORMA'))))
order by n.NotaId asc
FOR XML path ('')),1,1,'')),'~')+'['+
'NotaId|FechaEmision|Documento|Vendedor|IdPro|Cantidad|UM|Descripcion|PrecioVenta|PrecioCosto|Importe|ValorUM¬95|153|105|150|70|100|60|330|100|100|110|100¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF(( select '¬'+ convert(varchar,d.NotaId)+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+n.NotaUsuario+'|'+
convert(varchar,d.IdProducto)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+
d.DetalleUm+'|'+d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
CONVERT(varchar,d.ValorUM)
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
where convert(date,n.NotaFecha)=@fechaReferencia and(n.NotaCondicion='ALCONTADO' and n.NotaEntrega='INMEDIATA')and
(n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and(((n.NotaEstado<>'CANCELADO' and n.NotaAcuenta<=0) AND n.NotaDocu <>'PROFORMA'))))
order by n.NotaId asc
FOR XML PATH('')), 1, 1, '')),'~')+'['+
isnull((select STUFF((select '¬'+CONVERT(varchar,c.CajaId)
from Caja c
where CajaEstado='ACTIVO'
FOR XML path ('')),1,1,'')),'0')+'['+
isnull((select top 15 STUFF((select top 15 '¬'+convert(varchar,b.BloqueId)+'|'+
(IsNull(convert(varchar,b.BloqueFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,b.BloqueFecha,114),1,8),''))
from Bloque b
order by b.BloqueId desc
FOR XML path ('')),1,1,'')),'')
end
GO
/****** Object:  StoredProcedure [dbo].[LDdocumentos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LDdocumentos]  
@Mes int,  
@ANNO int  
as  
begin

Declare @count int

set  @count=(select COUNT(*) from  DocumentoVenta
where month(DocuEmision)=@Mes and year(DocuEmision)=@ANNO 
and MensajeSunat like '%|%')

if(@count>0)
begin
update DocumentoVenta
set MensajeSunat=replace(MensajeSunat,'|','')
where MensajeSunat like '%|%'
end

select 'Compania|Fecha|Documento|NroDoc|Cliente|RUC|DNI|SubTotal|IGV|ICBPER|Total|Usuario|Estado|Referencia|Codigo|Mensaje¬65|85|90|110|250|80|80|110|110|95|110|150|150|110|0|0¬'+  
(select STUFF((select '¬'+convert(varchar,d.CompaniaId)  
+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+  
d.DocuDocumento+'|'+  
convert(varchar,d.DocuSerie+'-'+d.DocuNumero)+'|'+  
c.ClienteRazon+'|'+isnull(c.ClienteRuc,'')+'|'+isnull(c.ClienteDni,'')+'|'+  
case when(d.TipoCodigo='07')then   
'-'+CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)  
else  
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)end+'|'+  
case when (d.TipoCodigo='07')then  
'-'+CONVERT(VarChar(50), cast(d.DocuIgv as money), 1)  
else  
CONVERT(VarChar(50), cast(d.DocuIgv as money), 1)end+'|'+  
case when (d.TipoCodigo='07')then  
'-'+CONVERT(VarChar(50), cast(d.ICBPER as money), 1)  
else  
CONVERT(VarChar(50), cast(d.ICBPER as money), 1)end+'|'+  
case when (d.TipoCodigo='07')then  
'-'+CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)  
else  
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)end+'|'+  
d.DocuUsuario+'|'+d.DocuEstado+'|'+d.DocuNroGuia+'|'+  
CodigoSunat+'|'+MensajeSunat  
from DocumentoVenta d  
inner join Cliente c  
on c.ClienteId=d.ClienteId  
where (Month(d.DocuEmision)=@Mes and YEAR(d.DocuEmision)=@ANNO) and (d.DocuDocumento<>'NOTA PEDIDO' and d.DocuDocumento<>'PROFORMA V' and d.DocuDocumento<>'PROFORMA')  
order by d.DocuEmision asc,d.DocuSerie+'-'+d.DocuNumero asc  
FOR XML PATH('')), 1, 1, ''))  
end
GO
/****** Object:  StoredProcedure [dbo].[LdGanancia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LdGanancia] 
@NotaId numeric(38)
as
begin
declare @Estado varchar(80)
set @Estado=(select top 1 n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)
select 
'FechaEmision|Vendedor|Descripcion|Cantidad|UM|PrecioUni|PreCosto|GXUnidad|Importe|Ganancia¬150|150|385|110|70|110|110|110|0|120¬'+
(select STUFF((select '¬'+(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaUsuario+'|'+d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast((d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+
CONVERT(VarChar(50), cast((d.DetallePrecio-d.DetalleCosto) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((d.DetalleImporte) as money ), 1)+'|'+
CONVERT(VarChar(50), cast(((d.DetallePrecio-d.DetalleCosto)* d.DetalleCantidad) as money ), 1)
from DetallePedido d (noLOCK) 
inner join NotaPedido n (noLOCK)
on n.NotaId=d.NotaId
where d.NotaId=@NotaId
order by d.DetalleId asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[LDrptCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[LDrptCompra]
@Mes int,
@ANNO int
as
begin
select 'Compania|FechaEmision|Documento|RUC|RazonSocial|Tipo|BaseImp|IGV|Total|Moneda|TipoSunat|Monto|Referencia¬
68|95|110|90|330|45|105|105|105|85|75|105|110¬'+
(select stuff((select '¬'+CONVERT(varchar,c.CompaniaId)+'|'+(Convert(char(10),c.CompraEmision,103))+'|'+
(c.CompraSerie+'-'+c.CompraNumero)+'|'+
p.ProveedorRuc+'|'+p.ProveedorRazon+'|'+c.TipoCodigo+'|'+
case when c.CompraMoneda='DOLARES' THEN
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else
 CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)end
else  
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
else
CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)end
end+'|'+
case when c.CompraMoneda='DOLARES' then
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else
 CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)end
else 
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
else
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)end
end+'|'+
case when c.CompraMoneda='DOLARES' then
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1) end
else 
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
else
CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)end
end+'|'+
c.CompraMoneda+'|'+convert(varchar,c.CompraTipoSunat)+'|'+
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
else
CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end+'|'+CompraAsociado
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
where (Month(c.CompraComputo)=@Mes and YEAR(c.CompraComputo)=@ANNO) and(c.TipoCodigo='01' or c.TipoCodigo='07' or c.TipoCodigo='08')
order by c.CompraEmision asc
FOR XML PATH('')), 1, 1, ''))
end
GO
/****** Object:  StoredProcedure [dbo].[ldTraerDetalle]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ldTraerDetalle]
@Data varchar(max)
as
begin
declare @p0 int, 
        @p1 int
declare @IdProducto numeric(20),
		@NotaId numeric(38),
		@Ganancia decimal(18,2)
		set @p0 = CharIndex('|',@Data,0)
        Set @p1 = Len(@Data)+1
	Set @IdProducto=Convert(numeric(20),SUBSTRING(@Data,1,@p0-1))
	Set @NotaId= Convert(numeric(38),SUBSTRING(@Data,@p0+1,@p1-@p0-1))
	set @Ganancia=(select (d.DetallePrecio - d.DetalleCosto) 
	from DetallePedido d where d.IdProducto=@IdProducto and d.NotaId=@NotaId)
begin
	update DetallePedido 
	set DetalleCantidad=DetalleCantidad + 1,
	DetalleImporte=((DetalleCantidad + 1)* DetallePrecio) 
	where IdProducto=@IdProducto and NotaId=@NotaId
	update NotaPedido
	set NotaGanancia=NotaGanancia+@Ganancia
	where NotaId=@NotaId
	select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[LetrasVencidas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LetrasVencidas]       
as      
begin    
select    
'RazonSocial|Documento|SaldoDoc|Vencimiento|FinVencimiento|Estado¬90|90|90|90|90|90¬String|String|String|String|String|String¬'+    
isnull((select STUFF((select '¬'+    
p.ProveedorRazon+'|'+    
'LT '+d.LetraCanje+'|'+      
substring(l.LetraMoneda,1,1)+'/  '+CONVERT(VarChar(50),cast(d.DetalleSaldo as money ), 1)+'|'+      
(Convert(char(10),d.LetraVencimiento,103))+'|'+      
convert(char(10),(dateadd(DAY,6,d.LetraVencimiento)),103)+'|'+      
case when ((dateadd(DAY,6,d.LetraVencimiento))<= CONVERT(date,GETDATE())) then      
'VENCIDO'      
else      
case when (CONVERT(date,GETDATE())>=(d.LetraVencimiento)) then      
'POR VENCER'      
else      
'PENDIENTE'      
end end      
from DetalleLetra d      
inner join Letra l      
on l.LetraId=d.LetraId      
inner join Proveedor p      
on p.ProveedorId=l.ProveedorId      
where (d.DetalleEstado<>'TOTALMENTE PAGADO') and ((dateadd(DAY,-6,d.LetraVencimiento))<= CONVERT(date,GETDATE()))    
FOR XML path ('')),1,1,'')),'~') +'¬'+     
isnull((select STUFF((select '¬'+    
p.ProveedorRazon+'|'+    
substring(t.TipoDescripcion,1,1)+'C '+C.CompraSerie+' '+c.CompraNumero+'|'+      
substring(c.CompraMoneda,1,1)+'/  '+CONVERT(VarChar(50),cast(c.CompraSaldo as money ), 1)+'|'+    
(Convert(char(10),c.CompraFechaPago,103))+'|'+    
(Convert(char(10),c.CompraFechaPago,103))+'|'+      
case when (CONVERT(date,GETDATE())>=(c.CompraFechaPago)) then      
'VENCIDO'      
else      
case when ((dateadd(DAY,-2,c.CompraFechaPago))<= CONVERT(date,GETDATE())) then      
'POR VENCER'      
else      
'PENDIENTE'      
end end       
from Compras c      
inner join Proveedor p      
on c.ProveedorId=p.ProveedorId      
inner join TipoComprobante t      
on t.TipoCodigo=c.TipoCodigo      
where c.CompraEstado='PENDIENTE DE PAGO' and ((dateadd(DAY,-6,c.CompraFechaPago))<= CONVERT(date,GETDATE()))    
FOR XML path ('')),1,1,'')),'~')+'['+
'Descripcion|Stock|Unidad|Costo¬400|105|100|100¬String|String|String|String¬'+          
isnull((select STUFF((select'¬'+p.ProductoNombre+' '+p.ProductoMarca+'|'+          
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1)+'|'+          
p.ProductoUM+'|'+CONVERT(VarChar(50), cast(p.ProductoCosto as money ), 1)          
from Producto p          
inner join Sublinea s          
on s.IdSubLinea=p.IdSubLinea          
where p.ProductoEstado='BUENO'and p.ProductoCantidad < = p.ValorCritico and p.AplicaINV='S'       
order by s.NombreSublinea,p.ProductoNombre asc          
for xml path('')),1,1,'')),'~')       
end
GO
/****** Object:  StoredProcedure [dbo].[LetrasVencidasR]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[LetrasVencidasR]
as
begin
select Row_number() over(order by d.LetraVencimiento asc)as Item,p.ProveedorRazon as RazonSocial,'LT '+d.LetraCanje as LetraCanje,
l.LetraMoneda as Moneda,CONVERT(VarChar(50),cast(d.DetalleSaldo as money ), 1) as SaldoDoc,
(Convert(char(10),d.LetraVencimiento,103)) as Vencimiento,
convert(char(10),(dateadd(DAY,6,d.LetraVencimiento)),103) as FinVencimiento,
case when ((dateadd(DAY,6,d.LetraVencimiento))<= CONVERT(date,GETDATE())) then
'VENCIDO'
else
case when ((dateadd(DAY,-6,d.LetraVencimiento))<= CONVERT(date,GETDATE())) then
'POR VENCER'
else 
'PENDIENTE'
end end as Estado
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where (d.DetalleEstado<>'TOTALMENTE PAGADO')
order by d.LetraVencimiento asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaBloque]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaBloque]
@BloqueId numeric(38)
as
begin
select
'NotaId|Usuario|FechaEmision|Documento|ClienteRazon|Saldo|Total¬100|150|150|135|400|120|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,b.NotaId)+'|'+
n.NotaUsuario+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+
c.ClienteRazon+'|'+
CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)+'|'+
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)+'|'+
convert(varchar,b.BloqueId)
from DetalleBloque b
inner join NotaPedido n
on  n.NotaId=b.NotaId
inner join Cliente c
on c.ClienteId=n.ClienteId
where b.BloqueId=@BloqueId
FOR XML path ('')),1,1,'')),'~')+'['+
'NotaId|FechaEmision|Documento|Vendedor|IdPro|Cantidad|UM|Descripcion|PrecioVenta|PrecioCosto|Importe|ValorUM¬95|153|105|150|70|100|60|330|100|100|110|100¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF(( select '¬'+ convert(varchar,d.NotaId)+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+n.NotaUsuario+'|'+
convert(varchar,d.IdProducto)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+
d.DetalleUm+'|'+d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
CONVERT(varchar,d.ValorUm)
from DetalleBloque b
inner join DetallePedido d
on d.NotaId=b.NotaId
inner join NotaPedido n
on n.NotaId=d.NotaId
where b.BloqueId=@BloqueId
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaCanjeFactura]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaCanjeFactura]
as
begin
SELECT dbo.GuiaCanje.*, dbo.Compras.CompraMoneda as Moneda,(convert(varchar(50), CAST(dbo.Compras.CompraValorVenta as money), -1))as Total,
(SUBSTRING(dbo.Compras.CompraMoneda,1,1)+'/.  '+(convert(varchar(50), CAST(dbo.Compras.CompraTotal as money), -1)))as Monto,dbo.Proveedor.ProveedorRazon as Proveedor
FROM dbo.GuiaCanje INNER JOIN dbo.Compras ON dbo.GuiaCanje.CompraId = dbo.Compras.CompraId inner join dbo.Proveedor on dbo.Proveedor.ProveedorId=dbo.Compras.ProveedorId 
where year(dbo.GuiaCanje.CanjeFecha)=YEAR(GETDATE())
order by dbo.GuiaCanje.CanjeId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaCompraComputo]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaCompraComputo]  
@f1 date,
@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat,CompraConcepto as Concepto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where(c.TipoCodigo<>'07' and c.TipoCodigo<>'08' and c.TipoCodigo<>'101')and(Convert(char(10),c.CompraComputo, 103) BETWEEN @f1 AND @f2)
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaCompraEmision]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaCompraEmision] 
@f1 date,
@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat,CompraConcepto as Concepto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where(c.TipoCodigo<>'07' and c.TipoCodigo<>'08' and c.TipoCodigo<>'101')and(Convert(char(10),c.CompraEmision, 103) BETWEEN @f1 AND @f2)
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetaGeneral]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetaGeneral] 
@IdGeneral numeric(38)
as
select
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Referencia|GastoId¬90|100|80|136|212|120|100|100|100¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=@IdGeneral
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Referencia|GastoId¬90|100|80|135|290|125|100|100|100¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.Referencia+'|'+c.GastoId
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=@IdGeneral
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[listaDetaliquiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetaliquiVenta] @LiquidacionId numeric(38)
as
begin
select d.DetalleId,d.LiquidacionId,d.NotaId as DocuId,
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end Numero,
c.ClienteRazon,CONVERT(VarChar(50), cast(d.SaldoDocu as money ), 1) as Saldo,'SOLES' as Moneda,d.EfectivoSoles,
d.EfectivoDolar,d.DepositoSoles,d.DepositoDolar,d.TipoCambio,d.EntidadBanco,d.NroOperacion,
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1) as Acuenta,
d.FechaPago,CONVERT(VarChar(50), cast(d.SaldoActual as money ), 1)as SaldoActual,d.NotaId 
from DetaLiquidaVenta d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join Cliente c
on c.ClienteId=n.ClienteId
where d.LiquidacionId=@LiquidacionId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleCompra]
@CompraId varchar(60)
as
begin
select
'DetalleId|IdProducto|DetalleCodigo|Descripcion|UM|Cantidad|PrecioCosto|Descuento|Importe|ValorUM|Estado¬100|100|100|420|80|90|100|100|110|100|100¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.IdProducto)+'|'+
d.DetalleCodigo+'|'+d.Descripcion+'|'+d.DetalleUM+'|'+CONVERT(VarChar(50),cast(d.DetalleCantidad as money ),1)+'|'+
convert(varchar,d.PrecioCosto)+'|'+convert(varchar,d.detalleDescuento)+'|'+
CONVERT(VarChar(50),cast(d.DetalleImporte as money ), 2)+'|'+CONVERT(varchar,d.ValorUM)+'|'+d.DetalleEstado
from DetalleCompra d
where d.CompraId=@CompraId
order by d.DetalleId asc
for xml path('')),1,1,'')),'~')+'['+
'IdUm|IdProducto|UNIDAD M|Valor|Costo¬100|100|100|100|100¬String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,d.PrecioCosto)
from UnidadMedida u
inner join DetalleCompra d
on d.IdProducto=u.IdProducto
where d.CompraId=@CompraId
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleDocu]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleDocu]
@DocuId numeric(38)
as
begin
Select
'Id|DocuId|IdProducto|Codigo|Cantidad|Unidad|Descripcion|Precio|Importe|Linea¬100|100|100|100|115|100|500|120|120|100¬String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.DetalleNotaId)+'|'+
convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+
d.DetalleUM+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar(50),cast(d.DetallPrecio as money),1)+'|'+
(convert(varchar(50),CAST(d.DetalleImporte as money),1))+'|'+s.NombreSublinea
from DetalleDocumento d
inner join Producto p
on p.IdProducto=d.IdProducto
inner join Sublinea s
on s.IdSubLinea=p.IdSubLinea
where DocuId=@DocuId
order by 1 asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleGuiaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleGuiaB]     
@GuiaId varchar(38)    
as    
begin    
select    
'DetalleId|IdSub|IdProducto|Codigo|Cantidad|UM|Descripcion|Costo|PrecioUni|Importe|Estado|IdNota|ValorUM|OBS¬100|0|100|140|90|80|575|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+    
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+CONVERT(varchar,p.IdSublinea)+'|'+convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+    
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+d.UniMedida+'|'+p.ProductoNombre +' ' + p.ProductoMarca+'|'+convert(varchar,d.DetalleCosto)+'|'+    
convert(varchar(50),cast(d.DetallePrecio as money),1)+'|'+convert(varchar(50),cast(d.DetalleImporte as money),1)+'|'+D.DetalleEstado+'|'+convert(varchar,d.IdDetalle)+'|'+    
convert(varchar,d.ValorUM)+'|'+p.ProductoObs   
from DetalleGuia d    
inner join Producto p    
on p.IdProducto=d.IdProducto    
where d.GuiaId=@GuiaId   
order by d.DetalleId asc  
for xml path('')),1,1,'')),'~')+'['+    
isnull((select STUFF((select '¬'+convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+    
c.ClienteDespacho+'|'+c.ClienteTelefono    
from DetallePedido d    
inner join NotaPedido n    
on n.NotaId=d.NotaId    
inner join cliente c    
on c.ClienteId=n.ClienteId    
where d.cantidadSaldo>0 and (n.NotaEstado<>'ANULADO' and n.NotaEntrega='POR ENTREGAR')    
group by c.ClienteId,c.ClienteRazon,c.ClienteDespacho,c.ClienteTelefono    
order by c.ClienteRazon asc    
for xml path('')),1,1,'')),'~')     
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleNota]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleNota]
@Data varchar(max)
as
begin
DECLARE @NotaId numeric(20),
        @Estado varchar(80)
DECLARE @p1 int,@p2 int
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = Len(@Data)+1
Set @NotaId=convert(numeric(20),SUBSTRING(@Data,1,@p1-1))
Set @Estado=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
select
'DetalleId|NotaId|IdProducto|Cantidad|UMedida|Descripcion|PrecioCosto|PrecioUni|Importe|Estado|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat|Codigo|CodigoSunat|Linea|AplicaFB¬100|100|100|100|100|487|100|115|120|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.NotaId)+'|'+convert(varchar,d.IdProducto)+'|'+
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+d.DetalleUm+'|'+d.DetalleDescripcion+'|'+convert(varchar,d.DetalleCosto)+'|'+
convert(varchar(50),cast(d.DetallePrecio as money),1)+'|'+convert(varchar(50),cast(d.DetalleImporte as money),1)+'|'+
d.DetalleEstado+'|'+CONVERT(varchar,d.ValorUM)+'|'+
convert(varchar,convert(decimal(18,6),d.DetallePrecio/1.18))+'|'+
convert(varchar,(convert(decimal(18,6),d.DetallePrecio/1.18)* d.DetalleCantidad)*0.18)+'|'+
convert(varchar,convert(decimal(18,6),d.DetallePrecio/1.18)* d.DetalleCantidad) +'|'+
s.CodigoSunat+'|'+s.NombreSublinea+'|'+p.ProductoCodigo+'|'+p.AplicaFB
from DetallePedido d
inner join Producto p
on p.IdProducto=d.IdProducto
inner join Sublinea s
on s.IdSubLinea=p.IdSubLinea
where d.NotaId=@NotaId and d.DetalleEstado=@Estado
order by d.DetalleId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleNotaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleNotaB]          
@NotaId numeric(38)          
as          
begin          
declare @Estado varchar(80)          
set @Estado=(select top 1 n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)          
select          
'Id|NotaId|IdProducto|Codigo|Cantidad|UM|Descripcion|PreCosto|PrecioUni|Importe|Imagen|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat|Linea|AplicaFB|CantMaxVen|AplicaINV|Estado|Confirma|OBS¬100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+        
isnull((select stuff((select '¬'+convert(varchar,d.DetalleId)+'|'+          
convert(varchar,d.NotaId)+'|'+          
convert(varchar,d.IdProducto)+'|'+          
p.ProductoCodigo+'|'+          
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+          
d.DetalleUm+'|'+          
d.DetalleDescripcion+'|'+          
case when @Estado='PENDIENTE' then           
CONVERT(VarChar(50), cast((p.ProductoCosto * d.ValorUm) as money ), 1)          
else          
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)          
end+'|'+          
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+          
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+        
p.ProductoImagen+'|'+CONVERT(varchar,d.ValorUM)+'|'+          
convert(varchar,convert(decimal(18,2),d.DetallePrecio/1.18))+'|'+          
convert(varchar,(d.DetalleImporte - convert(decimal(18,2),d.DetalleImporte/1.18)))+'|'+          
convert(varchar,convert(decimal(18,2),d.DetalleImporte/1.18))+'|'+s.NombreSublinea+'|'+          
 p.AplicaFB+'|'+convert(varchar,cast((p.MaxCantVen/d.ValorUM)as decimal(18,2)))+'|'+p.AplicaINV+'|'+d.Estado+'||'+p.ProductoObs     
from DetallePedido d          
inner join Producto p          
on p.IdProducto=d.IdProducto          
inner join Sublinea s          
on s.IdSubLinea=p.IdSubLinea          
where d.NotaId=@NotaId and d.DetalleEstado<>'ANULADO'          
order by d.DetalleId asc          
FOR XML PATH('')), 1, 1, '')),'~')+'['+          
isnull((select STUFF((select '¬'+ convert(varchar,r.GuiaId)+'|'+g.GuiaNumero          
from GuiaRelacion r          
inner join GuiaRemision g          
on g.GuiaId=r.GuiaId          
where r.NotaId=@NotaId          
order by r.DetalleId asc          
FOR XML PATH('')), 1, 1, '')),'~')--alt 1 2 6          
end
GO
/****** Object:  StoredProcedure [dbo].[listaDocuCompania]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDocuCompania]  
@CompaniaId int,  
@fechainicio date,  
@fechafin date  
as  
begin  
select d.DocuId,d.CompaniaId,d.NotaId,d.DocuDocumento,d.docuSerie+'-'+d.DocuNumero as DocuNumero,c.ClienteId,  
c.ClienteRazon,c.ClienteRuc,c.ClienteDni,c.ClienteDireccion,d.DocuNumero as Numero,  
(Convert(char(10),d.DocuEmision,103))as FechaEmision,n.NotaCondicion as DocuCondicion,  
d.DocuSerie as Serie,(Convert(char(10),d.DocuFechaPago,103)) as FechaPago,d.DocuCancelacion,  
d.DocuLetras,(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))as DocuSubTotal,  
(convert(varchar(50), CAST(d.DocuIgv as money), -1)) as DocuIgv,(convert(varchar(50), CAST(d.ICBPER as money), -1))as ICBPER,  
(convert(varchar(50), CAST(d.DocuTotal as money), -1))as DocuTotal,d.DocuUsuario,  
d.DocuEstado as DocuEstado,co.CompaniaRazonSocial as compania,d.DocuSaldo,  
d.EstadoSunat as Estado,d.DocuAdicional as MDC,d.DocuHash,co.CompaniaRUC,  
c.ClienteCorreo as Correo,d.DocuNroGuia as Referencia,  
convert(varchar(50), CAST(d.DocuGravada as money),1) as Gravada,  
convert(varchar(50), CAST(d.DocuDescuento as money),1)as Descuento,  
d.EnvioCorreo,n.NotaEntrega as Entrega 
from DocumentoVenta d  
inner join Compania co  
on co.CompaniaId=d.CompaniaId  
inner join Cliente c  
on c.ClienteId=d.ClienteId  
inner join NotaPedido n  
on n.NotaId=d.NotaId  
where d.CompaniaId=@CompaniaId and(Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)  
order by d.DocuId desc  
end
GO
/****** Object:  StoredProcedure [dbo].[listaDocuFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDocuFecha] @fechainicio date,@fechafin date
as
begin
select d.DocuId,d.CompaniaId,d.NotaId,d.DocuDocumento,d.docuSerie+'-'+d.DocuNumero as DocuNumero,c.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,c.ClienteDireccion,d.DocuRegistro,
(Convert(char(10),d.DocuEmision,103))as FechaEmision,n.NotaCondicion as DocuCondicion,d.DocuDias,(Convert(char(10),d.DocuFechaPago,103)) as FechaPago,d.DocuCancelacion,d.DocuLetras,
(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))as DocuSubTotal,(convert(varchar(50), CAST(d.DocuIgv as money), -1)) as DocuIgv,(convert(varchar(50), CAST(d.DocuTotal as money), -1))as DocuTotal,d.DocuUsuario,
d.DocuEstado as DocuEstado,co.CompaniaRazonSocial as compania,d.DocuSaldo,
d.EstadoSunat as Estado,d.DocuAdicional as MDC,d.DocuHash
from DocumentoVenta d
inner join Compania co
on co.CompaniaId=d.CompaniaId
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join NotaPedido n
on n.NotaId=d.NotaId
where (Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)
order by d.DocuId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaDocumentos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDocumentos]  
as  
begin  
select d.DocuId,d.CompaniaId,d.NotaId,d.DocuDocumento,d.docuSerie+'-'+d.DocuNumero as DocuNumero,c.ClienteId,  
c.ClienteRazon,c.ClienteRuc,c.ClienteDni,c.ClienteDireccion,d.DocuNumero as Numero,  
(Convert(char(10),d.DocuEmision,103))as FechaEmision,n.NotaCondicion as DocuCondicion,  
d.DocuSerie as Serie,(Convert(char(10),d.DocuFechaPago,103)) as FechaPago,d.DocuCancelacion,  
d.DocuLetras,(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))as DocuSubTotal,  
(convert(varchar(50), CAST(d.DocuIgv as money), -1)) as DocuIgv,(convert(varchar(50), CAST(d.ICBPER as money), -1))as ICBPER,  
(convert(varchar(50), CAST(d.DocuTotal as money), -1))as DocuTotal,d.DocuUsuario,  
d.DocuEstado as DocuEstado,co.CompaniaRazonSocial as compania,d.DocuSaldo,  
d.EstadoSunat as Estado,d.DocuAdicional as MDC,d.DocuHash,co.CompaniaRUC,  
c.ClienteCorreo as Correo,d.DocuNroGuia as Referencia,  
convert(varchar(50), CAST(d.DocuGravada as money),1) as Gravada,  
convert(varchar(50), CAST(d.DocuDescuento as money),1)as Descuento,  
d.EnvioCorreo,n.NotaEntrega as Entrega
from DocumentoVenta d  
inner join Compania co  
on co.CompaniaId=d.CompaniaId  
inner join Cliente c  
on c.ClienteId=d.ClienteId  
inner join NotaPedido n  
on n.NotaId=d.NotaId  
where Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate())  
order by d.DocuId desc  
end
GO
/****** Object:  StoredProcedure [dbo].[listaGeneralFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[listaGeneralFecha] 
@fechainicio date,
@fechafin date
as
begin 
select
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
where (Convert(char(10),c.FechaCierre,103) BETWEEN @fechainicio AND @fechafin) 
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaLiquida]
as
begin
select l.LiquidacionId,l.LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from Liquidacion l
where(month(l.LiquidacionFecha)=MONTH(GETDATE()) and YEAR(l.LiquidacionFecha)=YEAR(GETDATE()))
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaliquidafecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaliquidafecha] @fechainicio date,@fechafin date
as
begin
select l.LiquidacionId,LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from Liquidacion l
where (Convert(char(10),l.LiquidacionFecha,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaliquidafechaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaliquidafechaB] @fechainicio date,@fechafin date
as
begin
select l.LiquidacionId,LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from LiquidacionVenta l
where (Convert(char(10),l.LiquidacionFecha,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaLiquidaVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaLiquidaVenta]
as
begin
select l.LiquidacionId,l.LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from LiquidacionVenta l
where(month(l.LiquidacionFecha)=MONTH(GETDATE()) and YEAR(l.LiquidacionFecha)=YEAR(GETDATE()))
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaNotaComC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaNotaComC] 
@f1 date,
@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo='07' or c.TipoCodigo='101') and(Convert(char(10),c.CompraComputo, 103) BETWEEN @f1 AND @f2)
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaNotaComE]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaNotaComE] 
@f1 date,
@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,
CompraTipoSunat as TipoSunat
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo='07' or c.TipoCodigo='101') and(Convert(char(10),c.CompraEmision,103) BETWEEN @f1 AND @f2)
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaNotaCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaNotaCompra]
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo='07' or c.TipoCodigo='101')and(Month(c.CompraComputo)=Month(GETDATE()) and year(c.CompraComputo)=year(GETDATE()))
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaPedidosFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaPedidosFecha] 
@fechainicio date,
@fechafin date  
as  
begin  
select n.NotaId,n.NotaDocu,n.NotaFecha,n.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,  
n.NotaCondicion,n.NotaFormaPago,n.NotaDias,(Convert(char(10),n.NotaFechaPago,103))as NotaFechaPago  
,CONVERT(VarChar(50), cast(n.NotaSubtotal as money ), 1)as NotaSubtotal,n.NotaMovilidad,  
n.NotaDescuento,CONVERT(VarChar(50), cast(n.NotaTotal as money ), 1)as OpGravada,  
n.NotaAcuenta,CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)as SaldoDocumento,  
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)as NotaAdicional,CONVERT(VarChar(50), cast(n.NotaTarjeta as money ), 1)as TotalTarjeta,  
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)as TotalPagar,n.NotaUsuario,n.NotaEstado,  
co.CompaniaRazonSocial as compania,c.ClienteDireccion as Direccion,n.NotaDireccion,n.NotaTelefono,n.NotaEntrega as Entrega,  
n.ModificadoPor,n.FechaEdita,n.NotaConcepto,NotaSerie,NotaNumero,
CONVERT(VarChar(50), cast(n.NotaGanancia as money ), 1) as Ganancia
from NotaPedido n  
inner join Cliente c  
on c.ClienteId=n.ClienteId  
inner join Compania co  
on co.CompaniaId=n.CompaniaId  
where (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)  
order by 1 desc  
end
GO
/****** Object:  StoredProcedure [dbo].[listaProveedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaProveedor]
 as
 begin
 select
 'Codigo|RazonSocial|RUC|Contacto|Celular|Telefono|Correo|Direccion|Estado¬90|400|105|200|150|150|150|250|100¬String|String|String|String|String|String|String|String|String¬'+
 isnull((select stuff((SELECT '¬'+ CONVERT(varchar,p.ProveedorId)+'|'+p.ProveedorRazon+'|'+p.ProveedorRuc+'|'+
 p.ProveedorContacto+'|'+p.ProveedorCelular+'|'+p.ProveedorTelefono+'|'+p.ProveedorCorreo+'|'+
 p.ProveedorDireccion+'|'+p.ProveedorEstado
 from Proveedor p
 order by p.ProveedorId desc
 for xml path('')),1,1,'')),'~')
 end
GO
/****** Object:  StoredProcedure [dbo].[listarCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarCaja]  
as  
begin  
select  
'CajaId|FechaApertura|FechaCierre|MontoIniSol|Ingresos|Tarjetas|Salidas|Total|Encargado|Usuario|Estado|Observaciones|CajaIdM¬100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String¬'+   
isnull((select STUFF((select '¬'+convert(varchar,c.CajaId)+'|'+  
(Convert(char(10),c.CajaFecha,103))+' '+ IsNull(SUBSTRING(convert(varchar,c.CajaFecha,114),1,8),'')+'|'+ 
c.CajaCierre+'|'+  
CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaIngresos as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaDeposito as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaSalidas as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaTotal as money ), 1)+'|'+  
c.CajaEncargado+'|'+  
c.CajaUsuario+'|'+  
c.CajaEstado+'|'+  
c.Observacion+'|'+c.CajaIdB  
from Caja c  
where Month(c.CajaFecha)=Month(GETDATE()) and year(c.CajaFecha)=year(GETDATE())  
order by c.CajaId desc  
FOR XML path ('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[listarCajaFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarCajaFecha]   
@fechainicio date,  
@fechafin date  
as  
begin
select 
'CajaId|FechaApertura|FechaCierre|MontoIniSol|Ingresos|Tarjetas|Salidas|Total|Encargado|Usuario|Estado|Observaciones|CajaIdM¬100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String¬'+   
isnull((select STUFF((select '¬'+convert(varchar,c.CajaId)+'|'+  
(Convert(char(10),c.CajaFecha,103))+' '+ IsNull(SUBSTRING(convert(varchar,c.CajaFecha,114),1,8),'')+'|'+ 
c.CajaCierre+'|'+  
CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaIngresos as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaDeposito as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaSalidas as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(c.CajaTotal as money ), 1)+'|'+  
c.CajaEncargado+'|'+  
c.CajaUsuario+'|'+  
c.CajaEstado+'|'+  
c.Observacion+'|'+c.CajaIdB 
from Caja c  
where (Convert(char(10),c.CajaFecha,103) BETWEEN @fechainicio AND @fechafin)
order by c.CajaId desc  
FOR XML path ('')),1,1,'')),'~')   
end
GO
/****** Object:  StoredProcedure [dbo].[listarClienteB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarClienteB]
as
begin
select 
'ClienteId|RazonSocial|RUC|DNI|Direccion|Celular|Telefono|Correo|Fecha|Usuario|Estado|Direc¬90|420|95|75|290|110|110|100|150|150|100|90¬String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select stuff((SELECT '¬'+ convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+isnull(c.ClienteRuc,'')+'|'+
isnull(c.ClienteDni,'')+'|'+isnull(c.ClienteDespacho,'')+'|'+isnull(c.ClienteMovil,'')+'|'+
isnull(c.ClienteTelefono,'')+'|'+isnull(c.ClienteCorreo,'')+'|'+
(IsNull(convert(varchar,c.clienteFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.clienteFecha,114),1,8),''))+'|'+
c.ClienteUsuario+'|'+isnull(c.ClienteEstado,'')+'|'+isnull(c.ClienteDireccion,'')
FROM Cliente c
order by c.ClienteId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarCompras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarCompras] 
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat,CompraConcepto as Concepto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo<>'07' and c.TipoCodigo<>'08' and c.TipoCodigo<>'101') and(Month(c.CompraComputo)=Month(GETDATE()) and year(c.CompraComputo)=year(GETDATE()))
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarDetaCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarDetaCaja]    
@CajaId varchar(38)    
as    
begin  
select    
'DetalleId|CajaId|Fecha|NroNota|Movimiento|Referencia|Concepto|Efectivo|Monto|Vuelto|DetalleEfectivo|Usuario¬80|80|145|95|100|100|215|105|105|105|90|150¬String|String|String|String|String|String|String|String|String|String|String|String¬'+    
isnull((select stuff((select '¬'+    
convert(varchar,d.DetalleId)+'|'+convert(varchar,d.CajaId)+'|'+    
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+    
convert(varchar,d.NotaId)+'|'+d.DetalleMovimiento+'|'+d.DetalleReferencia+'|'+d.DetalleConcepto+'|'+    
CONVERT(VarChar(50), cast(d.DetalleEfectivo as money ), 1)+'|'+    
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+    
CONVERT(VarChar(50), cast(d.DetalleVuelto as money ), 1)+'|'+    
convert(varchar,d.DetalleEfectivo)+'|'+d.Usuario    
from CajaDetalle d    
where d.CajaId=@CajaId and d.Vista=''    
order by d.DetalleId desc    
for xml path('')),1,1,'')),'~')+'['+     
'Codigo|Descripcion|Cantidad|UM|Importe¬110|370|105|90|105¬String|String|String|String|String¬'+    
isnull((select STUFF((select '¬'+p.ProductoCodigo+'|'+    
d.DetalleDescripcion+'|'+    
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+    
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)    
from NotaPedido n    
inner join DetallePedido d    
on d.NotaId=n.NotaId    
inner join Producto p    
on p.IdProducto=d.IdProducto    
where n.CajaId=@CajaId and(n.NotaEstado='CANCELADO' and n.NotaConcepto='MERCADERIA')     
group by p.ProductoCodigo,d.DetalleDescripcion,d.DetalleUm    
order by d.DetalleDescripcion asc    
for xml path('')),1,1,'')),'~')+'['+    
isnull((select STUFF((select '¬'+    
CONVERT(VarChar(50), cast(SUM(d.DetalleMonto) as money ), 1)    
FROM CajaDetalle d    
WHERE d.CajaId=@CajaId AND d.NotaId<>'0' AND d.DetalleMovimiento='INGRESO'    
for xml path('')),1,1,'')),'0.00')     
end
GO
/****** Object:  StoredProcedure [dbo].[listarDetaLetra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarDetaLetra] @LetraId numeric(38)
as
begin
select d.DetalleId,d.LetraId,d.LetraCanje,d.LetraDias,(Convert(char(10),d.LetraVencimiento,103)) as Vencimeinto,
CONVERT(VarChar(50), cast(d.DetalleSaldo as money ), 1) as SaldoLetra,
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1) as DetalleMonto,d.DetalleEstado
from DetalleLetra d
where d.LetraId=@LetraId 
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarDetaliquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarDetaliquida] @LiquidacionId numeric(38)
as
begin
select d.DetalleId,d.LiquidacionId,d.CompraId,d.Numero as Numero,
d.Proveedor,CONVERT(VarChar(50), cast(d.SaldoDocu as money ), 1) as Saldo,d.Moneda,d.EfectivoSoles,
d.EfectivoDolar,d.DepositoSoles,d.DepositoDolar,d.TipoCambio,d.EntidadBanco,d.NroOperacion,
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1) as Acuenta,
d.FechaPago,CONVERT(VarChar(50), cast(d.SaldoActual as money ), 1)as SaldoActual,d.Concepto
from DetalleLiquida d
where d.LiquidacionId=@LiquidacionId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarGuia]   
@Concepto varchar(60)  
as  
begin  
select
'GuiaId|Numero|Motivo|FechaRegistro|Destinatario|Ruc|Almacen|PuntoPartida|PuntoLLegada|Responsable|Usuario|ClienteId|Estado|Telefono¬90|90|90|90|90|90|90|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,g.GuiaId)+'|'+
g.GuiaNumero+'|'+
g.GuiaMotivo+'|'+
(IsNull(convert(varchar,g.GuiaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GuiaRegistro,114),1,8),''))+'|'+
g.GuiaDestinatario+'|'+
g.GuiaRucDes+'|'+
g.GuiaAlmacen+'|'+
g.GuiaPartida+'|'+
g.GuiaLLegada+'|'+
g.GuiaTramsporte+'|'+
g.GuiaUsuario+'|'+
convert(varchar,g.ClienteId)+'|'+
g.GuiaEstado+'|'+
g.GuiaTelefono  
from GuiaRemision g
where g.GuiaConcepto=@Concepto and (Month(g.GuiaRegistro)=Month(GETDATE()) and YEAR(g.GuiaRegistro)=YEAR(GETDATE()))  
order by g.GuiaId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarGuiaFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarGuiaFecha] 
@fechainicio date,
@fechafin date  
as  
begin  
select
'GuiaId|Numero|Motivo|FechaRegistro|Destinatario|Ruc|Almacen|PuntoPartida|PuntoLLegada|Responsable|Usuario|ClienteId|Estado|Telefono¬90|90|90|90|90|90|90|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,g.GuiaId)+'|'+
g.GuiaNumero+'|'+
g.GuiaMotivo+'|'+
(IsNull(convert(varchar,g.GuiaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GuiaRegistro,114),1,8),''))+'|'+
g.GuiaDestinatario+'|'+
g.GuiaRucDes+'|'+
g.GuiaAlmacen+'|'+
g.GuiaPartida+'|'+
g.GuiaLLegada+'|'+
g.GuiaTramsporte+'|'+
g.GuiaUsuario+'|'+
convert(varchar,g.ClienteId)+'|'+
g.GuiaEstado+'|'+
g.GuiaTelefono  
from GuiaRemision g 
where (Convert(char(10),g.GuiaRegistro,103) BETWEEN @fechainicio AND @fechafin) 
order by g.GuiaId desc 
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarKardex]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarKardex] 
@IdProducto numeric(20)
as
begin
	select 
	'KardexId|IdProducto|FechaMovimiento|Motivo|Documento|StockInicial|CantidadIngre|CantidadSali|PrecioCosto|StockFinal|Concepto|Responsable¬100|100|145|150|145|115|115|115|115|115|100|160¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
	isnull((select STUFF ((select '¬'+convert(varchar,k.KardexId)+'|'+CONVERT(varchar,k.IdProducto)+'|'+
	(IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+
	k.KardexMotivo+'|'+k.KardexDocumento+'|'+
	CONVERT(VarChar(50), cast(k.StockInicial as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadSalida as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.PrecioCosto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.StockFinal as money ), 1)+'|'+
	K.KadexConcepto+'|'+k.Usuario
	from Kardex k with(nolock)
	where k.IdProducto=@IdProducto and (Month(k.KardexFecha)=Month(GETDATE()) and YEAR(k.kardexFecha)=year(getdate()))
	order by k.KardexId desc
	for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarKardexFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarKardexFecha] 
@Id numeric(20),
@fechainicio date,@fechafin date
as
begin
select 
	'KardexId|IdProducto|FechaMovimiento|Motivo|Documento|StockInicial|CantidadIngre|CantidadSali|PrecioCosto|StockFinal|Concepto|Responsable¬100|100|145|150|145|115|115|115|115|115|100|160¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
	isnull((select STUFF ((select '¬'+convert(varchar,k.KardexId)+'|'+CONVERT(varchar,k.IdProducto)+'|'+
	(IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+
	k.KardexMotivo+'|'+k.KardexDocumento+'|'+
	CONVERT(VarChar(50), cast(k.StockInicial as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadSalida as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.PrecioCosto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.StockFinal as money ), 1)+'|'+
	K.KadexConcepto+'|'+k.Usuario
	from Kardex k
	where k.IdProducto=@Id and (Convert(char(10),k.KardexFecha,103) BETWEEN @fechainicio AND @fechafin)
	order by k.KardexId desc
    for xml path('')),1,1,'')),'~')
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarLetraFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarLetraFecha] @fechainicio date,@fechafin date
as
begin
select l.LetraId, l.ProveedorId,p.ProveedorRazon,l.LetraFechaReg,(Convert(char(10),l.LetraFechaGiro,103)) as FechaGiro,
l.LetraMoneda as Moneda,CONVERT(VarChar(50), cast(l.LetraSaldo as money ), 1)as SaldoLetras,CONVERT(VarChar(50), cast(l.LetraTotal as money ), 1)as TotalLetras,l.LetraUsuario,l.LetraEstado as Estado
from Letra l
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where (Convert(char(10),l.LetraFechaGiro,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarLetras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarLetras]
as
begin
select l.LetraId, l.ProveedorId,p.ProveedorRazon,l.LetraFechaReg,(Convert(char(10),l.LetraFechaGiro,103)) as FechaGiro,l.LetraMoneda as Moneda,
CONVERT(VarChar(50), cast(l.LetraSaldo as money ), 1)as SaldoLetras,CONVERT(VarChar(50), cast(l.LetraTotal as money ), 1)as TotalLetras,
l.LetraUsuario,l.LetraEstado as Estado,l.CompaniaId
from Letra l
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where year(LetraFechaGiro)=YEAR(GETDATE())
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarPedidos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarPedidos]  
as  
begin  
(select n.NotaId,n.NotaDocu,n.NotaFecha,n.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,  
n.NotaCondicion,n.NotaFormaPago,n.NotaDias,(Convert(char(10),n.NotaFechaPago,103))as NotaFechaPago  
,CONVERT(VarChar(50), cast(n.NotaSubtotal as money ), 1)as NotaSubtotal,n.NotaMovilidad,  
n.NotaDescuento,CONVERT(VarChar(50), cast(n.NotaTotal as money ), 1)as OpGravada,  
n.NotaAcuenta,CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)as SaldoDocumento,  
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)as NotaAdicional,CONVERT(VarChar(50), cast(n.NotaTarjeta as money ), 1)as TotalTarjeta,  
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)as TotalPagar,n.NotaUsuario,n.NotaEstado,  
co.CompaniaRazonSocial as compania,c.ClienteDireccion as Direccion,n.NotaDireccion,  
n.NotaTelefono,n.NotaEntrega as Entrega,n.ModificadoPor,  
n.FechaEdita,n.NotaConcepto,NotaSerie,NotaNumero,
CONVERT(VarChar(50), cast(n.NotaGanancia as money ), 1) as Ganancia
from NotaPedido n with(nolock)     
inner join Cliente c  
on c.ClienteId=n.ClienteId  
inner join Compania co  
on co.CompaniaId=n.CompaniaId  
where(Day(n.NotaFecha)=Day(GETDATE()) and 
month(n.NotaFecha)=month(GETDATE())and year(n.NotaFecha)=year(GETDATE()))  
)  
union all  
(select n.NotaId,n.NotaDocu,n.NotaFecha,n.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,  
n.NotaCondicion,n.NotaFormaPago,n.NotaDias,(Convert(char(10),n.NotaFechaPago,103))as NotaFechaPago  
,CONVERT(VarChar(50), cast(n.NotaSubtotal as money ), 1)as NotaSubtotal,n.NotaMovilidad,  
n.NotaDescuento,CONVERT(VarChar(50), cast(n.NotaTotal as money ), 1)as OpGravada,  
n.NotaAcuenta,CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)as SaldoDocumento,  
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)as NotaAdicional,CONVERT(VarChar(50), cast(n.NotaTarjeta as money ), 1)as TotalTarjeta,  
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)as TotalPagar,n.NotaUsuario,n.NotaEstado,  
co.CompaniaRazonSocial as compania,c.ClienteDireccion as Direccion,n.NotaDireccion,  
n.NotaTelefono,n.NotaEntrega as Entrega,  
n.ModificadoPor,n.FechaEdita,n.NotaConcepto,NotaSerie,NotaNumero,
CONVERT(VarChar(50), cast(n.NotaGanancia as money ), 1) as Ganancia  
from NotaPedido n with(nolock)  
inner join Cliente c  
on c.ClienteId=n.ClienteId  
inner join Compania co  
on co.CompaniaId=n.CompaniaId  
where n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' 
and((n.NotaEstado<>'CANCELADO' and n.NotaDocu <>'PROFORMA')and 
convert(date,n.NotaFecha) < convert(date,getdate()))))  
order by 1 desc  
end
GO
/****** Object:  StoredProcedure [dbo].[listarPersonal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarPersonal]
as
begin
SELECT p.PersonalId,p.PersonalCodigo,p.PersonalNombres,p.PersonalApellidos,
p.PersonalApellidos+' '+p.PersonalNombres as Nombres,a.AreaNombre, 
p.PersonalDNI,p.PersonalRuc,p.PersonalTelefono,p.PersonalTelefonoAsi,p.PersonalIngreso,
p.PersonalBajaFecha,Convert(char(10),p.PersonalNacimiento,103) as PersonalNacimiento,
(select dbo.CalcularEdad(p.personalNacimiento))AS Edad,p.PersonalDireccion,
p.PersonalSueldo,p.PersonalEmail,c.CompaniaRazonSocial,p.PersonalEstado,p.PersonalImagen,
p.PersonalLicencia as Licencia
FROM Personal p 
INNER JOIN Area a 
ON a.AreaId =p.AreaId
inner join Compania c
on c.CompaniaId=p.CompaniaId
where p.PersonalEstado='ACTIVO'
order by p.PersonalApellidos asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarProducto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarProducto]          
as          
begin          
SELECT p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,          
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,p.ProductoCantidad,           
p.ProductoUM,'' as CantidadReal,CONVERT(VarChar(max), cast(p.CantidadANT as money ), 1)as CantidadANT,  
(IsNull(convert(varchar,p.FechaModCant,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,p.FechaModCant,114),1,8),'')) as FechaEdicion,  
p.ProductoVenta,p.ProductoVentaB,p.ProductoCosto,ProductoCostoDolar,ProductoTipoCambio,           
a.AlmacenNombre,p.ProductoUbicacion,p.ProductoEstado,p.ProductoUsuario,p.ProductoFecha,p.ProductoImagen,         
(convert(varchar(max),cast((p.ProductoCantidad * p.ProductoCosto) as money),-1))as Inversion,          
(convert(varchar(max),cast((p.ProductoCantidad *p.ProductoVenta) as money),-1))as VentaNeta,          
(convert(varchar(max),cast(((p.ProductoCantidad *p.ProductoVenta)-(p.ProductoCantidad * p.ProductoCosto)) as money),-1))as MargenUtilidad,          
p.ValorCritico,AplicaTC,AplicaFB,AplicaINV,MaxCantVen  
FROM Producto p with(nolock)         
INNER JOIN Sublinea s  with(nolock)        
ON p.IdSubLinea =s.IdSubLinea         
INNER JOIN Linea l with(nolock)        
ON s.IdLinea =l.IdLinea  
INNER JOIN Almacen a with(nolock)  
ON p.AlmacenId =a.AlmacenId          
where p.ProductoEstado='BUENO'          
order by p.ProductoNombre+' '+p.ProductoMarca asc --p.IdProducto desc,          
end
GO
/****** Object:  StoredProcedure [dbo].[listarRenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarRenta]
as
begin
select 
'ID|Compania|Anno|Mes|Declaracion|Igv|Renta|SaldoIgv|SaldoRenta|InteresIgv|InteresRenta|TotalIgv|TotalRenta|FormaPago|FechaPago|Entidad|NroOperacion|PagoTotal¬
80|90|80|80|145|120|120|120|120|120|120|120|110|70|120|100|100|120¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarRentaFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarRentaFecha] 
@fechainicio date,@fechafin date
as
begin
select 
'ID|Compania|Anno|Mes|Declaracion|Igv|Renta|SaldoIgv|SaldoRenta|InteresIgv|InteresRenta|TotalIgv|TotalRenta|FormaPago|FechaPago|Entidad|NroOperacion|PagoTotal¬
80|90|80|80|145|120|120|120|120|120|120|120|110|70|120|100|100|120¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where (Convert(char(10),r.FechaCancelacion,103) BETWEEN @fechainicio AND @fechafin)
order by r.RentaMes desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarSaldos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarSaldos]   
@ClienteId varchar(20)  
as  
begin  
select  
'DetalleId|NroNota|Idproducto|Codigo|Descripcion|Cantidad|Saldo|UM|Stock|UnidadM|CantInicial|critico|ClienteId|PrecioVenta|valorUM¬100|90|100|100|450|100|100|90|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.NotaId)+'|'+  
convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+d.DetalleDescripcion+'|'+''+'|'+  
convert(varchar(50),cast(d.CantidadSaldo as money),1)+'|'+d.DetalleUm+'|'+  
convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+p.ProductoUM+'|'+  
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+  
convert(varchar,p.ValorCritico)+'|'+convert(varchar,n.ClienteId)+'|'+  
convert(varchar,d.DetallePrecio)+'|'+convert(varchar,d.ValorUM)  
from DetallePedido d  
inner join NotaPedido n  
on n.NotaId=d.NotaId  
inner join Producto p  
on p.IdProducto=d.IdProducto  
where n.ClienteId=@ClienteId and d.cantidadSaldo>0  
order by n.NotaId desc,d.DetalleId asc  
for xml path('')),1,1,'')),'~')+'['+  
isnull((select STUFF ((select '¬' +CONVERT(VarChar(50), cast(sum(n.NotaSaldo) as money ), 1)  
from NotaPedido n  
where n.ClienteId=@ClienteId and n.NotaEntrega='POR ENTREGAR'  
for xml path('')),1,1,'')),'0')  
end
GO
/****** Object:  StoredProcedure [dbo].[listarSaldosB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarSaldosB] @NotaId numeric(38)
as
begin
select d.DetalleId,d.NotaId,d.IdProducto,p.ProductoCodigo as Codigo,d.DetalleDescripcion as Descripcion,
d.CantidadSaldo as CantidadSaldo,p.ProductoCantidad as Stock,substring(p.ProductoUM,1,3) as UM,d.DetalleCantidad as CantidadInicial,
p.ValorCritico,n.ClienteId,d.DetallePrecio as PrecioCosto
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where d.NotaId=@NotaId and d.cantidadSaldo>0
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarSublinea]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarSublinea]
as
begin
select s.IdSubLinea,s.NombreSublinea,s.CodigoSunat,l.NombreLinea
from Sublinea s
inner join Linea l
on l.IdLinea=s.IdLinea
order by s.NombreSublinea asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarUM]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[listarUM] 
@IdProducto numeric(20)
as
begin
select
'IdUm|IdProducto|UNIDAD M|Valor|PreVenta|PreVentaB|PreCosto¬80|80|110|100|100|100|100¬String|String|String|Decimal|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,m.IdUm)+'|'+CONVERT(varchar,m.IdProducto)+'|'+m.UMDescripcion+'|'+
convert(varchar,m.ValorUM)+'|'+CONVERT(VarChar(50),cast(m.PrecioVenta as money ), 1)+'|'+CONVERT(VarChar(50), cast(m.PrecioVentaB as money ), 1)+'|'+
CONVERT(varchar(50),m.PrecioCosto)
from UnidadMedida m
where m.IdProducto=@IdProducto
order by m.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarUsuario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarUsuario]
as
begin
select u.UsuarioID,p.PersonalId,(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1))))+' '+ p.PersonalApellidos as Personal,u.UsuarioAlias,dbo.desincrectar(u.UsuarioClave)as UsuarioClave,a.AreaNombre,u.UsuarioFechaReg,u.Usuarioestado
from Usuarios u
inner join Personal p
on p.PersonalId=u.PersonalId
inner join Area a
on a.AreaId=p.AreaId
where u.UsuarioEstado='ACTIVO'
order by u.UsuarioID desc
end
GO
/****** Object:  StoredProcedure [dbo].[listasMarca]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listasMarca]
as
begin
select
isnull((select STUFF((select '¬'+ p.ProductoMarca
from Producto p
group by ProductoMarca
order by p.ProductoMarca asc 
FOR XML PATH('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ p.ProductoUM
from Producto p
group by ProductoUM
order by p.ProductoUM asc
FOR XML PATH('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ p.ProductoUbicacion
from Producto p
group by ProductoUbicacion
order by p.ProductoUbicacion asc
FOR XML PATH('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre
from Almacen a
order by a.AlmacenNombre asc
FOR XML PATH('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoCompra]
@UsuarioID int
as
begin
select
'Id|IdProducto|Codigo|Descripcion|UM|Cantidad|PrecioCosto|Descuento|Importe|ValorUM|Estado¬100|100|100|420|80|90|100|100|110|100|100¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,t.TemporalId)+'|'+convert(varchar,t.IdProducto)+'|'+
t.DetalleCodigo+'|'+t.Descripcion+'|'+t.DetalleUM+'|'+
CONVERT(VarChar(50),cast(t.DetalleCantidad as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)+'|'+convert(varchar,t.DetalleDescuento)
+'|'+convert(varchar,t.DetalleImporte)+'|'+CONVERT(varchar,t.ValorUM)+'|'+
t.DetalleEstado
from TemporalCompra t 
inner join Producto p 
on p.IdProducto=t.IdProducto 
where t.UsuarioID=@UsuarioID
order by t.TemporalId asc
for xml path('')),1,1,'')),'~')+'['+
'IdUm|IdProducto|UnidadM|Valor|Costo¬100|100|100|100|100¬String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoGuia]     
@UsuarioID int  
as    
select  
'Id|UsuarioId|IdProducto|Codigo|Cantidad|UM|Descripcion|PrecioCosto|PrecioUni|Importe|Concepto|StockInicial|CantidadSaldo|ClienteId|DetalleId|Imagen|ValorUm|OBS¬90|90|90|90|90|90|90|90|90|90|90|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF ((select '¬'+convert(varchar,t.temporalId)+'|'+  
convert(varchar,t.UsuarioID)+'|'+  
convert(varchar,t.IdProducto)+'|'+  
p.ProductoCodigo+'|'+    
convert(varchar,t.cantidad)+'|'+  
t.DetalleUM+'|'+  
p.ProductoNombre+' '+p.ProductoMarca+'|'+    
convert(varchar,cast((p.ProductoCosto* t.ValorUM) as decimal(18,2)))+'|'+    
convert(varchar(50),cast(t.precioventa as money),1)+'|'+  
convert(varchar(50),cast(t.importe as money),1)+'|'+t.Concepto+'|'+  
convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+    
convert(varchar,t.CantidadSaldo)+'|'+  
convert(varchar,t.ClienteId)+'|'+  
convert(varchar,t.DetalleId)+'||'+convert(varchar,t.ValorUM)+'|'+p.ProductoObs    
from TemporalGuia t  
inner join Producto p    
on p.IdProducto=t.IdProducto    
where t.UsuarioID=@UsuarioID and t.Concepto='SALIDA'   
order by t.temporalId asc  
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[listaTempoLiquida]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoLiquida] @UsuarioId Int
as
begin
select t.TemporalId,t.IdDeuda,t.Numero,t.Proveedor,
CONVERT(VarChar(50), cast(t.SaldoDocu as money ), 1) as CompraSaldo,t.Moneda,t.TipoCambio,t.EfectivoSoles,t.EfectivoDolar,t.DepositoSoles,t.DepositoDolar,t.EntidadBanco,
t.NroOperacion,CONVERT(VarChar(50), cast(t.AcuentaGeneral as money ), 1) as AcuentaGeneral,
t.UsuarioId,t.TemporalFecha,CONVERT(VarChar(50), cast(t.SaldoDocu - t.AcuentaGeneral as money ), 1) as SaldoActual,t.Concepto
from TemporalLiquida t
where UsuarioId=@UsuarioId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoLiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoLiVenta] @UsuarioId Int
as
begin
select t.TemporalId,t.DocuId,
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end Numero,
c.ClienteRazon,
CONVERT(VarChar(50), cast(t.SaldoDocu as money ), 1) as DocuSaldo,'SOLES' as Moneda,t.TipoCambio,
t.EfectivoSoles,t.EfectivoDolar,t.DepositoSoles,t.DepositoDolar,t.EntidadBanco,
t.NroOperacion,CONVERT(VarChar(50), cast(t.AcuentaGeneral as money ), 1) as AcuentaGeneral,
t.UsuarioId,t.TemporalFecha,CONVERT(VarChar(50), cast(t.SaldoDocu - t.AcuentaGeneral as money ), 1) as SaldoActual,t.NotaId
from TemporalLiVenta t
inner join NotaPedido n
on n.NotaId=t.NotaId
inner join Cliente c
on c.ClienteId=n.ClienteId
where t.UsuarioId=@UsuarioId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoVenta] @UsuarioID int
	as
	select t.temporalId,t.UsuarioID,t.IdProducto,p.ProductoCodigo as Codigo,t.cantidad as Cantidad,
	t.UniMedida as UM,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,
	cast((p.ProductoCosto* t.ValorUM) as decimal(18,2)) as ProductoCosto,t.precioventa,t.importe,p.ProductoImagen as Imagen,
	t.ValorUM,convert(decimal(18,2),t.precioventa/1.18) as PrecioSunat,
	(t.importe - convert(decimal(18,2),t.importe/1.18)) as IGVPrecio,
	convert(decimal(18,2),t.importe/1.18)as ImporteSunat
	from TemporalVenta t
	inner join Producto p
	on p.IdProducto=t.IdProducto
	where t.UsuarioID=@UsuarioID 
	order by t.temporalId asc
GO
/****** Object:  StoredProcedure [dbo].[listaTempoVentaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoVentaB]            
@UsuarioID int            
as            
select            
'Id|UsuarioId|IdProducto|Codigo|Cantidad|UM|Descripcion|PreCosto|PrecioUni|Importe|Imagen|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat|Linea|AplicaFB|CantMaxVen|AplicaINV|Estado|Confirma|OBS¬100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+            
 isnull((select STUFF ((select '¬'+convert(varchar,t.temporalId)+'|'+CONVERT(varchar,t.UsuarioId)+'|'+convert(varchar,t.IdProducto)+'|'+            
 p.ProductoCodigo+'|'+convert(varchar,t.cantidad)+'|'+t.UniMedida+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+            
 convert(varchar,cast((p.ProductoCosto* t.ValorUM) as decimal(18,2)))+'|'+            
 convert(varchar,t.precioventa)+'|'+            
 CONVERT(VarChar(50), cast(t.importe as money ), 1)+'|'+            
 p.ProductoImagen+'|'+convert(varchar,t.ValorUM)+'|'+            
 convert(varchar,convert(decimal(18,2),t.precioventa/1.18))+'|'+            
 convert(varchar,(t.importe - convert(decimal(18,2),t.importe/1.18)))+'|'+            
 convert(varchar,convert(decimal(18,2),t.importe/1.18))+'|'+s.NombreSublinea+'|'+            
 p.AplicaFB+'|'+convert(varchar,cast((p.MaxCantVen/t.ValorUM)as decimal(18,2)))+'|'+
 p.AplicaINV+'|'+t.Estado+'||'         
 from TemporalVenta t            
 inner join Producto p            
 on p.IdProducto=t.IdProducto            
 inner join Sublinea s            
 on s.IdSubLinea=p.IdSubLinea            
 where t.UsuarioID=@UsuarioID             
 order by t.temporalId asc            
 for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[listaTipoCambio]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaTipoCambio]
as
begin
select
'ID|Fecha|COMPRA|VENTA|EMPRESA¬90|110|108|108|117¬String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,t.IdTipo),+'|'+
(Convert(char(10),t.TipoFecha,103))+'|'+convert(varchar,t.TipoCompra)+'|'+
convert(varchar,t.TipoVenta)+'|'+
convert(varchar,t.TipoEmpresa) 
from TipoCambio t 
where MONTH(t.TipoFecha)=MONTH(GETDATE()) and YEAR(t.TipoFecha)=YEAR(GETDATE()) 
order by t.TipoFecha desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaValorCritico]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaValorCritico] @IdSubLinea numeric(20)
as
begin
select p.IdProducto,p.ProductoCodigo as Codigo,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as Stock,
p.ProductoUM as UM,p.ProductoCosto as Costo,p.ProductoCostoDolar as CostoDolar
from Producto p
where p.IdSubLinea=@IdSubLinea and (p.ProductoCantidad < = p.ValorCritico)
order by 3 asc
end
GO
/****** Object:  StoredProcedure [dbo].[LuisDuenas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LuisDuenas]
as
begin
select 'Categoria|Descipcion|Stock|UM|Costo|CostoDolar¬295|470|105|105|105|105¬'+
isnull((select STUFF((select'¬'+s.NombreSublinea+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1)+'|'+
p.ProductoUM+'|'+CONVERT(VarChar(50), cast(p.ProductoCosto as money ), 1)+'|'+CONVERT(VarChar(50), cast(p.ProductoCostoDolar as money ), 1)
from Producto p
inner join Sublinea s
on s.IdSubLinea=p.IdSubLinea
where p.ProductoCantidad < = p.ValorCritico and p.ProductoEstado='BUENO'
order by p.ProductoNombre+' '+p.ProductoMarca asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[LuisDuenasB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LuisDuenasB] 
@fechainicio date,
@fechafin date
as
begin
select 'Fecha|Vendedor|Descripcion|UM|Cantidad|PrecioUni|Costo|GXUnidad|Ganancia¬130|150|400|65|110|110|110|110|115¬'+
(select STUFF((select '¬'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))
+'|'+n.NotaUsuario+'|'+
d.DetalleDescripcion+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast((d.DetalleCantidad) as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1) +'|'+
CONVERT(VarChar(50), cast((d.DetallePrecio-d.DetalleCosto) as money ), 1)+'|'+
CONVERT(VarChar(50), cast(((d.DetallePrecio-d.DetalleCosto)* d.DetalleCantidad) as money ), 1)
	 from DetallePedido d (noLOCK) 
	 inner join NotaPedido n (noLOCK)
	 on n.NotaId=d.NotaId
	 where (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)  
	 and n.NotaEstado='CANCELADO'
	 order by n.NotaFecha desc
	 for xml path('')),1,1,''))
 end
GO
/****** Object:  StoredProcedure [dbo].[MRDuenas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MRDuenas]
as
begin
select 'SubLineas|Productos_'+
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea
from Sublinea s
for XMl path('')),1,1,'')),'~')+'_'+
'Descripcion|Cantidad|UM|PreVenta|PreVentaB|PreCosto¬400|115|80|115|115|115¬'+
isnull((select STUFF((select '¬'+convert(varchar,p.ProductoNombre+' '+p.ProductoMarca)+'|'+CONVERT(varchar,p.ProductoCantidad)
+'|'+p.ProductoUM+'|'+CONVERT(varchar,p.ProductoVenta)+'|'+
CONVERT(varchar,p.ProductoVentaB)+'|'+CONVERT(varchar,p.ProductoCosto)+'|'+convert(varchar,p.IdSubLinea)
from Producto p
for XMl path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[MRDuenasA]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MRDuenasA] 
@AlmacenId int    
as      
begin      
select 'Id|SubLinea|Selec¬0|235|50¬String|String|Boolean¬'+      
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea      
+'|'+convert(char(1),0)      
from Sublinea s (nolock)    
inner join Producto p    
on p.IdSubLinea=s.IdSubLinea    
inner join Stock st    
on st.IdProducto=p.IdProducto
where st.AlmacenId=@AlmacenId    
for XMl path('')),1,1,'')),'~')+'['+      
'ID|Codigo|Descripcion|Inventario|UM|Cantidad|PreVenta|PreCosto|Inversion|VentaNeta|Ganancia¬90|90|90|80|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String¬'+ 
isnull((select STUFF((select '¬'+convert(varchar,s.IdStock)+'|'+      
p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'||'+p.ProductoUM+'|'+      
CONVERT(varchar,s.Cantidad)+'|'+      
CONVERT(varchar,p.ProductoVenta)+'|'+      
CONVERT(varchar,p.ProductoCosto)+'|'+
(convert(varchar(max),cast((p.ProductoCantidad * p.ProductoCosto) as money),-1))+'|'+           
(convert(varchar(max),cast((p.ProductoCantidad *p.ProductoVenta) as money),-1))+'|'+            
(convert(varchar(max),cast(((p.ProductoCantidad *p.ProductoVenta)-
(p.ProductoCantidad * p.ProductoCosto)) as money),-1))+'|'+   
convert(varchar,p.IdSubLinea)      
from Stock s (nolock)    
inner join Producto p (nolock)    
on s.IdProducto=p.IdProducto     
where s.AlmacenId=@AlmacenId and (s.Estado='BUENO' and s.Cantidad>0)    
order by p.IdSubLinea asc,p.ProductoNombre+' '+p.ProductoMarca asc      
for XMl path('')),1,1,'')),'~')      
end
GO
/****** Object:  StoredProcedure [dbo].[MRDuenasB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MRDuenasB]      
as      
begin      
select 'Id|SubLinea|Selec¬0|235|50¬String|String|Boolean¬'+      
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea      
+'|'+convert(char(1),0)      
from Sublinea s      
for XMl path('')),1,1,'')),'~')+'['+      
'ID|Codigo|Descripcion|Inventario|UM|Cantidad|PreVenta|PreCosto|Inversion|VentaNeta|Ganancia¬90|90|90|80|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String¬'+      
isnull((select STUFF((select '¬'+convert(varchar,p.IdProducto)+'|'+      
p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'||'+p.ProductoUM+'|'+      
CONVERT(varchar,p.ProductoCantidad)+'|'+      
CONVERT(varchar,p.ProductoVenta)+'|'+      
CONVERT(varchar,p.ProductoCosto)+'|'+  
(convert(varchar(max),cast((p.ProductoCantidad * p.ProductoCosto) as money),-1))+'|'+             
(convert(varchar(max),cast((p.ProductoCantidad *p.ProductoVenta) as money),-1))+'|'+              
(convert(varchar(max),cast(((p.ProductoCantidad *p.ProductoVenta)-  
(p.ProductoCantidad * p.ProductoCosto)) as money),-1))+'|'+      
convert(varchar,p.IdSubLinea)      
from Producto p      
where p.ProductoEstado='BUENO' and p.ProductoCantidad>0      
order by p.IdSubLinea asc,p.ProductoNombre+' '+p.ProductoMarca asc      
for XMl path('')),1,1,'')),'~')      
end
GO
/****** Object:  StoredProcedure [dbo].[permisoElimina]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[permisoElimina]
@Codigo varchar(60)
as
begin
select top 1((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1))) as USUARIO 
from Personal p
where PersonalCodigo=@Codigo and (AreaId=6 or AreaId=7 or AreaId=12)
end
GO
/****** Object:  StoredProcedure [dbo].[pruebaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[pruebaB]
as
begin
select
'DetalleId|UM¬100|120¬String|String¬'+
(select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+
p.ProductoUM
from DetalleGuia d
inner join Producto p
on p.IdProducto=d.IdProducto
for XML path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[pruebaC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[pruebaC]
as
begin
select
'DocuId|IdProducto|Codigo|Descripcion|Cantidad|UM|Precio|Importe|NotaId¬100|100|140|350|100|100|110|110|100¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+p.ProductoUM+'|'+
convert(varchar(50),cast(d.DetallPrecio as money),1)+'|'+
convert(varchar(50),cast(d.DetalleImporte as money),1)+'|'+
convert(varchar,d.DetalleNotaId)
FROM DetalleDocumento d
inner join Producto p
on p.IdProducto=d.IdProducto
where d.DocuId BETWEEN 11224 AND 12540
order by d.DocuId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[pruebaD]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[pruebaD]
as
begin
select
'DetalleId|UM¬100|120¬String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+
p.ProductoUM
from DetallePedido d
inner join Producto p
on p.IdProducto=d.IdProducto
for XML path('')),1,1,'')),'~')+'['+
'DocuId|IdProducto|Codigo|Descripcion|Cantidad|UM|Precio|Importe|NotaId¬100|100|140|350|100|100|110|110|100¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+p.ProductoUM+'|'+
convert(varchar(50),cast(d.DetallPrecio as money),1)+'|'+
convert(varchar(50),cast(d.DetalleImporte as money),1)+'|'+
convert(varchar,d.DetalleNotaId)
FROM DetalleDocumento d
inner join Producto p
on p.IdProducto=d.IdProducto
where d.DocuId BETWEEN 11224 AND 12540
order by d.DocuId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[reporteGanancia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reporteGanancia] 
@anno int
as
begin
select 'Numero|Mes|Ventas|G_Ventas|Gastos|G_Liquida¬80|100|110|110|105|110¬String|String|String|String|String|String¬'+
(select STUFF((select '¬'+ convert(varchar,isnull(a.Numero,g.Numero))+'|'+convert(varchar,ISNULL(a.Mes,g.Mes))+'|'+
	CONVERT(VarChar(50), cast(isnull(a.Ventas,0) as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(isnull(a.Ganancia,0)as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(isnull(g.Gastos,0) as money ), 1)+'|'+
	CONVERT(VarChar(50), cast((isnull(a.Ganancia,0)-isnull(g.Gastos,0)) as money ), 1)
	from	
(select month(n.NotaFecha) as Numero,DATENAME(month,n.NotaFecha) as Mes,sum(n.NotaPagar) as Ventas,
sum(n.NotaGanancia)- SUM(n.NotaDescuento)as Ganancia --GANANCIA
from 
	NotaPedido n(noLOCK) 
	where n.NotaEstado='CANCELADO' and YEAR(n.NotaFecha)=@anno
	group by month(n.NotaFecha),DATENAME(month,n.NotaFecha))a
full join(
	select month(g.GastoFecha) as Numero,DATENAME(month,g.GastoFecha) as Mes,SUM(g.GstoMonto) as Gastos 
	from GastosFijos g (noLOCK) --GASTOS
	where YEAR(g.GastoFecha)=@anno
	group by month(g.GastoFecha),DATENAME(month,g.GastoFecha)
)g on a.Numero=g.Numero
order by a.Numero desc,g.Numero desc
FOR XML PATH('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[reporteGananciaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reporteGananciaB] 
@Mes int,
@anno int
as
begin
select isnull(a.Numero,g.Numero) as Numero,ISNULL(a.Mes,g.Mes) as Mes,
CONVERT(VarChar(50), cast(isnull(v.TotalVenta,0) as money ), 1) as TotalVenta,
CONVERT(VarChar(50), cast((isnull(a.Ganancia,0))as money ), 1) as G_Ventas,
CONVERT(VarChar(50), cast(isnull(g.Gastos,0) as money ), 1) as Gatos,
CONVERT(VarChar(50), cast((isnull(a.Ganancia,0)-isnull(g.Gastos,0)) as money ), 1) as G_Liquida
from
(select month(n.NotaFecha) as Numero,DATENAME(month,n.NotaFecha) as Mes,
sum(n.NotaGanancia)- SUM(n.NotaDescuento) as Ganancia--ganancia
from 
NotaPedido n
where n.NotaEstado='CANCELADO' and (MONTH(n.NotaFecha)=@Mes and YEAR(n.NotaFecha)=@anno)
group by month(n.NotaFecha),DATENAME(month,n.NotaFecha))a
full join(
select month(g.GastoFecha) as Numero,DATENAME(month,g.GastoFecha) as Mes,SUM(g.GstoMonto) as Gastos 
from GastosFijos g--gastos
where(Month(g.GastoFecha)=@Mes and YEAR(g.GastoFecha)=@anno)
group by month(g.GastoFecha),DATENAME(month,g.GastoFecha)
)g on a.Numero=g.Numero
full join(select month(n.NotaFecha) as Numero,
DATENAME(month,n.NotaFecha) as Mes,SUM(n.NotaPagar) as TotalVenta 
from NotaPedido n--total venta
where (Month(n.NotaFecha)=@Mes and YEAR(n.NotaFecha)=@anno) and n.NotaEstado='CANCELADO'
group by month(n.NotaFecha),DATENAME(month,n.NotaFecha)
)v on a.Numero=v.Numero
group by a.Numero,g.Numero,a.Mes,g.Mes,v.TotalVenta,a.Ganancia,g.Gastos
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[reportePDT]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reportePDT]
@CompaniaId int,
@Mes int,
@Anno int
as
begin
select isnull(b.CompaniaId,isnull(S.CompaniaId,isnull(d.CompaniaId,isnull(x.CompaniaId,z.CompaniaId)))) as CompaniaId,
convert(varchar(50),cast((ISNULL(b.Monto,0))as money),1) as Ventas,
convert(varchar(50),cast((ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0))as money),1) as Compras
from
(
select d.CompaniaId,sum(d.DocuTotal) as Monto--VENTASSS
from DocumentoVenta d
where d.CompaniaId=@companiaId and(month(d.DocuEmision)=@Mes and year(d.DocuEmision)=@Anno)and (d.DocuDocumento<>'PROFORMA V' AND d.DocuDocumento<>'NOTA PEDIDO') and d.DocuEstado<>'ANULADO'
group by d.CompaniaId
)b
full join(
select c.CompaniaId,sum(c.CompraTotal) as Monto
from Compras c--FACTURAS EN SOLES
where c.CompaniaId=@companiaId and(month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='01' and c.CompraMoneda='SOLES')
group by c.CompaniaId
)s on b.CompaniaId=s.CompaniaId
full join
(select c.CompaniaId,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
from Compras c--FACTURAS EN DOLARES
where c.CompaniaId=@companiaId and (month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='01' and c.CompraMoneda='DOLARES')
group by c.CompaniaId
)d on b.CompaniaId=d.CompaniaId
full join(
select c.CompaniaId,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
from Compras c--nota de credito en dolares
where c.CompaniaId=@companiaId and(month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='07' and c.CompraMoneda='DOLARES')
group by c.CompaniaId
)x on b.CompaniaId=x.CompaniaId
full join (
select c.CompaniaId,sum(c.CompraTotal) as Monto
from Compras c--nota de credito en soles
where c.CompaniaId=@companiaId and(month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='07' and c.CompraMoneda='SOLES')
group by c.CompaniaId
)z on b.CompaniaId=z.CompaniaId
end
GO
/****** Object:  StoredProcedure [dbo].[reporteVentaCompania]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reporteVentaCompania]    
@Mes int,    
@Anno int    
as    
begin    
select top 3 isnull(b.CompaniaId,isnull(S.CompaniaId,isnull(d.CompaniaId,isnull(x.CompaniaId,z.CompaniaId)))) as CompaniaId,    
ISNULL(b.RazonSocial,isnull(S.RazonSocial,isnull(d.RazonSocial,isnull(x.RazonSocial,z.RazonSocial))))as RazonSocial,    
convert(varchar(50),cast((ISNULL(b.Monto,0))as money),1) as Ventas,    
convert(varchar(50),cast(((ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0)))as money),1) as Compras    
from    
(    
select top 3 c.CompaniaId,c.CompaniaRazonSocial as RazonSocial,    
sum(d.DocuTotal) as Monto--VENTASSS    
from DocumentoVenta d    
inner join Compania c    
on c.CompaniaId=d.CompaniaId    
where month(d.DocuEmision)=@Mes and year(d.DocuEmision)=@Anno and   
(d.DocuDocumento<>'PROFORMA V' AND d.DocuDocumento<>'NOTA PEDIDO' AND d.DocuDocumento<>'NOTA DE CREDITO') and d.DocuAsociado=''    
group by c.CompaniaId,c.CompaniaRazonSocial    
)b    
full join(    
select TOP 3 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,sum(c.CompraTotal) as Monto    
from Compras c--FACTURAS EN SOLES    
inner join Compania co    
on co.CompaniaId=c.CompaniaId    
where month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno  
AND(c.TipoCodigo='01' and c.CompraMoneda='SOLES')    
group by co.CompaniaId,co.CompaniaRazonSocial    
)s on b.CompaniaId=s.CompaniaId    
full join    
(select TOP 3 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto    
from Compras c--FACTURAS EN DOLARES    
inner join Compania co    
on co.CompaniaId=c.CompaniaId    
where month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno  
AND(c.TipoCodigo='01' and c.CompraMoneda='DOLARES')    
group by co.CompaniaId,co.CompaniaRazonSocial    
)d on b.CompaniaId=d.CompaniaId    
full join(    
select TOP 3 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto    
from Compras c--nota de credito en dolares    
inner join Compania co    
on co.CompaniaId=c.CompaniaId    
where month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno  
AND(c.TipoCodigo='07' and c.CompraMoneda='DOLARES')    
group by co.CompaniaId,co.CompaniaRazonSocial    
)x on b.CompaniaId=x.CompaniaId    
full join (    
select TOP 3 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,sum(c.CompraTotal) as Monto    
from Compras c--nota de credito en soles    
inner join Compania co    
on co.CompaniaId=c.CompaniaId    
where month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno  
AND(c.TipoCodigo='07' and c.CompraMoneda='SOLES')    
group by co.CompaniaId,co.CompaniaRazonSocial    
)z on b.CompaniaId=z.CompaniaId    
end
GO
/****** Object:  StoredProcedure [dbo].[respaldoBD]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[respaldoBD]
as
begin
declare @fecha varchar(max)
declare @hora varchar(max)
declare @archivo varchar(max)

set @fecha=CONVERT(Varchar(10),GETDATE(),105)
set @hora=REPLACE(CONVERT(varchar(10), GETDATE(), 108),':','-')
set @archivo='C:\Users\HP\OneDrive\Bakup\ROSITA-'+@fecha+'-'+@hora+'.bak'--'D:\Archivo_Sistema\Backup\ROSITA-'+@fecha+'-'+@hora+'.bak'

BACKUP DATABASE ROSITA TO DISK=@archivo
WITH FORMAT,
NAME='ROSITA';
end
GO
/****** Object:  StoredProcedure [dbo].[rptCompraA]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[rptCompraA]
as
begin
select c.CompraId,Convert(char(10),c.CompraEmision,103) as FechaEmision,c.CompraSerie+'-'+c.CompraNumero as Documento,
p.ProveedorRuc as RUC,p.ProveedorRazon as RazonSocial,c.TipoCodigo as TipoCodigo,
case when c.CompraMoneda='DOLARES' THEN
CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else  CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
end as SubTotal,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
end as IGV,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end as Total,c.CompraMoneda as Moneda,c.CompraTipoSunat as TipoSunat,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Monto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
end
GO
/****** Object:  StoredProcedure [dbo].[rptCompraComputo]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[rptCompraComputo] @fechainicio date,@fechafin date,@CompaniaId int
as
begin
select c.CompraId,Convert(char(10),c.CompraEmision,103) as FechaEmision,c.CompraSerie+'-'+c.CompraNumero as Documento,
p.ProveedorRuc as RUC,p.ProveedorRazon as RazonSocial,c.TipoCodigo as TipoCodigo,
case when c.CompraMoneda='DOLARES' THEN
CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else  CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
end as SubTotal,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
end as IGV,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end as Total,c.CompraMoneda as Moneda,c.CompraTipoSunat as TipoSunat,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Monto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
where (Convert(char(10),c.CompraComputo,103) BETWEEN @fechainicio AND @fechafin) and (c.TipoCodigo='01' or c.TipoCodigo='07') and c.CompaniaId=@CompaniaId
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[rptCompraEmision]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[rptCompraEmision] @fechainicio date,@fechafin date,@CompaniaId int
as
begin
select c.CompraId,Convert(char(10),c.CompraEmision,103) as FechaEmision,c.CompraSerie+'-'+c.CompraNumero as Documento,
p.ProveedorRuc as RUC,p.ProveedorRazon as RazonSocial,c.TipoCodigo as TipoCodigo,
case when c.CompraMoneda='DOLARES' THEN
CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else  CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
end as SubTotal,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
end as IGV,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end as Total,c.CompraMoneda as Moneda,c.CompraTipoSunat as TipoSunat,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Monto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
where (Convert(char(10),c.CompraEmision,103) BETWEEN @fechainicio AND @fechafin) and (c.TipoCodigo='01' or c.TipoCodigo='07') and c.CompaniaId=@CompaniaId
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[rptMes]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[rptMes]
@Mes int,
@Anno int
as 
begin
select
'Dia|Fecha|Venta|Ganancia|Gastos|GananciaLQ|FechaExacta¬80|105|103|103|103|103|100¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+
convert(varchar,isnull(a.Dia,b.Dia))+'|'+convert(varchar,isnull(a.Fecha,b.Fecha))+'|'+
convert(varchar(50),cast(isnull(a.VentaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(b.Gastos,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)-isnull(b.Gastos,0)as money),1)+'|'+
convert(varchar,isnull(a.FechaExacta,b.FechaExacta))
from
(select DAY(n.NotaFecha) as Dia,
dbo.diaNombre(n.NotaFecha)+' '+convert(nvarchar,DAY(n.NotaFecha)) as Fecha,
SUM(n.NotaPagar)as VentaTotal,
SUM(NotaGanancia)- SUM(n.NotaDescuento) as GananciaTotal,convert(varchar,n.NotaFecha,103) as FechaExacta
from NotaPedido n
where (month(n.NotaFecha)=@Mes and year(n.NotaFecha)=@Anno) and n.NotaEstado='CANCELADO'
group by DAY(n.NotaFecha),dbo.diaNombre(n.NotaFecha),convert(varchar,n.NotaFecha,103))a
full join(
	select DAY(g.GastoFecha) as Dia,
	dbo.diaNombre(g.GastoFecha)+' '+convert(nvarchar,DAY(g.GastoFecha)) as Fecha,
	SUM(g.GstoMonto) as Gastos,convert(varchar,g.GastoFecha,103) as FechaExacta
	from GastosFijos g (noLOCK) 
	where (month(g.GastoFecha)=@Mes and year(g.GastoFecha)=@Anno)
	group by DAY(g.GastoFecha),dbo.diaNombre(g.GastoFecha),convert(varchar,g.GastoFecha,103)
)b on a.Dia=b.Dia
order by a.Dia DESC
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[rptSemanal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[rptSemanal]
@Fecha date,
@Anno int
as
begin
declare @NumSemana int
set @NumSemana=(select DATEPART(WK,@Fecha))
select
'Dia|Fecha|Venta|Ganancia|Gastos|GananciaLQ|FechaExacta¬80|105|103|103|103|103|100¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+
convert(varchar,isnull(a.Dia,b.Dia))+'|'+convert(varchar,isnull(a.Fecha,b.Fecha))+'|'+
convert(varchar(50),cast(isnull(a.VentaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(b.Gastos,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)-isnull(b.Gastos,0)as money),1)+'|'+
convert(varchar,isnull(a.FechaExacta,b.FechaExacta))
from
(select DAY(n.NotaFecha) as Dia,
dbo.diaNombre(n.NotaFecha)+' '+convert(nvarchar,DAY(n.NotaFecha)) as Fecha,
SUM(n.NotaPagar)as VentaTotal,
SUM(NotaGanancia)- SUM(n.NotaDescuento) as GananciaTotal,
convert(varchar,n.NotaFecha,103) as FechaExacta
from NotaPedido n
where ((DATEPART(WK,n.NotaFecha)=@NumSemana)and year(n.NotaFecha)=@Anno) and n.NotaEstado='CANCELADO'
group by DAY(n.NotaFecha),dbo.diaNombre(n.NotaFecha),convert(varchar,n.NotaFecha,103))a
full join(
	select DAY(g.GastoFecha) as Dia,
	dbo.diaNombre(g.GastoFecha)+' '+convert(nvarchar,DAY(g.GastoFecha)) as Fecha,
	SUM(g.GstoMonto) as Gastos,convert(varchar,g.GastoFecha,103) as FechaExacta 
	from GastosFijos g (noLOCK) 
	where((DATEPART(WK,g.GastoFecha)=@NumSemana) and YEAR(g.GastoFecha)=@Anno)
    group by DAY(g.GastoFecha),dbo.diaNombre(g.GastoFecha),convert(varchar,g.GastoFecha,103)
)b on a.Dia=b.Dia
order by a.Dia ASC
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[rptVendedor]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rptVendedor]   
@Mes INT,  
@ANNO INT  
as  
begin 
select
'Personal|Clientes|Ventas|SubTotal|IGV|Ganancia|ImpRenta|Descuento|DesTotal|GLiquida¬185|105|125|125|125|125|125|125|125|125¬String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+isnull(a.Usuario,b.Usuario)+'|'+  
convert(varchar,ISNULL(a.Cliente,0))+'|'+  
convert(varchar(50),cast((isnull(a.Venta,0)) as money),1)+'|'+--converiertes a moneda y despues conviertes a texto
convert(varchar(50),cast(((isnull(b.Ganancia,0)/1.18))as money),1)+'|'+
convert(varchar(50),cast((isnull(b.Ganancia,0)-(cast((isnull(b.Ganancia,0)/1.18)as decimal(18,2))))as money),1)+'|'+   
convert(varchar(50),cast((isnull(b.Ganancia,0))as money),1)+'|'+ 
convert(varchar(50),cast((cast((isnull(a.Venta,0)* 0.01) as decimal(18,2)))as money),1)+'|'+   
convert(varchar(50),cast((isnull(a.Descuento,0))as money),1)+'|'+   
convert(varchar(50),cast(((cast((isnull(b.Ganancia,0)-(cast((isnull(b.Ganancia,0)/1.18)as decimal(18,2))))as decimal(18,2))+  
cast((isnull(a.Venta,0)* 0.01) as decimal(18,2)))+isnull(a.Descuento,0))as money),1)+'|'+   
convert(varchar(50),cast((isnull(b.Ganancia,0)-((cast((isnull(b.Ganancia,0)-(cast((isnull(b.Ganancia,0)/1.18)as decimal(18,2))))as decimal(18,2))+cast((isnull(a.Venta,0)* 0.01) as decimal(18,2)))+isnull(a.Descuento,0)))as money),1)
from   
(  
	select n.NotaUsuario as Usuario,COUNT(ClienteId) as Cliente,SUM(n.NotaPagar) as Venta,SUM(n.NotaDescuento) as Descuento  
	from NotaPedido n (NOLOCK) 
	where (
		month(n.NotaFecha)=@Mes and
		YEAR(n.NotaFecha)=@ANNO) and
		n.NotaEstado='CANCELADO'
	group by n.NotaUsuario)a  
	FULL join(
	select n.NotaUsuario as Usuario,sum(n.NotaGanancia) as Ganancia--cast(Sum((d.DetallePrecio - d.DetalleCosto) * d.DetalleCantidad)as decimal(18,2)) as Ganancia  --ok
	--from DetallePedido d (NOLOCK) 
	--inner join 
	from NotaPedido n  (NOLOCK) 
	--on n.NotaId=d.NotaId
	where (month(n.NotaFecha)=@Mes and 
	YEAR(n.NotaFecha)=@ANNO) and 
	n.NotaEstado='CANCELADO'  
	group by n.NotaUsuario  
)b on a.Usuario=b.Usuario  
group by a.Usuario,b.Usuario,a.Cliente,a.Venta,a.Descuento,b.Ganancia  
order by a.Cliente desc 
for xml path('')),1,1,'')),'~') 
end
GO
/****** Object:  StoredProcedure [dbo].[spPrueba]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spPrueba]
as
begin
select 
'Codigo|Descipcion|Stock|UM|Costo|Dolar¬130|470|105|105|105|105¬String|String|Decimal|String|Decimal|Decimal¬'+
(select STUFF((select'¬'+p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1)+'|'+
p.ProductoUM+'|'+CONVERT(VarChar(50), cast(p.ProductoCosto as money ), 1)+'|'+CONVERT(VarChar(50), cast(p.ProductoCostoDolar as money ), 1)
from Producto p
where p.ProductoCantidad < = p.ValorCritico
order by p.ProductoNombre+' '+p.ProductoMarca asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[TipoCambioFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[TipoCambioFecha] 
@fechainicio date,
@fechafin date
as
begin
select
'ID|Fecha|COMPRA|VENTA|EMPRESA¬90|110|108|108|117¬String|String|String|String|String¬'+
(select STUFF((select '¬'+ convert(varchar,t.IdTipo),+'|'+
(Convert(char(10),t.TipoFecha,103))+'|'+convert(varchar,t.TipoCompra)+'|'+
convert(varchar,t.TipoVenta)+'|'+
convert(varchar,t.TipoEmpresa) 
from TipoCambio t 
where t.TipoFecha BETWEEN @fechainicio AND @fechafin 
order by t.TipoFecha asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[totalLetras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[totalLetras] @numero decimal(18,2),@Moneda varchar(60)
as
begin
select dbo.letras(@numero,@Moneda) as letras
end
GO
/****** Object:  StoredProcedure [dbo].[traerProducto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[traerProducto]     
@codigo varchar(80)    
as    
begin    
SELECT p.IdProducto,l.NombreLinea,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,    
p.ProductoMarca,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,p.ProductoCantidad,     
p.ProductoUM,p.ProductoVenta,p.ProductoVentaB,p.ProductoCosto,ProductoCostoDolar,ProductoTipoCambio,      
a.AlmacenNombre,p.ProductoUbicacion,p.ProductoEstado,p.ProductoUsuario,    
p.ProductoFecha,p.ProductoImagen,AplicaTC,AplicaFB,AplicaINV,MaxCantVen    
FROM Producto p    
INNER JOIN Sublinea s    
ON p.IdSubLinea =s.IdSubLinea     
INNER JOIN Linea l    
ON s.IdLinea =l.IdLinea     
INNER JOIN Almacen a    
ON p.AlmacenId =a.AlmacenId    
where p.ProductoCodigo=@codigo and p.ProductoEstado='BUENO'    
order by p.IdProducto desc    
end
GO
/****** Object:  StoredProcedure [dbo].[traerProductoING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[traerProductoING]
@Codigo varchar(100)
as
begin
select          
	isnull((select STUFF ((select top 1 '¬'+                  
	convert(varchar,p.IdProducto)+'|'+p.ProductoUM+'|'+
	p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+
	convert(varchar,p.ProductoCosto)+'|'+convert(varchar,p.ProductoCostoDolar)          
	from Producto p         
	where p.ProductoCodigo=@Codigo     
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[traerProductoStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[traerProductoStock]
@Codigo varchar(100)
as
begin
select          
	isnull((select STUFF ((select top 1 '¬'+                  
	convert(varchar,s.IdStock)+'|'+convert(varchar,s.ValorUM)+'|'+p.ProductoUM+'|'+      
	convert(varchar,s.IdProducto)           
	from Stock s                  
	inner join Producto p          
	on p.IdProducto=s.IdProducto          
	where p.ProductoCodigo=@Codigo     
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[upsKardexFechaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[upsKardexFechaB]
@Id numeric(38),
@fechainicio date,@fechafin date
as
begin
	select 
	'KardexId|IdStock|FechaMovimiento|Motivo|Documento|StockInicial|CantidadIngre|CantidadSali|StockFinal|Concepto|Responsable¬100|100|145|260|145|115|115|115|115|100|160¬String|String|String|String|String|String|String|String|String|String|String¬'+
	isnull((select STUFF ((select '¬'+convert(varchar,k.KardexId)+'|'+CONVERT(varchar,k.IdStock)+'|'+
	(IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+
	k.KardexMotivo+'|'+k.KardexDocumento+'|'+
	CONVERT(VarChar(50), cast(k.StockInicial as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadSalida as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.StockFinal as money ), 1)+'|'+
	K.KadexConcepto+'|'+k.Usuario
	from KardexAlmacen k with(nolock)
	where k.IdStock=@Id and (Convert(char(10),k.KardexFecha,103) BETWEEN @fechainicio AND @fechafin)
	order by k.KardexId desc
    for xml path('')),1,1,'')),'~')
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[usp_eliminaDetaCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_eliminaDetaCaja]              
@ListaOrden varchar(Max)              
as              
begin              
Declare @posA1 int,@posA2 int,@posA3 int      
Declare @orden varchar(max),      
        @detalle varchar(max),      
        @Guia varchar(max)      
Set @posA1 = CharIndex('[',@ListaOrden,0)      
Set @posA2 = CharIndex('[',@ListaOrden,@posA1+1)      
Set @posA3 =Len(@ListaOrden)+1      
Set @orden = SUBSTRING(@ListaOrden,1,@posA1-1)      
Set @detalle = SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)      
Set @Guia=SUBSTRING(@ListaOrden,@posA2+1,@posA3-@posA2-1)          
Declare @c1 int,@c2 int,@c3 int,@c4 int,                
        @c5 int,@c6 int,@c7 int,@c8 int              
Declare @DetalleId numeric(38),                
  @NotaId numeric(38),              
  @Monto decimal(18,2),              
  @Concepto varchar(80),                
  @Justificacion varchar(300),                
  @Usuario varchar(80),                
  @Autoriza varchar(80),                
  @CajaId varchar(38)             
Set @c1 = CharIndex('|',@orden,0)                
Set @c2 = CharIndex('|',@orden,@c1+1)                
Set @c3 = CharIndex('|',@orden,@c2+1)                
Set @c4 = CharIndex('|',@orden,@c3+1)                
Set @c5 = CharIndex('|',@orden,@c4+1)                
Set @c6 = CharIndex('|',@orden,@c5+1)               
Set @c7 = CharIndex('|',@orden,@c6+1)                
Set @c8 = Len(@orden)+1                
                
set @DetalleId=convert(numeric(38),SUBSTRING(@orden,1,@c1-1))              
set @NotaId=convert(numeric(38),SUBSTRING(@orden,@c1+1,@c2-@c1-1))                
set @Monto=convert(decimal(18,2),SUBSTRING(@orden,@c2+1,@c3-@c2-1))                
set @Concepto=SUBSTRING(@orden,@c3+1,@c4-@c3-1)                
set @Justificacion=SUBSTRING(@orden,@c4+1,@c5-@c4-1)              
set @Usuario=SUBSTRING(@orden,@c5+1,@c6-@c5-1)              
set @Autoriza=SUBSTRING(@orden,@c6+1,@c7-@c6-1)                
set @CajaId=SUBSTRING(@orden,@c7+1,@c8-@c7-1)              
              
Begin Transaction              
              
declare @Acuenta decimal(18,2),              
  @Documento varchar(40),@EstadoDocu varchar(80)                
declare @Data varchar(60)                
declare @n1 int,@n2 int                
              
update NotaPedido                
set NotaSaldo=NotaSaldo + @Monto,NotaAcuenta=NotaAcuenta-@Monto                
where NotaId=@NotaId              
                
set @Acuenta=(select NotaAcuenta from NotaPedido where NotaId=@NotaId)                
set @Data=isnull((select top 1 d.DocuDocumento+'¬'+d.DocuEstado from DocumentoVenta d where d.NotaId=@NotaId order by DocuId desc),'0¬0')                
Set @Data = LTRIM(RTrim(@Data))                
Set @n1 = CharIndex('¬',@Data,0)                
Set @n2 = Len(@Data)+1                
Set @Documento=SUBSTRING(@Data,1,@n1-1)                
Set @EstadoDocu=SUBSTRING(@Data,@n1+1,@n2-@n1-1)              
              
              
if @EstadoDocu='ANULADO'                
begin                
update NotaPedido                 
set NotaEstado='ANULADO'                
where NotaId=@NotaId                
end                
else                
begin                
if(@Documento='FACTURA' or @Documento='BOLETA')                
begin                
if @Acuenta<=0                
begin                
update NotaPedido                 
set NotaEstado='EMITIDO'                
where NotaId=@NotaId                
end                
else                
begin                
update NotaPedido                 
set NotaEstado='ACUENTA'                
where NotaId=@NotaId                
end                
END                
else                
begin                
if @Acuenta<=0                
begin                
update NotaPedido                 
set NotaEstado='PENDIENTE'                
where NotaId=@NotaId                
end                
else                
begin                
update NotaPedido                 
set NotaEstado='ACUENTA'                
where NotaId=@NotaId                
end                
end                
end                
              
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'ELIMINA VENTA',                
@Concepto,@Justificacion,@Monto,@Usuario,@Autoriza,convert(varchar,@NotaId))                
               
              
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')                 
Open Tabla              
Declare @Columna varchar(max),               
  @IdProducto numeric(20),                
  @KardexMotivo  varchar(60),       
  @KardexDocumento varchar(60),                
  @CantidadIngreso decimal(18, 2),                
  @CantidadSalida decimal(18, 2),                
  @PrecioCosto decimal(18,4),                
  @Vendedor varchar(60),        
  @Estado nvarchar(1)          
Declare @p1 int,@p2 int,@p3 int,@p4 int,                
        @p5 int,@p6 int,@p7 int,@p8 int              
                     
Fetch Next From Tabla INTO @Columna                
While @@FETCH_STATUS = 0                
Begin                
Set @p1 = CharIndex('|',@Columna,0)                
Set @p2 = CharIndex('|',@Columna,@p1+1)                
Set @p3 = CharIndex('|',@Columna,@p2+1)                
Set @p4 = CharIndex('|',@Columna,@p3+1)                
Set @p5 = CharIndex('|',@Columna,@p4+1)                
Set @p6= CharIndex('|',@Columna,@p5+1)                 
Set @p7= CharIndex('|',@Columna,@p6+1)               
Set @p8=Len(@Columna)+1               
               
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))                
Set @KardexMotivo=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))                
Set @KardexDocumento=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))                
Set @CantidadIngreso=convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))                
Set @CantidadSalida=convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))                
Set @PrecioCosto=convert(decimal(18,4),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))              
Set @Vendedor=SUBSTRING(@Columna,@p6+1,@p7-(@p6+1))        
Set @Estado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))              
        
if(@Estado='E')        
begin             
declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)                 
set @IniciaStock=(select top 1 p.ProductoCantidad                 
from Producto p (nolock)                
where p.IdProducto=@IdProducto)              
              
set @StockFinal=@IniciaStock+@CantidadIngreso                
                
insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,                  
@CantidadIngreso,@CantidadSalida,@PrecioCosto,@StockFinal,'INGRESO',@Usuario)                
                 
update producto                   
set  ProductoCantidad =ProductoCantidad + @CantidadIngreso              
where IDProducto=@IdProducto        
        
end         
               
Fetch Next From Tabla INTO @Columna                
end                
 Close Tabla;                
 Deallocate Tabla;  
 delete from CajaDetalle                 
 where DetalleId=@DetalleId 
 --Commit Transaction;              
 --select 'true'    
 if(len(@Guia)>0)      
begin      
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')       
Open TablaB      
Declare @ColumnaB varchar(max)    
Declare @g1 int,@g2 int,    
        @g3 int,@g4 int,@g5 int    
    
Declare @CantidadA decimal(18,2),     
        @IdProductoU numeric(20),                     
        @CantidadU decimal(18,2),                        
        @UmU varchar(40),                                                       
        @ValorUMU decimal(18,4)    
    
Declare @IniciaStockB decimal(18,2),    
        @StockFinalB decimal(18,2)    
              
Fetch Next From TablaB INTO @ColumnaB      
 While @@FETCH_STATUS = 0      
 Begin      
Set @g1 = CharIndex('|',@ColumnaB,0)                       
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                        
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                        
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                        
Set @g5=Len(@ColumnaB)+1       
     
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))    
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))    
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))      
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))      
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))          
    
 Declare @CantidadSalB decimal(18,2)     
    
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                
                    
 set @IniciaStockB=(select top 1 p.ProductoCantidad     
 from Producto p where p.IdProducto=@IdProductoU)                        
     
 set @StockFinalB=@IniciaStockB + @CantidadSalB                       
                 
 insert into Kardex values(@IdProductoU,GETDATE(),'Anulacion por Venta',@KardexDocumento,@IniciaStockB,              
 @CantidadSalB,0,0,@StockFinalB,'INGRESO',@Usuario)                          
                   
 update producto                         
 set  ProductoCantidad =ProductoCantidad + @CantidadSalB                       
 where IDProducto=@IdProductoU        
    
Fetch Next From TablaB INTO @ColumnaB      
end      
    Close TablaB;      
    Deallocate TablaB;      
    Commit Transaction;      
    select 'true'    
end      
else      
begin      
    Commit Transaction;      
    select 'true'    
End             
            
END
GO
/****** Object:  StoredProcedure [dbo].[usp_insertarDetaCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_insertarDetaCaja]                
@ListaOrden varchar(Max)                
as                
begin                
Declare @pos1 int,@pos2 int,@pos3 int                
Declare @orden varchar(max),                
        @detalle varchar(max),                
        @Guia varchar(max)                
Set @pos1 = CharIndex('[',@ListaOrden,0)                
Set @pos2 = CharIndex('[',@ListaOrden,@pos1+1)                
Set @pos3 =Len(@ListaOrden)+1                
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)                
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)                
Set @Guia=SUBSTRING(@ListaOrden,@pos2+1,@pos3-@pos2-1)              
Declare @c1 int,@c2 int,@c3 int,@c4 int,                  
        @c5 int,@c6 int,@c7 int,@c8 int,                  
        @c9 int,@c10 int               
Declare @CajaId varchar(40),                  
  @NotaId numeric(38),                  
  @Movimiento varchar(80),                  
  @Referencia varchar(80),                  
  @Concepto varchar(250),                  
  @Monto decimal(18,2),                  
  @Efectivo decimal(18,2),                  
  @Vuelto decimal(18,2),                
  @Usuario varchar(80),
  @UsuarioId int              
Set @c1 = CharIndex('|',@orden,0)                  
Set @c2 = CharIndex('|',@orden,@c1+1)                  
Set @c3 = CharIndex('|',@orden,@c2+1)                  
Set @c4 = CharIndex('|',@orden,@c3+1)                  
Set @c5 = CharIndex('|',@orden,@c4+1)                  
Set @c6= CharIndex('|',@orden,@c5+1)                  
Set @c7 = CharIndex('|',@orden,@c6+1)                  
Set @c8 = CharIndex('|',@orden,@c7+1)
Set @c9 = CharIndex('|',@orden,@c8+1)                    
Set @c10 = Len(@orden)+1                  
                  
set @CajaId=convert(numeric(38),SUBSTRING(@orden,1,@c1-1))                  
set @NotaId=convert(numeric(38),SUBSTRING(@orden,@c1+1,@c2-@c1-1))                  
set @Referencia=SUBSTRING(@orden,@c2+1,@c3-@c2-1)                  
set @Movimiento=SUBSTRING(@orden,@c3+1,@c4-@c3-1)                  
set @Concepto=SUBSTRING(@orden,@c4+1,@c5-@c4-1)                  
set @Monto=convert(decimal(18,2),SUBSTRING(@orden,@c5+1,@c6-@c5-1))                
set @Efectivo=convert(decimal(18,2),SUBSTRING(@orden,@c6+1,@c7-@c6-1))                  
set @Vuelto=convert(decimal(18,2),SUBSTRING(@orden,@c7+1,@c8-@c7-1))                  
set @Usuario=SUBSTRING(@orden,@c8+1,@c9-@c8-1)
set @UsuarioId=SUBSTRING(@orden,@c9+1,@c10-@c9-1)              
                

Declare @Asistencia int
set @Asistencia=(select COUNT(a.PersonalId)from Asistencia a    
inner join Usuarios u    
on u.PersonalId=a.PersonalId    
where u.UsuarioID=@UsuarioId and (Day(a.Fecha)=Day(GETDATE()) and Month(a.Fecha)=MONTH(GETDATE()) and year(a.Fecha)=year(GETDATE())))    
if(@Asistencia=0)    
begin    
Select 'NO ASISTIO'    
end    
else
begin

Begin Transaction        
declare @saldoA decimal(18,2)  
                  
insert into CajaDetalle values(                  
@CajaId,GETDATE(),@NotaId,@Movimiento,                  
@Referencia,@Concepto,                  
@Monto,@Efectivo,@Vuelto,'','T','',@Usuario,'','')                  
                  
update NotaPedido                   
set NotaSaldo=NotaSaldo - @Monto,NotaAcuenta=NotaAcuenta+@Monto                  
where NotaId=@NotaId                  
                
set @saldoA=(select n.NotaSaldo                 
from NotaPedido n (nolock)                 
where n.NotaId=@NotaId)                 
                 
if (@saldoA<=0)                  
begin                  
 update NotaPedido                   
 set NotaEstado='CANCELADO',CajaId=@CajaId                  
 where NotaId=@NotaId                  
end                  
else                  
begin                  
 update NotaPedido                   
 set NotaEstado='ACUENTA',CajaId=@CajaId                  
 where NotaId=@NotaId                  
end                
  
if(len(@detalle)>0)                
begin             
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')                   
Open Tabla                
Declare @Columna varchar(max),                 
  @IdProducto numeric(20),                  
  @KardexMotivo  varchar(60),                  
  @KardexDocumento varchar(60),                  
  @CantidadIngreso decimal(18,2),                  
  @CantidadSalida decimal(18,2),                  
  @PrecioCosto decimal(18,4),                  
  @Vendedor varchar(60),            @Estado nvarchar(1)           
Declare @p1 int,@p2 int,@p3 int,@p4 int,                  
        @p5 int,@p6 int,@p7 int,@p8 int                
                       
Fetch Next From Tabla INTO @Columna  
While @@FETCH_STATUS = 0                  
Begin                  
Set @p1 = CharIndex('|',@Columna,0)                  
Set @p2 = CharIndex('|',@Columna,@p1+1)                  
Set @p3 = CharIndex('|',@Columna,@p2+1)                  
Set @p4 = CharIndex('|',@Columna,@p3+1)                  
Set @p5 = CharIndex('|',@Columna,@p4+1)                  
Set @p6= CharIndex('|',@Columna,@p5+1)          
Set @p7= CharIndex('|',@Columna,@p6+1)                 
Set @p8=Len(@Columna)+1                
                 
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))                  
Set @KardexMotivo=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))                  
Set @KardexDocumento=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))                  
Set @CantidadIngreso=convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))                  
Set @CantidadSalida=convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))                  
Set @PrecioCosto=convert(decimal(18,4),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))                
Set @Vendedor=SUBSTRING(@Columna,@p6+1,@p7-(@p6+1))          
Set @Estado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))                  
          
if(@Estado='E')          
begin                
declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)                   
set @IniciaStock=(select top 1 p.ProductoCantidad                   
from Producto p (nolock)                  
where p.IdProducto=@IdProducto)                  
                
set @StockFinal=@IniciaStock-@CantidadSalida                  
                
insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,                    
@CantidadIngreso,@CantidadSalida,@PrecioCosto,@StockFinal,'SALIDA',@Vendedor)                  
                   
update producto                     
set  ProductoCantidad =ProductoCantidad - @CantidadSalida                  
where IDProducto=@IdProducto          
          
end            
          
Fetch Next From Tabla INTO @Columna                  
end                  
 Close Tabla;              
 Deallocate Tabla;  
End  
   
if(len(@Guia)>0)                
begin                
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')                 
Open TablaB                
Declare @ColumnaB varchar(max)              
Declare @g1 int,@g2 int,              
        @g3 int,@g4 int,@g5 int              
              
Declare @CantidadA decimal(18,2),               
        @IdProductoU numeric(20),                               
        @CantidadU decimal(18,2),                                  
        @Um varchar(40),                                                                 
        @ValorUMU decimal(18,4)              
              
Declare @IniciaStockB decimal(18,2),              
        @StockFinalB decimal(18,2)              
                        
Fetch Next From TablaB INTO @ColumnaB                
 While @@FETCH_STATUS = 0                
 Begin                
Set @g1 = CharIndex('|',@ColumnaB,0)                                 
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                                  
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                                  
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                                  
Set @g5=Len(@ColumnaB)+1                 
               
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))              
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))              
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))                
Set @Um=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))                
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))                    
              
 Declare @CantidadSalB decimal(18,2)               
              
set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                          
                              
 set @IniciaStockB=(select top 1 p.ProductoCantidad               
 from Producto p where p.IdProducto=@IdProductoU)                                  
               
 set @StockFinalB=@IniciaStockB-@CantidadSalB                                 
       
 insert into Kardex values(@IdProductoU,GETDATE(),'Salida por Venta',@KardexDocumento,@IniciaStockB,                                  
 0,@CantidadSalB,0,@StockFinalB,'SALIDA',@Vendedor)                                  
                             
 update producto                            
 set  ProductoCantidad =ProductoCantidad - @CantidadSalB                         
 where IDProducto=@IdProductoU                  
              
Fetch Next From TablaB INTO @ColumnaB                
end                
    Close TablaB;                
    Deallocate TablaB;                 
END  
    Commit Transaction;              
    select 'true'             
end
end
GO
/****** Object:  StoredProcedure [dbo].[usp_validarStoock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_validarStoock]  
@detalle varchar(max)  
as                  
begin     
  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')                     
Open Tabla                  
Declare @Columna varchar(max),                   
  @IdProducto numeric(20),                                    
  @Cantidad decimal(18,2),                    
  @UnidadM varchar(40),                
  @Descripcion varchar(max),  
  @rpt varchar(max)='' 
    
Declare @p1 int,@p2 int,@p3 int,@p4 int  
  
Fetch Next From Tabla INTO @Columna    
While @@FETCH_STATUS = 0                    
Begin                    
Set @p1 = CharIndex('|',@Columna,0)                    
Set @p2 = CharIndex('|',@Columna,@p1+1)                    
Set @p3 = CharIndex('|',@Columna,@p2+1)                                     
Set @p4=Len(@Columna)+1                  
                   
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))                    
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))                    
Set @UnidadM=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))                    
Set @Descripcion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))    
    
declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)                     
set @IniciaStock=(select top 1 p.ProductoCantidad                     
from Producto p (nolock)                    
where p.IdProducto=@IdProducto)  
  
  
if(@Cantidad>@IniciaStock)  
begin  
set @rpt=@rpt+'No tiene stock de '+@Descripcion+', Actualmente tiene '+convert(varchar,@IniciaStock)+' '+@UnidadM+' ,' 
end    
  
Fetch Next From Tabla INTO @Columna                    
end                    
 Close Tabla;                
 Deallocate Tabla;  
 if(@rpt='')
 begin
 select 'true'
 end
 else
 begin
   Select @rpt 
 end
End
GO
/****** Object:  StoredProcedure [dbo].[uspAnularNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAnularNC]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
declare @1 int,@2 int,@3 int,@4 int,@5 int
declare @DocuId numeric(38),@NotaId numeric(38),
@DocuUsuario varchar(80),@DocuAsociado varchar(80),@KardexDocu varchar(80)
Set @orden= LTRIM(RTrim(@orden))
Set @1 = CharIndex('|',@orden,0)
Set @2 = CharIndex('|',@orden,@1+1)
Set @3 = CharIndex('|',@orden,@2+1)
Set @4 = CharIndex('|',@orden,@3+1)
Set @5 = Len(@orden)+1
Set @DocuId=convert(numeric(38),SUBSTRING(@orden,1,@1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@1+1,@2-@1-1))
Set @DocuUsuario=SUBSTRING(@orden,@2+1,@3-@2-1)
Set @DocuAsociado=SUBSTRING(@orden,@3+1,@4-@3-1)
Set @KardexDocu=SUBSTRING(@orden,@4+1,@5-@4-1)
Begin Transaction
update DocumentoVenta
set DocuSubTotal=0,DocuIgv=0,DocuTotal=0,DocuSaldo=0,DocuUsuario=@DocuUsuario,DocuEstado='ANULADO'
where DocuId=@DocuId
update DocumentoVenta
set DocuAsociado=''
where DocuId=@DocuAsociado
 Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@Importe decimal(18,2),
		@DetalleNotaId numeric(38),
		@UM varchar(80),
		@ValorUM decimal(18,4),
		@StockInicial decimal(18,2),
		@StockFinal decimal(18,2),@CantidadSal decimal(18,2)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,1,@p1-1))
Set @UM=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
set @StockInicial=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)
set @CantidadSal=(@Cantidad*@ValorUM)
set @StockFinal=@StockInicial-@CantidadSal
update Producto
set ProductoCantidad=ProductoCantidad-@CantidadSal
where IdProducto=@IdProducto
insert into Kardex
values(@IdProducto,GETDATE(),'Anulacion por Nota Credito',@KardexDocu,@StockInicial,0,@CantidadSal,@Precio,@StockFinal,'SALIDA',@DocuUsuario)
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+
c.ClienteDni+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
where d.TipoCodigo='07'and (Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate()))
order by d.DocuId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaCompania]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAsistenciaCompania]  
@Id int,  
@fechainicio date,  
@fechafin date  
as  
Begin  
select   
'Id|Fecha|Dia|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|Estado|NroTardanza¬90|100|100|100|220|125|125|125|125|90|100¬String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+  
convert(char(10),a.Fecha,103)+'|'+dbo.diaNombre(a.Fecha)+'|'+  
Convert(varchar,a.PersonalId)+'|'+  
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),''),''+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+  
a.Estado+'|'+convert(varchar,a.NroTardanza)  
from Asistencia a  
inner join Personal p  
on p.PersonalId=a.PersonalId  
where p.CompaniaId=@Id and (Convert(char(10),a.Fecha,103) BETWEEN @fechainicio AND @fechafin)  
order by a.Fecha asc  
for XMl path('')),1,1,'')),'~')  
End
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaDia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAsistenciaDia]  
@fechainicio date,  
@fechafin date  
as  
Begin  
select   
'Id|Fecha|Dia|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|Estado|NroTardanza¬90|100|100|100|220|125|125|125|125|90|100¬String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+  
convert(char(10),a.Fecha,103)+'|'+dbo.diaNombre(a.Fecha)+'|'+  
Convert(varchar,a.PersonalId)+'|'+  
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),''),''+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+  
a.Estado+'|'+convert(varchar,a.NroTardanza)  
from Asistencia a  
inner join Personal p  
on p.PersonalId=a.PersonalId   
where Convert(char(10),a.Fecha,103) BETWEEN @fechainicio AND @fechafin  
order by a.Fecha asc  
for XMl path('')),1,1,'')),'~')  
End
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaInsertaCsv]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAsistenciaInsertaCsv]  
@PersonalId int  
as  
Begin  
Declare @Data varchar(max)  
Declare @NroMarca int,  
        @Id numeric(38)  
Declare @p1 int,@p2 int  
IF NOT EXISTS(select a.PersonalId  from Asistencia a  
where a.PersonalId=@PersonalId and a.Fecha=convert(date,GETDATE()))  
begin  
  
Declare @DiaActual nvarchar(20)  
Declare @HoraIngreso time(7)  
set @DiaActual=(select dbo.diaNombre(getdate()))  
set @HoraIngreso=isnull((select t.Turno from DetalleTurnos d  
inner join Turnos t  
on t.TurnoId=d.TurnoId  
where d.PersonalId=@PersonalId and d.Dia=@DiaActual),'08:10:00')  
  
Declare @DetalleId numeric(38)  
Declare @Aviso nvarchar(1)  
Declare @NroTardanza int  
declare @UltimoNro int  
set @UltimoNro=isnull((select top 1 a.NroTardanza from Asistencia a  
where a.PersonalId=@PersonalId and Month(a.Fecha)=MONTH(GETDATE()) and YEAR(a.Fecha)=year(getdate())  
order by a.Id desc),0) 

declare @FechaSalida varchar(40)
set @FechaSalida=convert(varchar,GETDATE(),103)+' '+ isnull(SUBSTRING(convert(varchar,'18:00:00',114),1,8),'')

declare @salidaReal datetime
set @salidaReal=@FechaSalida
 
insert into Asistencia values(convert(date,GETDATE()),@PersonalId,GETDATE(),null,null,@salidaReal,1,'',@UltimoNro,'A')  
set @DetalleId=(select @@IDENTITY)  
set @Aviso=isnull((  
select top 1 case when(convert(time,a.HoraIngreso) > @HoraIngreso) then  
'T' else 'A' end   
from Asistencia a  
inner join Personal p  
on p.PersonalId=a.PersonalId  
where a.PersonalId=@PersonalId and   
Month(a.Fecha)=MONTH(GETDATE()) and YEAR(a.Fecha)=year(getdate()) and a.Id=@DetalleId  
order by a.Id desc),'A')  
if(@Aviso='T')  
begin  
update Asistencia  
set NroTardanza=@UltimoNro+1,Estado='T'  
where Id=@DetalleId  
end  
Select 'true'  
end  
else  
begin  
set @Data=(select convert(varchar,a.Id)+'|'+convert(varchar,a.NroMarcacion)   
from Asistencia a  
where a.PersonalId=@PersonalId and a.Fecha=convert(date,GETDATE()))  
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = Len(@Data)+1  
Set @Id=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @NroMarca=convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
if(@NroMarca=1)  
--begin  
--update Asistencia  
--set SalidaRefrigerio=GETDATE(),NroMarcacion=2  
--where Id=@Id  
--select 'R1'  
--end  
--else if(@NroMarca=2)  
--begin  
--update Asistencia  
--set IngresoRefrigerio=GETDATE(),NroMarcacion=3  
--where Id=@Id  
--select 'R2'  
--end  
----else if(@NroMarca=3)  
----begin  
----update Asistencia  
----set HoraSalida=GETDATE(),NroMarcacion=4  
----where Id=@Id  
----select 'S'  
----end  
--else  
begin  
select 'completo'  
end  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaListaCsv]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAsistenciaListaCsv]  
as  
Begin  
select   
'Id|Fecha|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|NroMar|HoraING|HoraREF¬90|100|100|220|125|125|125|125|70|90|90¬String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+  
convert(varchar,a.Fecha,103)+'|'+  
Convert(varchar,a.PersonalId)+'|'+  
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),''),''+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+  
Convert(varchar,a.NroMarcacion)+'|'+a.Estado+'|A'  
--case when (convert(time,a.IngresoRefrigerio) > DATEADD(minute,60,(convert(time,a.SalidaRefrigerio)))) then  
--'T' else 'A' end  
from Asistencia a  
inner join Personal p  
on p.PersonalId=a.PersonalId  
where DAY(a.Fecha)=DAY(GETDATE())and Month(a.Fecha)=Month(GETDATE())and year(a.Fecha)=YEAR(Getdate())  
order by a.Id desc  
for XMl path('')),1,1,'')),'~')  
End
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaPersonal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAsistenciaPersonal]  
@Id numeric(20),  
@fechainicio date,  
@fechafin date  
as  
Begin  
select   
'Id|Fecha|Dia|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|Estado|NroTardanza¬90|100|100|100|220|125|125|125|125|90|100¬String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+  
convert(char(10),a.Fecha,103)+'|'+dbo.diaNombre(a.Fecha)+'|'+  
Convert(varchar,a.PersonalId)+'|'+  
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+  
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),''),''+'|'+  
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+  
a.Estado+'|'+convert(varchar,a.NroTardanza)  
from Asistencia a  
inner join Personal p  
on p.PersonalId=a.PersonalId  
where a.PersonalId=@Id and (Convert(char(10),a.Fecha,103) BETWEEN @fechainicio AND @fechafin) 
order by a.Fecha asc  
for XMl path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+
c.CompaniaRazonSocial
from Personal p
inner join Compania c
on c.CompaniaId=p.CompaniaId
where p.PersonalId=@Id 
for XMl path('')),1,1,'')),'~')
End
GO
/****** Object:  StoredProcedure [dbo].[uspBuscarProING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspBuscarProING]        
@Descripcion varchar(80)       
as        
begin        
select top 100 p.IdProducto as IdStock,p.IdProducto,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,'' as Cantidad,        
CONVERT(VarChar(max),cast(p.ProductoCantidad as money ), 1) as Stock,p.ProductoUM as UM,p.ProductoVenta as PrecioVenta,1 as ValorUM,      
p.ProductoImagen as Imagen      
from Producto p(nolock)              
where p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%' and p.ProductoEstado='BUENO'        
union all(        
select top 100 u.IdProducto as IdStock,u.IdProducto,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,'' as Cantidad,        
CONVERT(VarChar(max),cast((p.ProductoCantidad/u.ValorUM) as money ), 1) as Stock,u.UMDescripcion as UM,u.PrecioVenta as PrecioVenta,u.ValorUM as ValorUM,      
p.ProductoImagen as Imagen      
from UnidadMedida u (nolock)                
inner join Producto p (nolock)      
on u.IdProducto=p.IdProducto      
where p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%' and p.ProductoEstado='BUENO')        
order by 3 asc        
end
GO
/****** Object:  StoredProcedure [dbo].[uspBuscarStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspBuscarStock]        
@Descripcion varchar(80),        
@AlmacenId int        
as        
begin        
select top 100 s.IdStock,s.IdProducto,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,'' as Cantidad,        
CONVERT(VarChar(max),cast(s.Cantidad as money ), 1) as Stock,p.ProductoUM as UM,p.ProductoVenta as PrecioVenta,1 as ValorUM,      
p.ProductoImagen as Imagen      
from Stock s (nolock)     
inner join Producto p(nolock)        
on s.IdProducto=p.IdProducto         
where s.AlmacenId=@AlmacenId and (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%') and s.Estado='BUENO'        
union all(        
select top 100 s.IdStock,u.IdProducto,p.ProductoNombre+' '+p.ProductoMarca as Descripcion,'' as Cantidad,        
CONVERT(VarChar(max),cast((s.Cantidad/u.ValorUM) as money ), 1) as Stock,u.UMDescripcion as UM,u.PrecioVenta as PrecioVenta,u.ValorUM as ValorUM,      
p.ProductoImagen as Imagen      
from UnidadMedida u (nolock)        
inner join Stock s  (nolock)       
on s.IdProducto=u.IdProducto        
inner join Producto p (nolock)     
on s.IdProducto=p.IdProducto      
where s.AlmacenId=@AlmacenId and (p.ProductoNombre+' '+p.ProductoMarca like'%'+@Descripcion+'%')and s.Estado='BUENO')        
order by 3 asc        
end
GO
/****** Object:  StoredProcedure [dbo].[uspCajaInsertaCsv]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspCajaInsertaCsv]  
@Data varchar(max)  
as  
Begin  
Declare @p1 int,@p2 int,@p3 int,  
        @p4 int,@p5 int,@p6 int,  
        @p7 int,@p8 int,@p9 int,  
        @p10 int,@p11 int,@p12 int,  
        @p13 int,@p14 int,@p15 int,  
        @p16 int,@p17 int  
Declare @CajaId  numeric(38),@CajaCierre  varchar(40),  
        @MontoIniSOl  decimal(18,2),@CajaEncargado  varchar(60),  
        @CajaUsuario  varchar(60),@CajaEstado  varchar(40),@CajaIngresos  decimal(18,2),  
        @CajaDeposito  decimal(18,2),@CajaSalidas  decimal(18,2),@CajaTotal  decimal(18,2),  
        @UsuarioId  int,@CantCajas int,@SerieFactura varchar(10),@Asistencia int,  
        @Observacion varchar(max),@Monedas decimal(18,2),  
        @CajaIdZ nvarchar(40),@AvisoS int,@Justificacion varchar(max),  
        @Admin varchar(80)  
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2=CharIndex('|',@Data,@p1+1)  
Set @p3=CharIndex('|',@Data,@p2+1)  
Set @p4=CharIndex('|',@Data,@p3+1)  
Set @p5=CharIndex('|',@Data,@p4+1)  
Set @p6=CharIndex('|',@Data,@p5+1)  
Set @p7=CharIndex('|',@Data,@p6+1)  
Set @p8=CharIndex('|',@Data,@p7+1)  
Set @p9=CharIndex('|',@Data,@p8+1)  
Set @p10=CharIndex('|',@Data,@p9+1)  
Set @p11=CharIndex('|',@Data,@p10+1)  
Set @p12=CharIndex('|',@Data,@p11+1)  
Set @p13=CharIndex('|',@Data,@p12+1)  
  
Set @p14=CharIndex('|',@Data,@p13+1)  
Set @p15=CharIndex('|',@Data,@p14+1)  
Set @p16=CharIndex('|',@Data,@p15+1)  
  
Set @p17= Len(@Data)+1  
  
Set @CajaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @CajaCierre=SUBSTRING(@Data,@p1+1,@p2-@p1-1)  
Set @MontoIniSOl=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))  
Set @CajaEncargado=SUBSTRING(@Data,@p3+1,@p4-@p3-1)  
Set @CajaUsuario=SUBSTRING(@Data,@p4+1,@p5-@p4-1)  
Set @CajaEstado=SUBSTRING(@Data,@p5+1,@p6-@p5-1)  
Set @CajaIngresos=convert(decimal(18,2),SUBSTRING(@Data,@p6+1,@p7-@p6-1))  
Set @CajaDeposito=convert(decimal(18,2),SUBSTRING(@Data,@p7+1,@p8-@p7-1))  
Set @CajaSalidas=convert(decimal(18,2),SUBSTRING(@Data,@p8+1,@p9-@p8-1))  
Set @CajaTotal=convert(decimal(18,2),SUBSTRING(@Data,@p9+1,@p10-@p9-1))  
Set @UsuarioId=convert(int,SUBSTRING(@Data,@p10+1,@p11-@p10-1))  
Set @Observacion=SUBSTRING(@Data,@p11+1,@p12-@p11-1)  
Set @Monedas=SUBSTRING(@Data,@p12+1,@p13-@p12-1)  
Set @CajaIdZ=SUBSTRING(@Data,@p13+1,@p14-@p13-1)  
  
Set @AvisoS=convert(int,SUBSTRING(@Data,@p14+1,@p15-@p14-1))  
Set @Justificacion=SUBSTRING(@Data,@p15+1,@p16-@p15-1)  
Set @Admin=SUBSTRING(@Data,@p16+1,@p17-@p16-1)  
  
  
if(@CajaId=0)  
begin  
IF EXISTS(select top 1 CajaId from Caja   
where CajaEstado='ACTIVO' order by 1 desc) --and UsuarioId=@UsuarioId  
begin  
select 'existe'  
end  
else  
begin  
Declare @CajaIdB nvarchar(40)  
  
insert into MAYOLICA.dbo.Caja values(GETDATE(),'',0,  
@CajaEncargado,@CajaUsuario,@CajaEstado,@CajaIngresos,@CajaDeposito,  
@CajaSalidas,@CajaTotal,16,@Observacion)  
set @CajaIdB=convert(nvarchar,@@identity)  
  
insert into Caja values(GETDATE(),@CajaCierre,@MontoIniSOl,  
@CajaEncargado,@CajaUsuario,@CajaEstado,@CajaIngresos,@CajaDeposito,  
@CajaSalidas,@CajaTotal,@UsuarioId,@Observacion,@CajaIdB)  
set @CajaId=@@identity  
  
insert into CajaPincipal values('SALIDA',GETDATE(),@CajaId,'SENCILLO PARA LA CAJA NRO '+CONVERT(varchar,@CajaId),  
@MontoIniSOl,@CajaUsuario,0,'SENCILLO','-')  
  
insert into CajaPincipal values('INGRESO',GETDATE(),@CajaId,'INGRESO DE CAJA CHICA',  
0,@CajaUsuario,0,'INGRESO','')  
  
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'APERTURA',  
'NUEVA CAJA',@CajaEncargado+' APERTURO NUEVA CAJA NRO-'+convert(varchar,@CajaId),@MontoIniSOl,@CajaEncargado,@CajaUsuario,'')  
  
insert into CajaDetalle values(@CajaId,GETDATE(),0,'INGRESO','','TOTAL EFECTIVO',0,0,0,'','T','V',@CajaUsuario,'','')  
insert into CajaDetalle values(@CajaId,GETDATE(),0,'INGRESO','','SENCILLO',0,0,0,'','T','V',@CajaUsuario,'','')  
insert into CajaDetalle values(@CajaId,GETDATE(),0,'INGRESO','','VENTA TOTAL DE MAYOLICA',0,0,0,'','T','V',@CajaUsuario,'','')  
insert into Monedas values(0,0,'200.00',0,'B',@CajaId)  
insert into Monedas values(0,0,'100.00',0,'B',@CajaId)  
insert into Monedas values(0,0,'50.00',0,'B',@CajaId)  
insert into Monedas values(0,0,'20.00',0,'B',@CajaId)  
insert into Monedas values(0,0,'10.00',0,'B',@CajaId)  
insert into Monedas values(0,0,'5.00',0,'M',@CajaId)  
insert into Monedas values(0,0,'2.00',0,'M',@CajaId)  
insert into Monedas values(0,0,'1.00',0,'M',@CajaId)  
insert into Monedas values(0,0,'0.50',0,'M',@CajaId)  
insert into Monedas values(0,0,'0.20',0,'M',@CajaId)  
insert into Monedas values(0,0,'0.10',0,'M',@CajaId)  
Select 'true'  
end  
end  
else  
begin  
UPDATE CajaPincipal  
SET CajaMonto=@MontoIniSOl  
WHERE CajaId=@CajaId AND Referencia='SENCILLO'  
UPDATE CajaPincipal  
SET CajaMonto=@Monedas  
WHERE CajaId=@CajaId AND Referencia='INGRESO'  
update Caja  
set CajaCierre=@CajaCierre,MontoIniSOl=@MontoIniSOl,  
CajaEncargado=@CajaEncargado,CajaUsuario=@CajaUsuario,  
CajaEstado=@CajaEstado,CajaIngresos=@CajaIngresos,CajaDeposito=@CajaDeposito,  
CajaSalidas=@CajaSalidas,CajaTotal=@CajaTotal,UsuarioId=@UsuarioId,  
observacion=@Observacion  
where CajaId=@CajaId  
update MAYOLICA.dbo.Caja  
set CajaCierre=@CajaCierre,CajaEstado=@CajaEstado  
where CajaId=@CajaIdZ  
  
if(@AvisoS=1)  
begin  
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'MODIFICA',  
'EDITA SENSILLO',@Justificacion+' DE LA CAJA NRO-'+convert(varchar,@CajaId),@MontoIniSOl,@CajaEncargado,@Admin,'-')  
end  
if(@CajaEstado='CERRADA')  
begin  
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'CIERRE',  
'CIERRE DE CAJA',@CajaEncargado+' CIERRA LA CAJA NRO-'+convert(varchar,@CajaId),@CajaTotal,@CajaEncargado,@Admin,'-')  
end  
  
Select 'true'  
  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspCuentaProve]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspCuentaProve]
@ProveedorId numeric(38)
as
select 
'Id|EntidadBancaria|TipoCuenta|Moneda|NroCuenta¬100|250|140|95|250¬String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.CuentaId)+'|'+c.Entidad+'|'+
c.TipoCuenta+'|'+c.Moneda+'|'+c.NroCuenta
from CuentaProveedor c
where c.ProveedorId=@ProveedorId
order by c.CuentaId desc
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[uspDesanular]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDesanular]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
declare @pos3 int
Declare @DocuId numeric(38),
@NotaId numeric(38),
@Usuario varchar(40),
@Estado varchar(40)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @pos3 =Len(@Data)+1
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @Usuario=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
update DocumentoVenta
set DocuUsuario=@Usuario,DocuEstado='EMITIDO'
where DocuId=@DocuId
IF EXISTS(select top 1 NotaId from CajaDetalle where NotaId=@NotaId)set @Estado='CANCELADO'
ELSE set @Estado='PENDIENTE'
update NotaPedido
set NotaUsuario=@Usuario,NotaEstado=@Estado
Where NotaId=@NotaId
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescontinuados]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescontinuados]
as
begin
select 
'IdProducto|Codigo|Descripcion|Cantidad|UM|PrecioVenta|PrecioVentaB|Costo|CostoDola|TipoCambio|Estado|Usuario|Imagen¬100|135|380|100|85|100|100|100|100|100|120|150|100¬String|String|String|String|String|String|String|Decimal|Decimal|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,p.IdProducto)+'|'+p.ProductoCodigo+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+ 
p.ProductoUM+'|'+convert(varchar(50),cast(p.ProductoVenta as money),1)+'|'+
convert(varchar(50),cast(p.ProductoVentaB as money),1)+'|'+convert(varchar,p.ProductoCosto)+'|'+
convert(varchar,ProductoCostoDolar)+'|'+convert(varchar,ProductoTipoCambio)+'|'+
p.ProductoEstado+'|'+p.ProductoUsuario+'|'+p.ProductoImagen
FROM Producto p with(nolock)
where p.ProductoEstado='DESCONTINUADO'
order by p.ProductoNombre+' '+p.ProductoMarca asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescontinuadosStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescontinuadosStock]  
as  
begin  
select   
'IdStock|Codigo|Descripcion|Cantidad|UM|Estado|Usuario|Imagen¬100|135|380|100|100|150|150|100¬String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+convert(varchar,s.IdStock)+'|'+p.ProductoCodigo+'|'+  
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar(50),cast(s.Cantidad as money),1)+'|'+   
p.ProductoUM+'|'+s.Estado+'|'+s.Usuario+'|'+p.ProductoImagen  
FROM Producto p with(nolock)
inner join Stock s
on s.IdProducto=p.IdProducto  
where s.Estado='DESCONTINUADO'  
order by p.ProductoNombre+' '+p.ProductoMarca asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescuento]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescuento]
@detalle varchar(Max)
as
begin
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @TemporalId numeric(38),
		@Descuento decimal(18,4)
Declare @p1 int,@p2 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = Len(@Columna)+1
Set @TemporalId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Descuento=Convert(decimal(18,4),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
update TemporalCompra 
set DetalleDescuento=@Descuento 
where TemporalId=@TemporalId		
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescuentoB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescuentoB]
@detalle varchar(Max)
as
begin
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @DetalleId numeric(38),
		@Descuento decimal(18,4)
Declare @p1 int,@p2 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = Len(@Columna)+1
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Descuento=Convert(decimal(18,4),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
update DetalleCompra 
set DetalleDescuento=@Descuento
where DetalleId=@DetalleId	
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspDetalleNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDetalleNC]
@DocuId numeric(38)
as
begin
select
'Cantidad|UM|Descripcion|Precio|Importe|DetalleId|IdProducto|valorUM|PrecioSunat|IGVPrecio|ImporteSunat|Codigo¬103|100|350|110|115|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+
d.DetalleUM+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+
CONVERT(VarChar(50), cast(d.DetallPrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
convert(varchar,d.DetalleNotaId)+'|'+convert(varchar,d.IdProducto)+'|'+
convert(varchar,d.ValorUM)+'|'+
convert(varchar,convert(decimal(18,2),d.DetallPrecio/1.18))+'|'+
convert(varchar,(d.DetalleImporte - convert(decimal(18,2),d.DetalleImporte/1.18)))+'|'+
convert(varchar,convert(decimal(18,2),d.DetalleImporte/1.18))+'|'+
P.ProductoCodigo
from DetalleDocumento d
inner join Producto p
on p.IdProducto=d.IdProducto
where DocuId=@DocuId
order by d.DetalleId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEdicionSalidaAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEdicionSalidaAlmacen]
@Data varchar(max)
as
begin 
Declare @NotaId numeric(38),
        @UsuarioID int
Declare @p1 int,@p2 int
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = Len(@Data)+1
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @UsuarioID=convert(int,SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Select
isnull((select STUFF((select '¬' +convert(varchar,t.IdProducto)
from  DetallePedido t
INNER join Stock S
ON S.IdProducto=T.IdProducto
INNER JOIN Producto P
ON P.IdProducto=s.IdProducto
where t.NotaId=@NotaId and(t.IdProducto NOT IN (select a.IdProducto 
from DetalleStock a
where a.NotaId=@NotaId)and p.ProductoCantidad<=0)
order by t.DetalleId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaBonificacion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaBonificacion]
@Data varchar(max)
as
begin
Declare @p1 int
Declare @p2 int
Declare @p3 int
declare @TemporalId numeric(38),
@Estado varchar(20),
@UsuarioID int
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 =Len(@Data)+1
Set @TemporalId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @Estado=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Set @UsuarioID=convert(int,SUBSTRING(@Data,@p2+1,@p3-@p2-1))
update TemporalCompra 
set PrecioCosto=0,DetalleImporte=0,DetalleDescuento=0,
DetalleEstado=@Estado 
where TemporalId=@TemporalId
select
isnull((select STUFF ((select '¬'+convert(varchar,t.TemporalId)+'|'+convert(varchar,t.IdProducto)+'|'+
t.DetalleCodigo+'|'+t.Descripcion+'|'+t.DetalleUM+'|'+
CONVERT(VarChar(50),cast(t.DetalleCantidad as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)+'|'+convert(varchar,t.DetalleDescuento)
+'|'+convert(varchar,t.DetalleImporte)+'|'+CONVERT(varchar,t.ValorUM)+'|'+
t.DetalleEstado
from TemporalCompra t 
inner join Producto p 
on p.IdProducto=t.IdProducto 
where t.UsuarioID=@UsuarioID
order by t.TemporalId asc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaDocNro]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaDocNro]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,@p3 int,@p4 int
Declare @DocuId numeric(38),@DocuNumero varchar(80),
@DocuEmision date,@DocuUsuario varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = Len(@Data)+1 
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @DocuNumero=SUBSTRING(@Data,@p1+1,@p2-@p1-1) 
Set @DocuEmision=convert(date,SUBSTRING(@Data,@p2+1,@p3-@p2-1))
Set @DocuUsuario=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
update DocumentoVenta
set DocuNumero=@DocuNumero,DocuEmision=@DocuEmision,
DocuUsuario=@DocuUsuario
where DocuId=@DocuId
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaDocu]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaDocu]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
declare @pos3 int
declare @pos4 int
Declare @DocuId numeric(38),
@Numero varchar(40),
@DocuEmision date,
@Usuario varchar(40)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @Numero=SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1)
Set @pos3= CharIndex('|',@Data,@pos2+1)
Set @DocuEmision=convert(date,SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4= Len(@Data)+1
Set @Usuario=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
update DocumentoVenta
set DocuNumero=@Numero,DocuEmision=@DocuEmision,DocuUsuario=@Usuario
where DocuId=@DocuId
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarCreditoCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEditarCreditoCompra]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,@p3 int,
        @p4 int,@p5 int,@p6 int,
        @p7 int,@p8 int,@p9 int
Declare @CompraId numeric(38),@CompraCorrelativo varchar(80),
		@CompraEmision date,@CompraComputo date,
		@CompraSerie varchar(60),@CompraNumero varchar(80),
		@CompraTipoSunat decimal(18,3),@CompraTipoCambio decimal(18,3),
		@CompraUsuario varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5 = CharIndex('|',@Data,@p4+1)
Set @p6 =CharIndex('|',@Data,@p5+1)
Set @p7 = CharIndex('|',@Data,@p6+1)
Set @p8 =CharIndex('|',@Data,@p7+1)
Set @p9= Len(@Data)+1
Set @CompraId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CompraCorrelativo=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Set @CompraComputo=convert(date,SUBSTRING(@Data,@p2+1,@p3-@p2-1))
Set @CompraEmision=convert(date,SUBSTRING(@Data,@p3+1,@p4-@p3-1))
Set @CompraSerie=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
Set @CompraNumero=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
Set @CompraTipoSunat=convert(decimal(18,3),SUBSTRING(@Data,@p6+1,@p7-@p6-1))
Set @CompraTipoCambio=convert(decimal(18,3),SUBSTRING(@Data,@p7+1,@p8-@p7-1))
Set @CompraUsuario=SUBSTRING(@Data,@p8+1,@p9-@p8-1)
update Compras
set CompraCorrelativo=@CompraCorrelativo,CompraComputo=@CompraComputo,
CompraEmision=@CompraEmision,CompraSerie=@CompraSerie,CompraNumero=@CompraNumero,
CompraTipoCambio=@CompraTipoCambio,CompraTipoSunat=@CompraTipoSunat,
CompraUsuario=@CompraUsuario
where CompraId=@CompraId
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarGuiaING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEditarGuiaING]    
@Data varchar(Max)    
as    
begin    
Declare @p1 int,@p2 int,    
        @p3 int,@p4 int,@p5 int,    
        @p6 int,@p7 int,@p8 int,    
        @p9 int,@p10 int    
Declare @GuiaId numeric(38),@GuiaConcepto varchar(40),    
        @GuiaMotivo varchar(80),@GuiaObservacion varchar(max),    
  @GuiaResponsable varchar(80),@GuiaUsuario varchar(80),    
  @RazonSocial varchar(300),@GuiaDoc varchar(40),    
  @GuiaDocNumero varchar(80)  
Set @p1 = CharIndex('|',@Data,0)    
Set @p2 = CharIndex('|',@Data,@p1+1)    
Set @p3 = CharIndex('|',@Data,@p2+1)    
Set @p4 = CharIndex('|',@Data,@p3+1)    
Set @p5= CharIndex('|',@Data,@p4+1)    
Set @p6= CharIndex('|',@Data,@p5+1)    
Set @p7= CharIndex('|',@Data,@p6+1)    
Set @p8= CharIndex('|',@Data,@p7+1)    
Set @p9= Len(@Data)+1    
Set @GuiaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))    
Set @GuiaConcepto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)    
Set @GuiaMotivo=SUBSTRING(@Data,@p2+1,@p3-@p2-1)    
Set @GuiaObservacion=SUBSTRING(@Data,@p3+1,@p4-@p3-1)    
Set @GuiaResponsable=SUBSTRING(@Data,@p4+1,@p5-@p4-1)    
Set @GuiaUsuario=SUBSTRING(@Data,@p5+1,@p6-@p5-1)    
Set @RazonSocial=SUBSTRING(@Data,@p6+1,@p7-@p6-1)    
Set @GuiaDoc=SUBSTRING(@Data,@p7+1,@p8-@p7-1)    
Set @GuiaDocNumero=SUBSTRING(@Data,@p8+1,@p9-@p8-1)     
update GuiaIngreso    
set GuiaConcepto=@GuiaConcepto,GuiaMotivo=@GuiaMotivo,
GuiaObservacion=@GuiaObservacion,GuiaUsuario=@GuiaUsuario,    
RazonSocial=@RazonSocial,GuiaDoc=@GuiaDoc,GuiaDocNumero=@GuiaDocNumero   
where GuiaId=@GuiaId    
select 'true'    
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarGuiaStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEditarGuiaStock]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,
        @pos3 int,@pos4 int,
        @pos5 int
Declare 
		@Cliente varchar(300),@GuiaResponsable varchar(80),
		@NotaId varchar(80),@GuiaId numeric(38),
		@GuiaDoc varchar(40),@GuiaDocNumero varchar(80)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3= CharIndex('|',@orden,@pos2+1)
Set @pos4 = CharIndex('|',@orden,@pos3+1)
Set @pos5= Len(@orden)+1
Set @Cliente=SUBSTRING(@orden,1,@pos1-1)
Set @GuiaResponsable=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)
Set @NotaId=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set @GuiaDoc=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Set @GuiaDocNumero=SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1)
set @GuiaId=(select top 1 GuiaId from GuiaAlmacen where NotaId=@NotaId)
Begin Transaction
update GuiaAlmacen
set GuiaRegistro=GETDATE(),GuiaResponsable=@GuiaResponsable,RazonSocial=@Cliente,
GuiaUsuario=@GuiaResponsable,GuiaDoc=@GuiaDoc,GuiaDocNumero=@GuiaDocNumero
where NotaId=@NotaId
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdStock numeric(38),
		@Cantidad decimal(18,2),
		@ValorUM decimal(18,4),
		@IniciaStock decimal(18,2),
		@StockFinal decimal(18,4),
		@CantValor  decimal(18,4)
Declare @p1 int,@p2 int,
        @p3 int,@p4 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3= Len(@Columna)+1
Set @IdStock=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
set @IniciaStock=(select top 1 Cantidad from Stock(nolock) where IdStock=@IdStock)
set @CantValor=(@Cantidad*@ValorUM)
set @StockFinal=@IniciaStock-@CantValor
insert into KardexAlmacen values(@IdStock,GETDATE(),'SALIDA POR VENTA',convert(varchar,@GuiaId),@IniciaStock,
0,@CantValor,@StockFinal,'SALIDA',@GuiaResponsable)
update Stock
set Cantidad=@StockFinal
where IdStock=@IdStock
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	update DetalleStock
	set ESTADO='E'
	where NotaId=@NotaId
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarGuiaStockA]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEditarGuiaStockA]  
@Data varchar(Max)  
as  
begin  
Declare @p1 int,@p2 int,  
        @p3 int,@p4 int,@p5 int,  
        @p6 int,@p7 int,@p8 int,  
        @p9 int,@p10 int  
Declare @GuiaId numeric(38),@GuiaConcepto varchar(40),  
        @GuiaMotivo varchar(80),@GuiaObservacion varchar(max),  
  @GuiaResponsable varchar(80),@GuiaUsuario varchar(80),  
  @RazonSocial varchar(300),@GuiaDoc varchar(40),  
  @GuiaDocNumero varchar(80)
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = CharIndex('|',@Data,@p3+1)  
Set @p5= CharIndex('|',@Data,@p4+1)  
Set @p6= CharIndex('|',@Data,@p5+1)  
Set @p7= CharIndex('|',@Data,@p6+1)  
Set @p8= CharIndex('|',@Data,@p7+1)  
Set @p9= Len(@Data)+1  
Set @GuiaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @GuiaConcepto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)  
Set @GuiaMotivo=SUBSTRING(@Data,@p2+1,@p3-@p2-1)  
Set @GuiaObservacion=SUBSTRING(@Data,@p3+1,@p4-@p3-1)  
Set @GuiaResponsable=SUBSTRING(@Data,@p4+1,@p5-@p4-1)  
Set @GuiaUsuario=SUBSTRING(@Data,@p5+1,@p6-@p5-1)  
Set @RazonSocial=SUBSTRING(@Data,@p6+1,@p7-@p6-1)  
Set @GuiaDoc=SUBSTRING(@Data,@p7+1,@p8-@p7-1)  
Set @GuiaDocNumero=SUBSTRING(@Data,@p8+1,@p9-@p8-1)   
update GuiaAlmacen  
set GuiaConcepto=@GuiaConcepto,GuiaMotivo=@GuiaMotivo,GuiaObservacion=@GuiaObservacion,  
	GuiaResponsable=@GuiaResponsable,GuiaUsuario=@GuiaUsuario,  
	RazonSocial=@RazonSocial,GuiaDoc=@GuiaDoc,GuiaDocNumero=@GuiaDocNumero 
where GuiaId=@GuiaId  
select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarInventario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarInventario]
@ListaOrden varchar(Max)
as
begin
Declare @detalle varchar(max)
Set @detalle =@ListaOrden
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @IdProducto numeric(20),
		@Cantidad decimal(18,2),
	    @Costo decimal(18,4),
	    @Usuario varchar(80),
	    @StockInicial decimal(18,2)
		declare @p1 int,@p2 int,
		@p3 int,@p4 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @p1 = CharIndex('|',@Columna,0)
	    Set @p2 = CharIndex('|',@Columna,@p1+1)
	    Set @p3 = CharIndex('|',@Columna,@p2+1)
		Set @p4 =Len(@Columna)+1
        Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))
		Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
		Set @Costo=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
		Set @Usuario=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
		set @StockInicial=(select top 1 p.ProductoCantidad 
		from Producto p
		where IdProducto=@IdProducto)
		insert into Kardex values(@IdProducto,GETDATE(),'EDITA INVENTARIO','EDITA INVENTARIO',
		@StockInicial,0,0,@Costo,@Cantidad,'INGRESO',@Usuario)		
		update Producto
		set ProductoCantidad=@Cantidad
		where IdProducto=@IdProducto		
Fetch Next From Tabla INTO @Columna
END
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarInventarioA]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarInventarioA]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @detalle varchar(max)  
Set @detalle =@ListaOrden  
Begin Transaction  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
        Declare @Columna varchar(max)  
  declare @IdStock numeric(20),  
  @Cantidad decimal(18,2),  
     @Costo decimal(18,4),  
     @Usuario varchar(80),  
     @StockInicial decimal(18,2)  
  declare @p1 int,@p2 int,  
  @p3 int,@p4 int  
Fetch Next From Tabla INTO @Columna  
While @@FETCH_STATUS = 0  
Begin  
     Set @p1 = CharIndex('|',@Columna,0)  
     Set @p2 = CharIndex('|',@Columna,@p1+1)  
     Set @p3 = CharIndex('|',@Columna,@p2+1)  
  Set @p4 =Len(@Columna)+1  
  Set @IdStock=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))  
  Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))  
  Set @Costo=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))  
  Set @Usuario=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))  
  
  set @StockInicial=(select top 1 s.Cantidad   
  from Stock s  
  where s.IdStock=@IdStock)
    
  insert into KardexAlmacen values(@IdStock,GETDATE(),'EDITA INVENTARIO','EDITA INVENTARIO',  
  @StockInicial,0,0,@Cantidad,'INGRESO',@Usuario)    
  
  update Stock  
  set Cantidad=@Cantidad  
  where IdStock=@IdStock    

Fetch Next From Tabla INTO @Columna  
END  
 Close Tabla;  
 Deallocate Tabla;  
 Commit Transaction;  
 Select 'true';  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarNotaPedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarNotaPedido]    
@ListaOrden varchar(Max)    
as    
begin    
Declare @pos1 int,@pos2 int    
Declare @orden varchar(max),    
        @detalle varchar(max)    
Set @pos1 = CharIndex('[',@ListaOrden,0)    
Set @pos2=Len(@ListaOrden)+1    
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)    
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)    
Declare @c1 int,@c2 int,@c3 int,@c4 int,    
        @c5 int,@c6 int,@c7 int,@c8 int,    
        @c9 int,@c10 int,@c11 int,@c12 int,    
        @c13 int,@c14 int,@c15 int,@c16 int,    
        @c17 int,@c18 int,@c19 int,@c20 int,    
        @c21 int,@c22 int,@c23 int,@c24 int,    
        @c25 int,@c26 int,@c27 int,@c28 int    
Declare @NotaId numeric(38),@NotaDocu varchar(60),    
  @ClienteId numeric(20),@NotaUsuario varchar(60),    
  @NotaFormaPago varchar(60),@NotaCondicion varchar(60),    
  @NotaDireccion varchar(max),@NotaTelefono varchar(60),    
  @NotaSubtotal decimal (18,2),@NotaMovilidad decimal(18,2),    
  @NotaDescuento decimal (18, 2),@NotaTotal decimal (18,2),    
  @NotaAdicional decimal(18,2),@NotaTarjeta decimal(18,2),    
  @NotaPagar decimal(18,2),@CompaniaId int,    
  @NotaEntrega varchar(40),@ModificadoPor varchar(60),    
  @NotaSerie varchar(60),@NotaNumero varchar(60),    
  @NotaGanancia decimal(18,2),@Aviso varchar(60),    
  @Letra varchar(max),@DocuAdicional decimal(18,2),    
  @NotaConcepto varchar(80),@ICBPER decimal(18,2),    
  @DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)    
Set @c1 = CharIndex('|',@orden,0)    
Set @c2 = CharIndex('|',@orden,@c1+1)    
Set @c3 = CharIndex('|',@orden,@c2+1)    
Set @c4 = CharIndex('|',@orden,@c3+1)    
Set @c5 = CharIndex('|',@orden,@c4+1)    
Set @c6= CharIndex('|',@orden,@c5+1)    
Set @c7 = CharIndex('|',@orden,@c6+1)    
Set @c8 = CharIndex('|',@orden,@c7+1)    
Set @c9 = CharIndex('|',@orden,@c8+1)    
Set @c10= CharIndex('|',@orden,@c9+1)    
Set @c11= CharIndex('|',@orden,@c10+1)    
Set @c12= CharIndex('|',@orden,@c11+1)    
Set @c13= CharIndex('|',@orden,@c12+1)    
Set @c14= CharIndex('|',@orden,@c13+1)    
Set @c15= CharIndex('|',@orden,@c14+1)    
Set @c16= CharIndex('|',@orden,@c15+1)    
Set @c17= CharIndex('|',@orden,@c16+1)    
Set @c18 = CharIndex('|',@orden,@c17+1)    
Set @c19 = CharIndex('|',@orden,@c18+1)    
Set @c20= CharIndex('|',@orden,@c19+1)    
Set @c21= CharIndex('|',@orden,@c20+1)    
Set @c22= CharIndex('|',@orden,@c21+1)    
Set @c23= CharIndex('|',@orden,@c22+1)    
Set @c24= CharIndex('|',@orden,@c23+1)    
Set @c25= CharIndex('|',@orden,@c24+1)    
Set @c26= CharIndex('|',@orden,@c25+1)    
Set @c27= CharIndex('|',@orden,@c26+1)    
Set @c28= Len(@orden)+1    
set @NotaId=Convert(numeric(38),SUBSTRING(@orden,1,@c1-1))    
set @NotaDocu=SUBSTRING(@orden,@c1+1,@c2-@c1-1)    
set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@c2+1,@c3-@c2-1))    
set @NotaUsuario=SUBSTRING(@orden,@c3+1,@c4-@c3-1)    
set @NotaFormaPago=SUBSTRING(@orden,@c4+1,@c5-@c4-1)    
set @NotaCondicion=SUBSTRING(@orden,@c5+1,@c6-@c5-1)    
set @NotaDireccion=SUBSTRING(@orden,@c6+1,@c7-@c6-1)    
set @NotaTelefono=SUBSTRING(@orden,@c7+1,@c8-@c7-1)    
set @NotaSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c8+1,@c9-@c8-1))    
set @NotaMovilidad=convert(decimal(18,2),SUBSTRING(@orden,@c9+1,@c10-@c9-1))    
set @NotaDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c10+1,@c11-@c10-1))    
set @NotaTotal=convert(decimal(18,2),SUBSTRING(@orden,@c11+1,@c12-@c11-1))    
set @NotaAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c12+1,@c13-@c12-1))    
set @NotaTarjeta=convert(decimal(18,2),SUBSTRING(@orden,@c13+1,@c14-@c13-1))    
set @NotaPagar=convert(decimal(18,2),SUBSTRING(@orden,@c14+1,@c15-@c14-1))    
set @CompaniaId=convert(int,SUBSTRING(@orden,@c15+1,@c16-@c15-1))    
set @NotaEntrega=SUBSTRING(@orden,@c16+1,@c17-@c16-1)    
set @ModificadoPor=SUBSTRING(@orden,@c17+1,@c18-@c17-1)    
set @NotaSerie=SUBSTRING(@orden,@c18+1,@c19-@c18-1)    
set @NotaNumero=SUBSTRING(@orden,@c19+1,@c20-@c19-1)    
set @Aviso=SUBSTRING(@orden,@c20+1,@c21-@c20-1)    
set @NotaGanancia=convert(decimal(18,2),SUBSTRING(@orden,@c21+1,@c22-@c21-1))    
set @Letra=SUBSTRING(@orden,@c22+1,@c23-@c22-1)    
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c23+1,@c24-@c23-1))    
set @NotaConcepto=SUBSTRING(@orden,@c24+1,@c25-@c24-1)    
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@c25+1,@c26-@c25-1))    
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@c26+1,@c27-@c26-1))    
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c27+1,@c28-@c27-1))  
   
declare @Acuenta decimal(18,2),@Saldo decimal(18,2),@EstadoNota varchar(40)    
set @Acuenta=(select top 1 NotaAcuenta from NotaPedido where NotaId=@NotaId)    
set @Saldo=@NotaPagar-@Acuenta    
  
if @Saldo=0 set @EstadoNota='CANCELADO'    
else    
begin    
 if (@Saldo>0 and @Acuenta>0)set @EstadoNota='ACUENTA'    
 else if(@NotaDocu='BOLETA')set @EstadoNota='EMITIDO'    
 else set @EstadoNota='PENDIENTE'    
end    
declare @DocuId numeric(38),    
  @Subtotal decimal(18,2),@IGV decimal(18,2)    
begin  
    
update Cliente    
set ClienteDespacho=@NotaDireccion,    
ClienteTelefono=@NotaTelefono    
where ClienteId=@ClienteId    
  
declare @cod varchar(13)    
SET @cod=(select TOP 1 dbo.genenerarNroFactura(@NotaSerie,@CompaniaId,@NotaDocu) AS ID FROM DocumentoVenta)    
  
Begin Transaction    
  
update NotaPedido    
set NotaDocu=@NotaDocu,    
ClienteId=@ClienteId,    
FechaEdita=(IsNull(convert(varchar,GETDATE(),103),'')+' '+ IsNull(SUBSTRING(convert(varchar,GETDATE(),114),1,8),'')),    
NotaUsuario=@NotaUsuario,    
NotaFormaPago=@NotaFormaPago,    
NotaCondicion=@NotaCondicion,    
NotaDireccion=@NotaDireccion,    
NotaTelefono=@NotaTelefono,    
NotaSubtotal=@NotaSubtotal,    
NotaMovilidad=@NotaMovilidad,    
NotaDescuento=@NotaDescuento,    
NotaTotal=@NotaTotal,    
NotaSaldo=@Saldo,    
NotaAdicional=@NotaAdicional,    
NotaTarjeta=@NotaTarjeta,    
NotaPagar=@NotaPagar,    
CompaniaId=@CompaniaId,    
NotaEntrega=@NotaEntrega,    
ModificadoPor=@ModificadoPor,    
NotaSerie=@NotaSerie,    
NotaNumero=@cod,    
NotaGanancia=@NotaGanancia,    
NotaEstado=@EstadoNota,    
NotaConcepto=@NotaConcepto,    
ICBPER=@ICBPER    
where NotaId=@NotaId    
end    
if @NotaDocu='BOLETA'    
begin    
    set @Subtotal=@NotaTotal/1.18    
 set @IGV=@NotaTotal-@Subtotal    
 insert into DocumentoVenta values    
 (@CompaniaId,@NotaId,@NotaDocu,@cod,@ClienteId,GETDATE(),    
 GETDATE(),@NotaCondicion,1,GETDATE(),    
 GETDATE(),@Letra,@Subtotal,@IGV,@NotaPagar,    
 0,@NotaUsuario,'EMITIDO',@NotaSerie,'03',@DocuAdicional,'',    
 'VENTA','','','PENDIENTE',@ICBPER,'','',@DocuGravada,@DocuDescuento,'')    
 set @DocuId=(select @@IDENTITY)    
end    
else    
begin    
 set @DocuId='0'    
end    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
Declare @Columna varchar(max),    
        @DetalleId numeric(38),    
  @IdProducto numeric(20),    
  @DetalleCantidad decimal(18,2),    
  @DetalleUM varchar(80),    
  @DetalleCosto decimal(18,2),     
  @DetallePrecio decimal(18,2),    
  @DetalleImporte decimal(18,2),    
  @CantidadSaldo decimal(18,2),    
  @DetalleEstado varchar(60),    
  @ValorUM decimal(18,4),
  @Estado nvarchar(1)   
Declare @guias int    
Declare @p1 int,@p2 int,@p3 int,@p4 int,    
        @p5 int,@p6 int,@p7 int,@p8 int,    
        @p9 int,@p10 int   
Fetch Next From Tabla INTO @Columna    
 While @@FETCH_STATUS = 0    
 Begin    
Set @p1 = CharIndex('|',@Columna,0)    
Set @p2 = CharIndex('|',@Columna,@p1+1)    
Set @p3 = CharIndex('|',@Columna,@p2+1)    
Set @p4 = CharIndex('|',@Columna,@p3+1)    
Set @p5 = CharIndex('|',@Columna,@p4+1)    
Set @p6= CharIndex('|',@Columna,@p5+1)    
Set @p7= CharIndex('|',@Columna,@p6+1)    
Set @p8 = CharIndex('|',@Columna,@p7+1)
Set @p9= CharIndex('|',@Columna,@p8+1)      
Set @p10=Len(@Columna)+1    
set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))    
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))    
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))    
Set @DetalleUm=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))    
Set @DetalleCosto=convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))    
Set @DetallePrecio=convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))    
Set @DetalleImporte=convert(decimal(18,2),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))    
Set @DetalleEstado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))    
set @ValorUM=convert(decimal(18,4),SUBSTRING(@Columna,@p8+1,@p9-(@p8+1)))
set @Estado=SUBSTRING(@Columna,@p9+1,@p10-(@p9+1))       
set @guias=(select COUNT(d.IdDetalle)from DetalleGuia d where d.IdDetalle=@DetalleId)    
begin    
	update DetallePedido    
	set DetalleCantidad=@DetalleCantidad,DetalleCosto=@DetalleCosto,    
	DetallePrecio=@DetallePrecio,DetalleImporte=@DetalleImporte,DetalleEstado=@DetalleEstado,Estado=@Estado    
	where DetalleId=@DetalleId    
if(@guias<=0)    
begin    
if(@NotaEntrega='INMEDIATA')set @CantidadSaldo=0    
else set @CantidadSaldo=@DetalleCantidad 
   
update DetallePedido    
set CantidadSaldo=@CantidadSaldo    
where DetalleId=@DetalleId    

end    
end    
if(@DocuId<>'0')    
begin    
	insert into DetalleDocumento values    
	(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,    
	@DetalleImporte,@DetalleId,@DetalleUM,@ValorUM)    
end    
Fetch Next From Tabla INTO @Columna    
end    
 Close Tabla;    
 Deallocate Tabla; 
 Commit Transaction;    
 select @cod    
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarRB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarRB]
@Data varchar(max)
as
begin
Declare  @p1 int,@p2 int,
         @p3 int,@p4 int
Declare  @ResumenId numeric(38),@CodigoSunat varchar(80),
         @MensajeSunat varchar(max),@HASHCDR varchar(max)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4= Len(@Data)+1
Set @ResumenId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CodigoSunat=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Set @MensajeSunat=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
Set @HASHCDR=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
update ResumenBoletas
set CodigoSunat=@CodigoSunat,MensajeSunat=@MensajeSunat,HASHCDR=@HASHCDR
where ResumenId=@ResumenId
SELECT
isnull((select STUFF ((select '¬'+convert(varchar,r.ResumenId)+'|'+convert(varchar,r.CompaniaId)+'|'+
(IsNull(convert(varchar,r.FechaReferencia,103),''))+'|'+
(IsNull(convert(varchar,r.FechaEnvio,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,r.FechaEnvio,114),1,8),''))+'|'+
r.ResumenSerie+'-'+convert(varchar,r.Secuencia)+'|'+r.RangoNumero+'|'+
CONVERT(VarChar(50),cast(r.SubTotal as money ), 1)+'|'+
CONVERT(VarChar(50),cast( r.IGV as money ), 1)+'|'+
CONVERT(VarChar(50),cast( r.ICBPER as money ), 1)+'|'+
CONVERT(VarChar(50),cast(r.Total as money ), 1)+'|'+
r.ResumenTiket+'|'+r.CodigoSunat+'|'+r.HASHCDR+'|'+r.MensajeSunat+'|'+
r.Usuario+'|'+c.CompaniaRUC+'|'+
c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+r.Estado
FROM ResumenBoletas r
inner join Compania c
on c.CompaniaId=r.CompaniaId
where Month(r.FechaReferencia)=MONTH(Getdate()) and YEAR(r.FechaReferencia)=year(Getdate())
order by r.CompaniaId,r.FechaEnvio asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarStockCsv]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarStockCsv]    
@Columna varchar(max)    
as    
begin    
   
Declare @p1 int,@p2 int,    
        @p3 int,@p4 int  
Declare @IdStock numeric(38),@Cantidad  decimal(18,2),  
        @ValorUM  decimal(18,4),@Usuario varchar(80)  
Set @Columna= LTRIM(RTrim(@Columna))    
Set @p1 = CharIndex('|',@Columna,0)    
Set @p2=CharIndex('|',@Columna,@p1+1)    
Set @p3=CharIndex('|',@Columna,@p2+1)       
Set @p4 = Len(@Columna)+1    
  
Set @IdStock=convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))    
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-@p1-1))    
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-@p2-1))    
Set @Usuario=SUBSTRING(@Columna,@p3+1,@p4-@p3-1)  
  
Begin Transaction

set @Cantidad=@Cantidad*@ValorUM 
  
update Stock  
set Cantidad=@Cantidad,Usuario=@Usuario  
where IdStock=@IdStock  
  
insert into KardexAlmacen values(@IdStock,GETDATE(),'Edita Cantidad','Edita Cantidad',    
0,@Cantidad,0,@Cantidad,'INGRESO',@Usuario)  
  
commit transaction  
  
select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarTemporal]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarTemporal]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
declare @Id numeric(38),
@cantidad decimal(18,2),
@precioCosto decimal(18,4),
@Descuento decimal(18,4),
@importe decimal(18,2),
@UsuarioID int
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @pos5= CharIndex('|',@Data,@pos4+1)
Set @pos6 =Len(@Data)+1
Set @Id =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @precioCosto=convert(decimal(18,4),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @Descuento=convert(decimal(18,4),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @importe=convert(decimal(18,4),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @UsuarioID=convert(int,SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
update TemporalCompra
set DetalleCantidad=@cantidad,PrecioCosto=@precioCosto,
DetalleDescuento=@Descuento,DetalleImporte=@importe
where TemporalId=@Id
select isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'true')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaStockNube]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaStockNube]    
@ListaOrden varchar(Max)    
as    
begin    
Declare @detalle varchar(max)    
Set @detalle =@ListaOrden    
Begin Transaction    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
  Declare @Columna varchar(max)    
  declare @IdProdcuto numeric(38)    
  declare @CantidadNB decimal(18,2)   
  Declare @p1 int    
  declare @p2 int    
Fetch Next From Tabla INTO @Columna    
While @@FETCH_STATUS = 0    
Begin    
  Set @p1 = CharIndex('|',@Columna,0)    
  Set @p2 =Len(@Columna)+1    
  Set @IdProdcuto=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))    
  Set @CantidadNB=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))    
    
  Update Producto  
  set CantidadNB=@CantidadNB 
  where IdProducto=@IdProdcuto  
    
Fetch Next From Tabla INTO @Columna    
End    
 Close Tabla;    
 Deallocate Tabla;    
 Commit Transaction;    
 Select 'true';    
End
GO
/****** Object:  StoredProcedure [dbo].[uspEditaStockNubeDes]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaStockNubeDes]      
@ListaOrden varchar(Max)      
as      
begin      
Declare @detalle varchar(max)      
Set @detalle =@ListaOrden      
Begin Transaction      
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')       
Open Tabla      
  Declare @Columna varchar(max)      
  declare @IdProdcuto numeric(38)      
  declare @CantidadNB decimal(18,2)     
  Declare @p1 int      
  declare @p2 int      
Fetch Next From Tabla INTO @Columna      
While @@FETCH_STATUS = 0      
Begin      
  Set @p1 = CharIndex('|',@Columna,0)      
  Set @p2 =Len(@Columna)+1      
  Set @IdProdcuto=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))      
  Set @CantidadNB=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))      
      
  Update Producto    
  set CantidadNB=@CantidadNB   
  where IdProducto=@IdProdcuto    
      
Fetch Next From Tabla INTO @Columna      
End      
 Close Tabla;      
 Deallocate Tabla;      
 Commit Transaction;      
 Select 'true';      
End
GO
/****** Object:  StoredProcedure [dbo].[uspEditaTemporalVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaTemporalVenta]  
@Data varchar(max)  
as  
begin  
Declare @p1 int,@p2 int,  
        @p3 int,@p4 int,  
        @p5 int,@p6 int,@p7 int  
Declare @Id numeric(38),  
        @IdProducto numeric(20),  
        @Cantidad decimal(18,2),  
        @Unidad varchar(40),  
        @PrecioVenta decimal(18,2),  
        @Importe decimal(18,2),  
        @Aviso varchar(max),  
        @Stock decimal(18,2),  
        @Existe int,  
        @Condicion varchar(1)  
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = CharIndex('|',@Data,@p3+1)  
Set @p5 = CharIndex('|',@Data,@p4+1)  
Set @p6 = CharIndex('|',@Data,@p5+1)  
Set @p7= Len(@Data)+1  
Set @Id=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))  
Set @Unidad=SUBSTRING(@Data,@p3+1,@p4-@p3-1)  
Set @PrecioVenta=convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))  
Set @Importe=convert(decimal(18,2),SUBSTRING(@Data,@p5+1,@p6-@p5-1))  
Set @Condicion=SUBSTRING(@Data,@p6+1,@p7-@p6-1)  
if(@Condicion='B')  
begin  
  
update TemporalVenta   
set cantidad=@Cantidad,precioventa=@PrecioVenta,importe=@Importe  
where temporalId=@Id  
select 'true'  
  
end  
else  
begin  
set @Aviso=isnull((select top 1 convert(varchar,p.ProductoCantidad)   
from Producto p   
where p.IdProducto=@IdProducto and p.ProductoUM=@Unidad),'false')  
if(@Aviso='false')  
begin  
set @Stock=isnull((select top 1 cast((p.ProductoCantidad/u.ValorUM) as decimal(18,2))   
from Producto p  
inner join UnidadMedida u  
on p.IdProducto=u.IdProducto  
where p.IdProducto=@IdProducto and u.UMDescripcion=@Unidad),0)  
end  
else  
begin  
set @Stock=@Aviso  
END  
if(@Cantidad>@Stock)  
begin  
select CONVERT(varchar,@Stock)  
END  
else  
begin  
update TemporalVenta   
set cantidad=@Cantidad,precioventa=@PrecioVenta,importe=@Importe  
where temporalId=@Id  
select 'true'  
end  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaDetaCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminaDetaCompra]  
@Columna varchar(max)  
as   
begin  
Declare @DetalleId numeric(38),      
        @IdProducto numeric(20),      
        @Documento varchar(255),          
        @Cantidad decimal(18,2),      
        @Costo  decimal(18,4),   
        @Estado varchar(60),  
        @Motivo varchar(80),  
        @Usuario varchar(80),  
        @Concepto varchar(80)    
        Declare @p1 int,@p2 int,@p3 int,@p4 int,      
        @p5 int,@p6 int,@p7 int,@p8 int,@p9 int  
          
Set @p1 = CharIndex('|',@Columna,0)        
Set @p2 = CharIndex('|',@Columna,@p1+1)        
Set @p3 = CharIndex('|',@Columna,@p2+1)        
Set @p4 = CharIndex('|',@Columna,@p3+1)        
Set @p5 = CharIndex('|',@Columna,@p4+1)  
Set @p6 = CharIndex('|',@Columna,@p5+1)  
Set @p7 = CharIndex('|',@Columna,@p6+1)  
Set @p8 = CharIndex('|',@Columna,@p7+1)                  
Set @p9=Len(@Columna)+1      
      
set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))          
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))             
Set @Documento=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))            
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))        
Set @Costo=convert(decimal(18,4),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))             
Set @Estado=SUBSTRING(@Columna,@p5+1,@p6-(@p5+1))  
Set @Motivo=SUBSTRING(@Columna,@p6+1,@p7-(@p6+1))  
Set @Usuario=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))  
Set @Concepto=SUBSTRING(@Columna,@p8+1,@p9-(@p8+1))          
          
Begin Transaction  
  
delete from DetalleCompra   
where DetalleId=@DetalleId  

Declare @AplicaINV nvarchar(1) 

set @AplicaINV=(select top 1 p.AplicaINV
from Producto p (nolock) 
where p.IdProducto=@IdProducto)

if(@AplicaINV='S')
begin  
if(@Concepto='MERCADERIA')  
begin  
declare @IniciaStock decimal(18,2),@stockFinal decimal(18,2)      
set @IniciaStock=(select top 1 p.ProductoCantidad   
from Producto p (nolock)
where p.IdProducto=@IdProducto)      
  
set @stockFinal=@IniciaStock-@Cantidad   
  
if(@Estado<>'PENDIENTE')  
begin  
  
update Producto       
set ProductoCantidad=ProductoCantidad-@Cantidad      
where IdProducto=@IdProducto   
  
insert into Kardex values(@IdProducto,GETDATE(),@Motivo,@Documento,@IniciaStock,        
0,@Cantidad,@Costo,@StockFinal,'INGRESO',@Usuario)     
  
END  
END  
end  
Commit Transaction;       
select 'true'     
             
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaDetaGuiaS]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminaDetaGuiaS]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @posA1 int,@posA2 int    
            
Declare @Data varchar(max),            
        @Guia varchar(max)                         
Set @posA1 = CharIndex('[',@ListaOrden,0)            
Set @posA2 =Len(@ListaOrden)+1      
            
Set @Data = SUBSTRING(@ListaOrden,1,@posA1-1)            
Set @Guia=SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)  
  
Declare @p1 int,@p2 int,        
        @p3 int,@p4 int,        
        @p5 int,@p6 int,        
        @p7 int,@p8 int,  
        @p9 int,@p10 int  
  
Declare @DetalleId numeric(38),  
        @IdProducto numeric(20),    
        @KardexMotivo varchar(60),    
        @KardexDocumento varchar(60),    
        @CantidadIngreso decimal(18, 2),    
        @PrecioCosto decimal(18,4),    
        @Usuario varchar(60),  
        @IdDetalle numeric(38),    
        @Aviso int,@ValorUM decimal(18,4)  
Set @Data = LTRIM(RTrim(@Data))        
Set @p1=CharIndex('|',@Data,0)        
Set @p2=CharIndex('|',@Data,@p1+1)       
set @p3=CharIndex('|',@Data,@p2+1)        
Set @p4=CharIndex('|',@Data,@p3+1)        
set @p5=CharIndex('|',@Data,@p4+1)        
set @p6=CharIndex('|',@Data,@p5+1)  
set @p7=CharIndex('|',@Data,@p6+1)        
set @p8=CharIndex('|',@Data,@p7+1)  
set @p9=CharIndex('|',@Data,@p8+1)        
Set @p10=Len(@Data)+1   
  
Set @DetalleId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @IdProducto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)         
Set @KardexMotivo=SUBSTRING(@Data,@p2+1,@p3-@p2-1)        
Set @KardexDocumento=SUBSTRING(@Data,@p3+1,@p4-@p3-1)        
Set @CantidadIngreso=Convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))            
Set @PrecioCosto=Convert(decimal(18,4),SUBSTRING(@Data,@p5+1,@p6-(@p5+1)))        
Set @Usuario=SUBSTRING(@Data,@p6+1,@p7-@p6-1)  
Set @IdDetalle=Convert(numeric(38),SUBSTRING(@Data,@p7+1,@p8-@p7-1))  
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Data,@p8+1,@p9-@p8-1))  
Set @Aviso=Convert(int,SUBSTRING(@Data,@p9+1,@p10-@p9-1))   
  
Declare @IniciaStock decimal(18,2),        
        @StockFinal decimal(18,4),@CantValor  decimal(18,4)  
set @IniciaStock=(select top 1 ProductoCantidad from        
producto p (nolock)       
where p.IdProducto=@IdProducto)        
set @CantValor=(@CantidadIngreso*@ValorUM)   
  
Begin Transaction   
if(@Aviso=1)  
begin  
update DetallePedido    
set CantidadSaldo=CantidadSaldo+@CantValor    
where DetalleId=@IdDetalle    
end  
  
delete from DetalleGuia   
where DetalleId=@DetalleId  
   
set @StockFinal=@IniciaStock+@CantValor        
      
insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,        
@CantValor,0,@PrecioCosto,@StockFinal,'INGRESO',@Usuario)        
          
update Producto        
set ProductoCantidad=@StockFinal        
where IdProducto=@IdProducto  
  
--Commit Transaction;              
 --select 'true'      
 if(len(@Guia)>0)              
begin              
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')               
Open TablaB              
Declare @ColumnaB varchar(max)            
Declare @g1 int,@g2 int,            
        @g3 int,@g4 int,@g5 int            
            
Declare @CantidadA decimal(18,2),             
        @IdProductoU numeric(20),                             
        @CantidadU decimal(18,2),                                
        @UmU varchar(40),                                                               
        @ValorUMU decimal(18,4)            
            
Declare @IniciaStockB decimal(18,2),            
        @StockFinalB decimal(18,2)            
                      
Fetch Next From TablaB INTO @ColumnaB              
 While @@FETCH_STATUS = 0              
 Begin              
Set @g1 = CharIndex('|',@ColumnaB,0)                               
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                                
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                                
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                                
Set @g5=Len(@ColumnaB)+1               
             
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))            
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))            
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))              
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))              
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))                  
            
 Declare @CantidadSalB decimal(18,2)             
            
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                        
                            
 set @IniciaStockB=(select top 1 p.ProductoCantidad             
 from Producto p where p.IdProducto=@IdProductoU)          
               
 set @StockFinalB=@IniciaStockB + @CantidadSalB                                              
           
 insert into Kardex values(@IdProductoU,getdate(),@KardexMotivo,@KardexDocumento,@IniciaStockB,
 @CantidadSalB,0,0,@StockFinalB,'INGRESO',@Usuario)           
                                                 
 update producto                                 
 set  ProductoCantidad =ProductoCantidad + @CantidadSalB                               
 where IDProducto=@IdProductoU            
               
Fetch Next From TablaB INTO @ColumnaB              
end              
    Close TablaB;              
    Deallocate TablaB;              
    Commit Transaction;              
    select 'true'          
end              
else              
begin              
    Commit Transaction;              
    select 'true'          
end              
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaFacturaNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminaFacturaNC]
@ListaOrden varchar(Max)
as
begin
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Declare @Productos varchar(max)
Declare @DetalleCompra varchar(max)
Set @pos1 = CharIndex('[',@ListaOrden,0)
Set @pos2 = CharIndex('[',@ListaOrden,@pos1+1)
Set @pos3 = CharIndex('[',@ListaOrden,@pos2+1)
Set @pos4 =Len(@ListaOrden)+1
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)
Set @Productos=SUBSTRING(@ListaOrden,@pos2+1,@pos3-@pos2-1)
Set @DetalleCompra=SUBSTRING(@ListaOrden,@pos3+1,@pos4-@pos3-1)
Declare @c1 int,@c2 int,@c3 int,@c4 int,@c5 int,@c6 int
declare @CompraId numeric(38),
        @Estado varchar(40),
        @TipoCodigo char(20),
        @TipoCambio decimal(18,3),
        @Documento varchar(80),
        @CompraUsuario varchar(80)
Set @c1 = CharIndex('|',@orden,0)
Set @c2 = CharIndex('|',@orden,@c1+1)
Set @c3 = CharIndex('|',@orden,@c2+1)
Set @c4= CharIndex('|',@orden,@c3+1)
Set @c5 = CharIndex('|',@orden,@c4+1)
Set @c6= Len(@orden)+1 
Set @CompraId=convert(numeric(38),SUBSTRING(@orden,1,@c1-1))
Set @Estado=SUBSTRING(@orden,@c1+1,@c2-@c1-1)
Set @TipoCodigo=SUBSTRING(@orden,@c2+1,@c3-@c2-1)
Set @TipoCambio=convert(decimal(18,3),SUBSTRING(@orden,@c3+1,@c4-@c3-1))
Set @Documento=SUBSTRING(@orden,@c4+1,@c5-@c4-1)
Set @CompraUsuario=SUBSTRING(@orden,@c5+1,@c6-@c5-1)
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @ID numeric(38),
        @Acuenta decimal(18,2)
Declare @d1 int,@d2 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @d1 = CharIndex('|',@Columna,0)
Set @d2 = Len(@Columna)+1
Set @ID=Convert(numeric(38),SUBSTRING(@Columna,1,@d1-1))
Set @Acuenta=convert(decimal(18,2),SUBSTRING(@Columna,@d1+1,@d2-@d1-1))
if(@Estado<>'DESCUENTO INTERNO')
begin
update Compras 
set CompraSaldo=CompraSaldo + @Acuenta,CompraEstado='PENDIENTE DE PAGO' 
where CompraId=@ID
end
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
if(@Estado='DESCUENTO INTERNO' or @Estado='DESCUENTO')
BEGIN
Declare TablaC Cursor For Select * From fnSplitString(@Productos,';')	
Open TablaC
Declare @ColumnaC varchar(max),
		@DetalleIdP numeric(38),
		@IdProductoP numeric(20),
		@CostoP decimal(18,4),
		@costoDolarP decimal(18,4)
Declare @p1 int,@p2 int,@p3 int,
        @p4 int
Fetch Next From TablaC INTO @ColumnaC
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@ColumnaC,0)
Set @p2 = CharIndex('|',@ColumnaC,@p1+1)
Set @p3 = CharIndex('|',@ColumnaC,@p2+1)
Set @p4 = Len(@ColumnaC)+1
set @DetalleIdP=Convert(numeric(38),SUBSTRING(@ColumnaC,1,@p1-1))
Set @IdProductoP=Convert(numeric(20),SUBSTRING(@ColumnaC,@p1+1,@p2-(@p1+1)))
Set @CostoP=convert(decimal(18,4),SUBSTRING(@ColumnaC,@p2+1,@p3-(@p2+1)))
Set @costoDolarP=convert(decimal(18,4),SUBSTRING(@ColumnaC,@p3+1,@p4-(@p3+1)))
update Producto 
set ProductoCosto=@CostoP,ProductoCostoDolar=@costoDolarP,ProductoTipoCambio=@TipoCambio
where IdProducto=@IdProductoP 
if(@TipoCodigo='07'or @TipoCodigo='101')
begin
update DetalleCompra
set DescuentoB=0
where DetalleId=@DetalleIdP
end
Fetch Next From TablaC INTO @ColumnaC
end
	Close TablaC;
	Deallocate TablaC;
end
else if(@Estado='DEVOLUCION')
begin
Declare TablaD Cursor For Select * From fnSplitString(@DetalleCompra,';')	
Open TablaD
Declare @ColumnaD varchar(max),
		@IdProductoD numeric(20),
		@DetalleCantidad decimal(18,2),
		@CostoD decimal(18,4)
Declare @z1 int,@z2 int,@Z3 int
Declare @StockInicial decimal(18,2),@StockFinal decimal(18,2)
Fetch Next From TablaD INTO @ColumnaD
While @@FETCH_STATUS = 0
Begin
Set @z1 = CharIndex('|',@ColumnaD,0)
Set @z2= CharIndex('|',@ColumnaD,@z1+1)
Set @Z3 = Len(@ColumnaD)+1
set @IdProductoD=Convert(numeric(20),SUBSTRING(@ColumnaD,1,@z1-1))
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@ColumnaD,@z1+1,@z2-(@z1+1)))
Set @CostoD=convert(decimal(18,4),SUBSTRING(@ColumnaD,@z2+1,@Z3-(@z2+1)))
set @StockInicial=(select ProductoCantidad from Producto where IdProducto=@IdProductoD)
set @StockFinal=@StockInicial+@DetalleCantidad
insert into Kardex values(@IdProductoD,GETDATE(),'Ingreso Por Nota Cre.','NC '+@Documento,
@StockInicial,@DetalleCantidad,0,@CostoD,@StockFinal,'INGRESO',@CompraUsuario)
update Producto
set ProductoCantidad=@StockFinal
where IdProducto=@IdProductoD
Fetch Next From TablaD INTO @ColumnaD
end
	Close TablaD;
	Deallocate TablaD;
end
    delete from FacturasNC
	where CompraId=@CompraId
	delete from DetalleCompra
	where CompraId=@CompraId
	delete from Compras
	where CompraId=@CompraId
	Commit Transaction;
	select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaGasto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminaGasto]
@Data varchar(max)
as
begin
declare @GastoId int
Set @GastoId=convert(int,@Data)
begin
	delete from GastosFijos 
	where GastoId=@GastoId
	select isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
	g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
	(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
	g.GastoUsuario
	from GastosFijos g 
	where month(g.GastoFecha)=month(GETDATE())and year(g.GastoFecha)=year(GETDATE())
	order by g.GastoFecha asc,g.GastoId asc
	FOR XML PATH('')), 1, 1, '')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaItemGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminaItemGuia]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
        @p3 int,@p4 int,
        @p5 int,@p6 int,
        @p7 int
Declare @DetalleId numeric(38),
        @GuiaConcepto varchar(40),
        @GuiaUsuario varchar(80),
        @IdStock numeric(38),
		@Cantidad decimal(18,2),
		@ValorUM decimal(18,4),
		@IniciaStock decimal(18,2),
		@StockFinal decimal(18,4),
		@CantValor  decimal(18,4),
		@GuiaId numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
set @p5 = CharIndex('|',@Data,@p4+1)
set @p6 = CharIndex('|',@Data,@p5+1)
Set @p7= Len(@Data)+1
Set @DetalleId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @GuiaConcepto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Set @GuiaUsuario=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
Set @IdStock=Convert(numeric(38),SUBSTRING(@Data,@p3+1,@p4-@p3-1))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-(@p4+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Data,@p5+1,@p6-(@p5+1)))
Set @GuiaId=Convert(numeric(38),SUBSTRING(@Data,@p6+1,@p7-@p6-1))
set @IniciaStock=(select top 1 Cantidad from Stock(nolock) where IdStock=@IdStock)
set @CantValor=(@Cantidad*@ValorUM)
Begin Transaction
delete from DetalleStock
where DetalleId=@DetalleId
if(@GuiaConcepto='INGRESO')
BEGIN	
set @StockFinal=@IniciaStock-@CantValor
insert into KardexAlmacen values(@IdStock,GETDATE(),'Anulacion de la Guia Ingreso',@GuiaId,@IniciaStock,
0,@CantValor,@StockFinal,'SALIDA',@GuiaUsuario)
END
else
begin
set @StockFinal=@IniciaStock+@CantValor
insert into KardexAlmacen values(@IdStock,GETDATE(),'Anulacion de la Guia Salida',@GuiaId,@IniciaStock,
@CantValor,0,@StockFinal,'INGRESO',@GuiaUsuario)
end
update Stock
set Cantidad=@StockFinal
where IdStock=@IdStock
Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaItemGuiaING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminaItemGuiaING]      
@ListaOrden varchar(Max)  
as      
begin  
  
Declare @posA1 int,@posA2 int  
          
Declare @Data varchar(max),          
        @Guia varchar(max)                       
Set @posA1 = CharIndex('[',@ListaOrden,0)          
Set @posA2 =Len(@ListaOrden)+1    
          
Set @Data = SUBSTRING(@ListaOrden,1,@posA1-1)          
Set @Guia=SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)    
      
Declare @p1 int,@p2 int,      
        @p3 int,@p4 int,      
        @p5 int,@p6 int,      
        @p7 int  
              
Declare @DetalleId numeric(38),@GuiaConcepto varchar(40),      
        @GuiaUsuario varchar(80),@IdStock numeric(38),    
        @PrecioCosto decimal(18,4),@Cantidad decimal(18,2),      
        @ValorUM decimal(18,4),@IniciaStock decimal(18,2),      
        @StockFinal decimal(18,4),@CantValor  decimal(18,4),      
        @GuiaId numeric(38)      
  
Set @Data = LTRIM(RTrim(@Data))      
Set @p1 = CharIndex('|',@Data,0)      
Set @p2 = CharIndex('|',@Data,@p1+1)      
set @p3 = CharIndex('|',@Data,@p2+1)      
Set @p4 = CharIndex('|',@Data,@p3+1)      
set @p5 = CharIndex('|',@Data,@p4+1)      
set @p6 = CharIndex('|',@Data,@p5+1)      
Set @p7= Len(@Data)+1      
Set @DetalleId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))      
Set @GuiaConcepto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)      
Set @GuiaUsuario=SUBSTRING(@Data,@p2+1,@p3-@p2-1)      
Set @IdStock=Convert(numeric(38),SUBSTRING(@Data,@p3+1,@p4-@p3-1))      
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-(@p4+1)))      
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Data,@p5+1,@p6-(@p5+1)))      
Set @GuiaId=Convert(numeric(38),SUBSTRING(@Data,@p6+1,@p7-@p6-1))      
set @IniciaStock=(select top 1 ProductoCantidad from      
producto p (nolock)     
where p.IdProducto=@IdStock)      
set @CantValor=(@Cantidad*@ValorUM)    
    
set @PrecioCosto=(select top 1 p.ProductoCosto from producto p(nolock)      
where p.IdProducto=@IdStock)    
      
Begin Transaction    
      
delete from DetalleIngreso      
where DetalleId=@DetalleId      
    
set @StockFinal=@IniciaStock-@CantValor      
    
insert into Kardex values(@IdStock,GETDATE(),'Anulacion de la Guia Ingreso',@GuiaId,@IniciaStock,      
0,@CantValor,@PrecioCosto,@StockFinal,'SALIDA',@GuiaUsuario)      
        
update Producto      
set ProductoCantidad=@StockFinal      
where IdProducto=@IdStock      
--Commit Transaction;            
 --select 'true'    
 if(len(@Guia)>0)            
begin            
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')             
Open TablaB            
Declare @ColumnaB varchar(max)          
Declare @g1 int,@g2 int,          
        @g3 int,@g4 int,@g5 int          
          
Declare @CantidadA decimal(18,2),           
        @IdProductoU numeric(20),                           
        @CantidadU decimal(18,2),                              
        @UmU varchar(40),                                                             
        @ValorUMU decimal(18,4)          
          
Declare @IniciaStockB decimal(18,2),          
        @StockFinalB decimal(18,2)          
                    
Fetch Next From TablaB INTO @ColumnaB            
 While @@FETCH_STATUS = 0            
 Begin            
Set @g1 = CharIndex('|',@ColumnaB,0)                             
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                              
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                              
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                              
Set @g5=Len(@ColumnaB)+1             
           
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))          
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))          
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))            
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))            
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))                
          
 Declare @CantidadSalB decimal(18,2)           
          
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                      
                          
 set @IniciaStockB=(select top 1 p.ProductoCantidad           
 from Producto p where p.IdProducto=@IdProductoU)        
             
 set @StockFinalB=@IniciaStockB - @CantidadSalB                                            
         
 insert into Kardex values(@IdProductoU,getdate(),'Anulacion de la Guia Ingreso',    
 convert(varchar,@GuiaId),@IniciaStockB,0,@CantidadSalB,0,@StockFinalB,'SALIDA',@GuiaUsuario)         
                                               
 update producto                               
 set  ProductoCantidad =ProductoCantidad - @CantidadSalB                             
 where IDProducto=@IdProductoU          
             
Fetch Next From TablaB INTO @ColumnaB            
end            
    Close TablaB;            
    Deallocate TablaB;            
    Commit Transaction;            
    select 'true'        
end            
else            
begin            
    Commit Transaction;            
    select 'true'        
end            
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaItemVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminaItemVenta]
@Data varchar(max)
as
begin
Declare @TemporalId numeric(38),
        @IdProducto numeric(20),
        @UM varchar(80),
        @UsuarioId int,@Aviso int
Declare @p1 int,@p2 int,
        @p3 int,@p4 int,
        @p5 int
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4= CharIndex('|',@Data,@p3+1)
Set @p5= Len(@Data)+1
Set @TemporalId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @UM=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
Set @UsuarioId=convert(int,SUBSTRING(@Data,@p3+1,@p4-@p3-1))
Set @Aviso=convert(int,SUBSTRING(@Data,@p4+1,@p5-@p4-1))
if (@Aviso=0)
begin                     
delete from TemporalVenta 
where TemporalId=@TemporalId
delete from TemporalAlmacen
where (IdProducto=@IdProducto and UniMedida=@UM and UsuarioId=@UsuarioId) and Concepto='S'
select 'true'
end
else
begin
delete from TemporalAlmacen
where (IdProducto=@IdProducto and UniMedida=@UM and UsuarioId=@UsuarioId) and Concepto='S'
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaliquiVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminaliquiVenta]
@ListaOrden varchar(Max)
as
begin
Declare @pos1 int,@pos2 int
Declare @orden varchar(max),
        @detalle varchar(max)
Set @pos1 = CharIndex('[',@ListaOrden,0)
Set @pos2 =Len(@ListaOrden)+1
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)
Declare @LiquidacionId numeric(38)
set @LiquidacionId=@orden
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @DetalleId nvarchar(38),
        @NotaId nvarchar(38),
        @Acuenta decimal(18,2)
Declare @p1 int,@p2 int,@p3 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 =Len(@Columna)+1
set @DetalleId=SUBSTRING(@Columna,1,@p1-1)
Set @Acuenta=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @NotaId=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))
delete from CajaDetalle
where LiquidaId=@DetalleId
update NotaPedido
set NotaSaldo=NotaSaldo + @Acuenta,NotaEstado='EMITIDO'
where NotaId=@NotaId
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	delete from DetaLiquidaVenta
	where LiquidacionId=@LiquidacionId
	delete from LiquidacionVenta
	where LiquidacionId=@LiquidacionId
	Commit Transaction;
	Select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminarCaja]  
@Data varchar(max)  
as  
begin  
Declare @CajaId nvarchar(40),@CajaIdB nvarchar(40),  
  @Justificacion varchar(max),@Monto decimal(18,2),  
  @Cajero varchar(80),@Autoriza varchar(80)  
Declare @p1 int,@p2 int,@p3 int,@p4 int,  
        @p5 int,@p6 int  
Set @Data =LTRIM(RTrim(@Data))  
Set @p1 =CharIndex('|',@Data,0)  
Set @p2 =CharIndex('|',@Data,@p1+1)  
Set @p3 =CharIndex('|',@Data,@p2+1)  
Set @p4 =CharIndex('|',@Data,@p3+1)  
Set @p5 =CharIndex('|',@Data,@p4+1)  
Set @p6 =Len(@Data)+1   
Set @CajaId=convert(int,SUBSTRING(@Data,1,@p1-1))  
Set @CajaIdB=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
Set @Justificacion=SUBSTRING(@Data,@p2+1,@p3-@p2-1)  
Set @Monto=convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-@p3-1))  
Set @Cajero=SUBSTRING(@Data,@p4+1,@p5-@p4-1)  
Set @Autoriza=SUBSTRING(@Data,@p5+1,@p6-@p5-1)  
Begin Transaction  
delete from CajaDetalle where CajaId=@CajaId  
delete from CajaPincipal where CajaId=@CajaId  
delete from Monedas where CajaId=@CajaId  
delete from Caja where CajaId=@CajaId  
delete from MAYOLICA.dbo.CajaDetalle where CajaId=@CajaIdB  
delete from MAYOLICA.dbo.CajaPincipal where CajaId=@CajaIdB  
delete from MAYOLICA.dbo.Caja where CajaId=@CajaIdB  
insert into logCaja values(GETDATE(),convert(varchar,@CajaId),'ELIMINA',  
'ELIMINA CAJA PRINCIPAL',@Justificacion,@Monto,@Cajero,@Autoriza,'-')   
Commit Transaction;  
select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarCajaChica]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminarCajaChica]    
@Data varchar(max)    
as    
begin    
Declare @p1 int,@p2 int,    
  @p3 int,@p4 int,    
  @p5 int,@p6 int,    
  @p7 int,@p8 int    
Declare @DetalleId numeric(38),    
        @GastoId varchar(38),    
  @Movimiento varchar(20),    
  @Justificacion varchar(300),    
  @Monto decimal(18,2),    
  @Cajero varchar(80),    
  @Autoriza varchar(80),    
  @CajaID numeric(38)    
Set @Data =LTRIM(RTrim(@Data))    
Set @p1 =CharIndex('|',@Data,0)    
Set @p2 =CharIndex('|',@Data,@p1+1)    
Set @p3 =CharIndex('|',@Data,@p2+1)    
Set @p4 =CharIndex('|',@Data,@p3+1)    
Set @p5 =CharIndex('|',@Data,@p4+1)    
Set @p6 =CharIndex('|',@Data,@p5+1)    
Set @p7 =CharIndex('|',@Data,@p6+1)    
Set @p8 =Len(@Data)+1      
Set @DetalleId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))    
Set @GastoId=SUBSTRING(@Data,@p1+1,@p2-@p1-1)    
Set @Movimiento=SUBSTRING(@Data,@p2+1,@p3-@p2-1)    
Set @Justificacion=SUBSTRING(@Data,@p3+1,@p4-@p3-1)    
Set @Monto=convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))    
Set @Cajero=SUBSTRING(@Data,@p5+1,@p6-@p5-1)    
Set @Autoriza=SUBSTRING(@Data,@p6+1,@p7-@p6-1)    
Set @CajaID=SUBSTRING(@Data,@p7+1,@p8-@p7-1)    
Begin Transaction    
delete from CajaDetalle     
where DetalleId=@DetalleId    
delete from GastosFijos     
where GastoId=@GastoId    
insert into logCaja values(GETDATE(),convert(varchar,@CajaID),'ELIMINA',    
@Movimiento,@Justificacion,@Monto,@Cajero,@Autoriza,'-')     
Commit Transaction;    
select 'true'    
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarCompraB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminarCompraB]    
@ListaOrden varchar(Max)    
as    
begin    
Declare @pos int    
Declare @CompraId varchar(max)    
Declare @detalle varchar(max)    
Set @pos = CharIndex('[',@ListaOrden,0)    
Set @CompraId= SUBSTRING(@ListaOrden,1,@pos-1)    
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)    
    
Begin Transaction
    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
Declare @Columna varchar(max)    
Declare @c1 int,@c2 int,@c3 int,@c4 int,    
        @c5 int,@c6 int    
Declare @IdProducto numeric(20),    
  @KardexMotivo  varchar(60),    
  @KardexDocumento varchar(60),    
  @CantidadSalida decimal(18, 2),    
  @PrecioCosto decimal(18,4),    
  @Usuario varchar(60)    
Fetch Next From Tabla INTO @Columna    
 While @@FETCH_STATUS = 0    
 Begin    
Set @c1 = CharIndex('|',@Columna,0)    
Set @c2 = CharIndex('|',@Columna,@c1+1)    
Set @c3 = CharIndex('|',@Columna,@c2+1)    
Set @c4 = CharIndex('|',@Columna,@c3+1)    
Set @c5 = CharIndex('|',@Columna,@c4+1)    
Set @c6=Len(@Columna)+1    
Set @IdProducto=convert(numeric(20),SUBSTRING(@Columna,1,@c1-1))    
Set @KardexMotivo=SUBSTRING(@Columna,@c1+1,@c2-@c1-1)    
Set @KardexDocumento=SUBSTRING(@Columna,@c2+1,@c3-@c2-1)    
set @CantidadSalida=convert(decimal(18,2),SUBSTRING(@Columna,@c3+1,@c4-@c3-1))    
set @PrecioCosto=convert(decimal(18,2),SUBSTRING(@Columna,@c4+1,@c5-@c4-1))    
set @Usuario=SUBSTRING(@Columna,@c5+1,@c6-@c5-1)    
    
Declare @AplicaINV nvarchar(1) 

set @AplicaINV=(select top 1 p.AplicaINV
from Producto p (nolock) 
where p.IdProducto=@IdProducto)

if(@AplicaINV='S')
begin
	declare @IniciaStock decimal(18,2),
			@StockFinal decimal(18,2)

	set @IniciaStock=(select top 1 ProductoCantidad 
	from Producto (nolock) 
	where IdProducto=@IdProducto)    
	    
	set @StockFinal=@IniciaStock-@CantidadSalida    
	    
	insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,    
	0,@CantidadSalida,@PrecioCosto,@StockFinal,'SALIDA',@Usuario)    
	    
	update producto     
	set    ProductoCantidad =ProductoCantidad - @CantidadSalida  
	where  IDProducto=@IdProducto  

end
  
Fetch Next From Tabla INTO @Columna    
end    
 Close Tabla;    
 Deallocate Tabla;    
    delete from DetalleCompra     
    where CompraId=@CompraId    
    delete from Compras    
    where CompraId=@CompraId    
 Commit Transaction;    
 select 'true'     
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarGuiaING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminarGuiaING]        
@ListaOrden varchar(Max)        
as        
begin        
Declare @posA1 int,@posA2 int,@posA3 int        
Declare @orden varchar(max),        
        @detalle varchar(max),        
        @Guia varchar(max)                  
Set @posA1 = CharIndex('[',@ListaOrden,0)        
Set @posA2 = CharIndex('[',@ListaOrden,@posA1+1)        
Set @posA3 =Len(@ListaOrden)+1
        
Set @orden = SUBSTRING(@ListaOrden,1,@posA1-1)        
Set @detalle = SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)        
Set @Guia=SUBSTRING(@ListaOrden,@posA2+1,@posA3-@posA2-1)         

Declare @pos1 int,@pos2 int,@pos3 int        
Declare @GuiaId numeric(38),@GuiaConcepto varchar(40),        
        @GuiaUsuario varchar(80)        

Set @pos1 = CharIndex('|',@orden,0)        
Set @pos2 = CharIndex('|',@orden,@pos1+1)        
Set @pos3= Len(@orden)+1        

Set @GuiaId=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))        
Set @GuiaConcepto=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)        
Set @GuiaUsuario=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)        
Begin Transaction        
--delete from DetalleIngreso        
--where GuiaId=@GuiaId        
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')         
Open Tabla        
Declare @Columna varchar(max),        
  @IdStock numeric(38),        
  @Cantidad decimal(18,2),        
  @ValorUM decimal(18,4),        
  @IniciaStock decimal(18,2),        
  @StockFinal decimal(18,4),        
  @CantValor  decimal(18,4),      
  @PrecioCosto decimal(18,4)        
Declare @p1 int,@p2 int,        
        @p3 int        
Fetch Next From Tabla INTO @Columna        
 While @@FETCH_STATUS = 0        
 Begin        
Set @p1 = CharIndex('|',@Columna,0)        
Set @p2 = CharIndex('|',@Columna,@p1+1)        
Set @p3= Len(@Columna)+1        
Set @IdStock=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))        
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))        
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))        
      
set @IniciaStock=(select top 1 p.ProductoCantidad       
from Producto p (nolock)       
where IdProducto=@IdStock)        
set @CantValor=(@Cantidad*@ValorUM)        
      
set @PrecioCosto=(select top 1 p.ProductoCosto from producto p(nolock)        
where p.IdProducto=@IdStock)        
        
set @StockFinal=@IniciaStock-@CantValor        
      
insert into Kardex values(@IdStock,GETDATE(),'Anulacion de la Guia Ingreso',convert(varchar,@GuiaId),
@IniciaStock,0,@CantValor,@PrecioCosto,@StockFinal,'SALIDA',@GuiaUsuario)          
             
update Producto       
set ProductoCantidad=@StockFinal        
where IdProducto=@IdStock        
      
Fetch Next From Tabla INTO @Columna        
end        
 Close Tabla;        
 Deallocate Tabla;        
 --delete from DetalleIngreso    
 --where GuiaId=@GuiaId     
 --delete from GuiaIngreso        
 --where GuiaId=@GuiaId   
 update GuiaIngreso    
 set Estado='ANULADO'  
 where GuiaId=@GuiaId   
 --Commit Transaction;        
 --select 'true'
 if(len(@Guia)>0)        
begin        
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')         
Open TablaB        
Declare @ColumnaB varchar(max)      
Declare @g1 int,@g2 int,      
        @g3 int,@g4 int,@g5 int      
      
Declare @CantidadA decimal(18,2),       
        @IdProductoU numeric(20),                       
        @CantidadU decimal(18,2),                          
        @UmU varchar(40),                                                         
        @ValorUMU decimal(18,4)      
      
Declare @IniciaStockB decimal(18,2),      
        @StockFinalB decimal(18,2)      
                
Fetch Next From TablaB INTO @ColumnaB        
 While @@FETCH_STATUS = 0        
 Begin        
Set @g1 = CharIndex('|',@ColumnaB,0)                         
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                          
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                          
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                          
Set @g5=Len(@ColumnaB)+1         
       
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))      
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))      
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))        
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))        
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))            
      
 Declare @CantidadSalB decimal(18,2)       
      
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                  
                      
 set @IniciaStockB=(select top 1 p.ProductoCantidad       
 from Producto p where p.IdProducto=@IdProductoU)    
         
 set @StockFinalB=@IniciaStockB - @CantidadSalB                                        
     
 insert into Kardex values(@IdProductoU,getdate(),'Anulacion de la Guia Ingreso',
 convert(varchar,@GuiaId),@IniciaStockB,0,@CantidadSalB,0,@StockFinalB,'SALIDA',@GuiaUsuario)     
                                           
 update producto                           
 set  ProductoCantidad =ProductoCantidad - @CantidadSalB                         
 where IDProducto=@IdProductoU      
         
Fetch Next From TablaB INTO @ColumnaB        
end        
    Close TablaB;        
    Deallocate TablaB;        
    Commit Transaction;        
    select 'true'    
end        
else        
begin        
    Commit Transaction;        
    select 'true'    
end        
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarGuiaSAL]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminarGuiaSAL]          
@ListaOrden varchar(Max)          
as          
begin                
Declare @posA1 int,@posA2 int,@posA3 int          
Declare @orden varchar(max),          
        @detalle varchar(max),          
        @Guia varchar(max)
                           
Set @posA1 = CharIndex('[',@ListaOrden,0)          
Set @posA2 = CharIndex('[',@ListaOrden,@posA1+1)          
Set @posA3 =Len(@ListaOrden)+1

Set @orden = SUBSTRING(@ListaOrden,1,@posA1-1)          
Set @detalle = SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)          
Set @Guia=SUBSTRING(@ListaOrden,@posA2+1,@posA3-@posA2-1)  
          
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int          
Declare @GuiaId numeric(38),@GuiaUsuario varchar(80),  
        @Aviso int,@Documento varchar(80)          
Set @pos1=CharIndex('|',@orden,0)          
Set @pos2=CharIndex('|',@orden,@pos1+1)  
Set @pos3=CharIndex('|',@orden,@pos2+1)       
Set @pos4=Len(@orden)+1          
Set @GuiaId=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))                 
Set @GuiaUsuario=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)  
Set @Aviso=convert(int,SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1))  
Set @Documento=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)             
Begin Transaction         
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')           
Open Tabla          
Declare @Columna varchar(max),          
  @IdStock numeric(38),          
  @Cantidad decimal(18,2),          
  @ValorUM decimal(18,4),          
  @IniciaStock decimal(18,2),          
  @StockFinal decimal(18,4),          
  @CantValor  decimal(18,4),        
  @PrecioCosto decimal(18,4),  
  @DetalleId numeric(38)         
Declare @p1 int,@p2 int,          
        @p3 int,@p4 int,@p5 int         
Fetch Next From Tabla INTO @Columna          
 While @@FETCH_STATUS = 0          
 Begin          
Set @p1=CharIndex('|',@Columna,0)          
Set @p2=CharIndex('|',@Columna,@p1+1)  
Set @p3=CharIndex('|',@Columna,@p2+1)  
Set @p4=CharIndex('|',@Columna,@p3+1)              
Set @p5=Len(@Columna)+1          
Set @IdStock=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))          
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))  
Set @PrecioCosto=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))         
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))  
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))           
        
if(@Aviso=1)  
begin  
update DetallePedido    
set CantidadSaldo=CantidadSaldo+@Cantidad    
where DetalleId=@DetalleId  
end  
  
set @IniciaStock=(select top 1 p.ProductoCantidad         
from Producto p (nolock)         
where IdProducto=@IdStock)  
          
set @CantValor=(@Cantidad*@ValorUM)          
                      
set @StockFinal=@IniciaStock+@CantValor          
        
insert into Kardex values(@IdStock,GETDATE(),'Anulacion de la Guia Salida',@Documento,@IniciaStock,          
@CantValor,0,@PrecioCosto,@StockFinal,'INGRESO',@GuiaUsuario)            
        
update Producto         
set ProductoCantidad=@StockFinal          
where IdProducto=@IdStock   
        
Fetch Next From Tabla INTO @Columna          
end          
 Close Tabla;          
 Deallocate Tabla;  
 update GuiaRemision     
 set GuiaEstado='ANULADO'    
 where GuiaId=@GuiaId     
 --Commit Transaction;          
 --select @GuiaId          
if(len(@Guia)>0)          
begin          
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')           
Open TablaB          
Declare @ColumnaB varchar(max)        
Declare @g1 int,@g2 int,        
        @g3 int,@g4 int,@g5 int        
        
Declare @CantidadA decimal(18,2),         
        @IdProductoU numeric(20),                         
        @CantidadU decimal(18,2),                            
        @UmU varchar(40),                                                           
        @ValorUMU decimal(18,4)        
        
Declare @IniciaStockB decimal(18,2),        
        @StockFinalB decimal(18,2)        
                  
Fetch Next From TablaB INTO @ColumnaB          
 While @@FETCH_STATUS = 0          
 Begin          
Set @g1 = CharIndex('|',@ColumnaB,0)                           
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                            
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                            
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                            
Set @g5=Len(@ColumnaB)+1           
         
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))        
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))        
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))          
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))          
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))              
        
 Declare @CantidadSalB decimal(18,2)         
        
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                    
                        
 set @IniciaStockB=(select top 1 p.ProductoCantidad         
 from Producto p where p.IdProducto=@IdProductoU)      
   
 set @StockFinalB=@IniciaStockB + @CantidadSalB                                          
        
 insert into Kardex values(@IdProductoU,GETDATE(),'Anulacion de la Guia Salida',@Documento
 ,@IniciaStockB,@CantidadSalB,0,0,@StockFinalB,'INGRESO',@GuiaUsuario)       
                                               
 update producto                             
 set  ProductoCantidad =ProductoCantidad + @CantidadSalB                           
 where IDProducto=@IdProductoU       
  
Fetch Next From TablaB INTO @ColumnaB          
end          
    Close TablaB;          
    Deallocate TablaB;          
    Commit Transaction;          
    select 'true'   
end          
else          
begin          
    Commit Transaction;          
    select 'true'
end      
                      
END
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarGuiaStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminarGuiaStock]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,@pos3 int
Declare @GuiaId numeric(38),@GuiaConcepto varchar(40),
        @GuiaUsuario varchar(80)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3= Len(@orden)+1
Set @GuiaId=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))
Set @GuiaConcepto=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)
Set @GuiaUsuario=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Begin Transaction
delete from DetalleStock
where GuiaId=@GuiaId
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdStock numeric(38),
		@Cantidad decimal(18,2),
		@ValorUM decimal(18,4),
		@IniciaStock decimal(18,2),
		@StockFinal decimal(18,4),
		@CantValor  decimal(18,4)
Declare @p1 int,@p2 int,
        @p3 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3= Len(@Columna)+1
Set @IdStock=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
set @IniciaStock=(select top 1 Cantidad from Stock(nolock) where IdStock=@IdStock)
set @CantValor=(@Cantidad*@ValorUM)
if(@GuiaConcepto='INGRESO')
BEGIN	
set @StockFinal=@IniciaStock-@CantValor
insert into KardexAlmacen values(@IdStock,GETDATE(),'Anulacion de la Guia Ingreso',@GuiaId,@IniciaStock,
0,@CantValor,@StockFinal,'SALIDA',@GuiaUsuario)
END
else
begin
set @StockFinal=@IniciaStock+@CantValor
insert into KardexAlmacen values(@IdStock,GETDATE(),'Anulacion de la Guia Salida',@GuiaId,@IniciaStock,
@CantValor,0,@StockFinal,'INGRESO',@GuiaUsuario)
end
update Stock
set Cantidad=@StockFinal
where IdStock=@IdStock
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	delete from GuiaAlmacen
	where GuiaId=@GuiaId
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarTemAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminarTemAlmacen]      
@Data varchar(max)      
as      
begin      
Declare @pos1 int,@pos2 int,      
        @pos3 int      
Declare @TemporalId numeric(38),@UsuarioId int,      
        @Concepto  char(1)      
Set @Data = LTRIM(RTrim(@Data))      
Set @pos1 = CharIndex('|',@Data,0)      
Set @pos2 = CharIndex('|',@Data,@pos1+1)      
Set @pos3= Len(@Data)+1      
Set @TemporalId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))      
Set @UsuarioId=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))      
Set @Concepto=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)      
if(@TemporalId='0')      
begin      
delete from TemporalAlmacen      
where UsuarioId=@UsuarioId and Concepto=@Concepto      
end      
else      
begin      
delete from  TemporalAlmacen      
where TemporalId=@TemporalId      
end      
select      
isnull((select STUFF ((select '¬'+      
convert(varchar,t.TemporalId)+'|'+convert(varchar,t.UsuarioId)+'|'+      
convert(varchar,t.IdStok)+'|'+CONVERT(VarChar(50),cast(t.Cantidad as money ), 1)+'|'+t.UniMedida+'|'+      
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar,t.ValorUM)+'|'+t.Concepto      
+'|'+convert(varchar,s.IdProducto)+'|'+CONVERT(varchar,t.CanInicial)+'|'+  
p.ProductoImagen    
from TemporalAlmacen t      
inner join Stock s      
on s.IdStock=t.IdStok      
inner join Producto p      
on p.IdProducto=s.IdProducto      
where t.UsuarioId=@UsuarioId and Concepto=@Concepto      
for xml path('')),1,1,'')),'~')      
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarTemING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminarTemING]        
@Data varchar(max)        
as        
begin        
Declare @pos1 int,@pos2 int,        
        @pos3 int        
Declare @TemporalId numeric(38),@UsuarioId int,        
        @Concepto  char(1)        
Set @Data = LTRIM(RTrim(@Data))        
Set @pos1 = CharIndex('|',@Data,0)        
Set @pos2 = CharIndex('|',@Data,@pos1+1)        
Set @pos3= Len(@Data)+1        
Set @TemporalId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))        
Set @UsuarioId=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))        
Set @Concepto=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)        
if(@TemporalId='0')        
begin        
delete from TemporalAlmacen        
where UsuarioId=@UsuarioId and Concepto=@Concepto        
end        
else        
begin        
delete from  TemporalING        
where TemporalId=@TemporalId        
end        
select            
isnull((select STUFF ((select '¬'+            
convert(varchar,t.TemporalId)+'|'+convert(varchar,t.UsuarioId)+'|'+            
convert(varchar,t.IdProducto)+'|'+CONVERT(VarChar(50),cast(t.Cantidad as money ), 1)+'|'+t.UniMedida+'|'+            
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar,t.ValorUM)+'|'+t.Concepto+'|'+      
p.ProductoImagen+'|'+p.ProductoObs            
from TemporalING t           
inner join Producto p            
on p.IdProducto=t.IdProducto            
where t.UsuarioId=@UsuarioId and Concepto=@Concepto            
for xml path('')),1,1,'')),'~')           
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarUnion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminarUnion]  
@Data varchar(max)  
as  
begin  
Declare @pos1 int,@pos2 int  
Declare @Id int,@IdProducto numeric(20)  
  
Set @Data = LTRIM(RTrim(@Data))    
Set @pos1 = CharIndex('|',@Data,0)  
Set @pos2 =Len(@Data)+1   
Set @Id =convert(int,SUBSTRING(@Data,1,@pos1-1))    
Set @IdProducto=convert(numeric,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))  
  
Begin Transaction  
delete from ProductoUnion   
where Id=@Id  
Commit Transaction;  
  
declare @Valor varchar(max)  
set @Valor=(select     
 isnull((select STUFF ((select ']'+  
 CONVERT(varchar,u.IdProductoB)+':'+convert(varchar,u.Cantidad)+':'+u.UM+':'+  
 convert(varchar,u.ValorUM)  
 from ProductoUnion u(nolock)  
 where u.IdProducto=@IdProducto  
order by u.Id asc  
for xml path('')),1,1,'')),''))  
  
update Producto  
set ProductoObs=@Valor  
where IdProducto=@IdProducto  
select 'true'  
  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEnviarDocu]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEnviarDocu]
@Id int,
@fechainicio date,
@fechafin date
as
select 
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+d.DocuDocumento+'|'+
d.DocuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+c.ClienteDni+'|'+c.ClienteDireccion+'|'+c.ClienteDespacho+'|'+Convert(char(10),d.DocuEmision,110)+'|'+
CONVERT(VarChar(50),d.DocuTotal)+'|'+d.DocuUsuario+'|'+d.DocuEstado
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
where d.CompaniaId=@Id and d.ClienteId <>47 and ((Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)and d.DocuDocumento<>'PROFORMA V')
order by d.DocuEmision asc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.IdProducto)+'|'+
p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+
CONVERT(VarChar(50),d.DetalleCantidad)+'|'+d.DetalleUM+'|'+
CONVERT(VarChar(50),d.DetallPrecio)+'|'+
CONVERT(VarChar(50),d.DetalleImporte)
FROM DetalleDocumento d
inner join DocumentoVenta v
on v.DocuId=d.DocuId
inner join Producto p
on p.IdProducto=d.IdProducto
where v.CompaniaId=@Id and v.ClienteId <>47 and ((Convert(char(10),v.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)and v.DocuDocumento<>'PROFORMA V')
order by v.DocuId asc
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[uspGasto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspGasto]
as
begin
select
'Id|Fecha|Descripcion|Monto|FechaRe|Usuario¬100|120|415|125|100|100¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
g.GastoUsuario
from GastosFijos g 
where month(g.GastoFecha)=month(GETDATE())and year(g.GastoFecha)=year(GETDATE())
order by g.GastoFecha asc,g.GastoId asc
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspGastoFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspGastoFecha]
@fechainicio date,@fechafin date
as
begin
select
'Id|Fecha|Descripcion|Monto|FechaRe|Usuario¬100|120|415|125|100|100¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
g.GastoUsuario
from GastosFijos g 
where (Convert(char(10),g.GastoFecha,103) BETWEEN @fechainicio AND @fechafin)
order by g.GastoFecha asc,g.GastoId asc
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspGuardaUnionPro]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspGuardaUnionPro]  
@detalle varchar(max)  
as  
begin  
Declare @Data varchar(max)  
Begin Transaction  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
  Declare @Columna varchar(max)  
Declare @p1 int,@p2 int,@p3 int  
Declare @Id int,@Cantidad decimal(18,2),  
        @IdProducto numeric(20)  
 Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  
Set @p1 = CharIndex('|',@Columna,0)  
Set @p2 = CharIndex('|',@Columna,@p1+1)   
Set @p3 = Len(@Columna)+1   
Set @Id =convert(int,SUBSTRING(@Columna,1,@p1-1))  
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-@p1-1))  
Set @IdProducto=SUBSTRING(@Columna,@p2+1,@p3-@p2-1)      
  
update ProductoUnion   
set Cantidad=@Cantidad,Estado='E'   
where Id=@Id   
  
Fetch Next From Tabla INTO @Columna  
 end  
 Close Tabla;  
 Deallocate Tabla;  
 Commit Transaction;  
 set @Data=(select     
 isnull((select STUFF ((select ']'+  
 CONVERT(varchar,u.IdProductoB)+':'+convert(varchar,u.Cantidad)+':'+u.UM+':'+  
 convert(varchar,u.ValorUM)  
 from ProductoUnion u(nolock)  
 where u.IdProducto=@IdProducto  
 order by u.Id asc  
 for xml path('')),1,1,'')),''))  
 update Producto  
 set ProductoObs=@Data  
 where IdProducto=@IdProducto  
 Select 'true';  
End
GO
/****** Object:  StoredProcedure [dbo].[uspHistoria]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspHistoria]
@ClienteId numeric(20),
@IdProducto numeric(20)
as
begin
select
'FechaVenta|PrecioUni|Cantidad|UM|Vendedor¬140|100|100|80|150¬String|String|String|String|String¬'+
isnull((select stuff((select '¬'+(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
CONVERT(VarChar(50),cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50),cast(d.DetalleCantidad as money ), 1)+'|'+d.DetalleUm+'|'+
n.NotaUsuario
from DetallePedido d 
inner join NotaPedido n 
on n.NotaId=d.NotaId
where n.ClienteId=@ClienteId and (d.IdProducto=@IdProducto and n.NotaEstado<>'PENDIENTE') 
order by n.NotaFecha desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertaCreditoCompra]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspInsertaCreditoCompra]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int  
Declare @orden varchar(max)  
Declare @detalle varchar(max)  
Declare @facturas varchar(max)  
Declare @Productos varchar(max)  
Set @pos1 = CharIndex('[',@ListaOrden,0)  
Set @pos2 = CharIndex('[',@ListaOrden,@pos1+1)  
Set @pos3 = CharIndex('[',@ListaOrden,@pos2+1)  
Set @pos4 =Len(@ListaOrden)+1  
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)  
Set @facturas=SUBSTRING(@ListaOrden,@pos2+1,@pos3-@pos2-1)  
Set @Productos=SUBSTRING(@ListaOrden,@pos3+1,@pos4-@pos3-1)  
Declare @c1 int,@c2 int,@c3 int,@c4 int,  
        @c5 int,@c6 int,@c7 int,@c8 int,  
        @c9 int,@c10 int,@c11 int,@c12 int,  
        @c13 int,@c14 int,@c15 int,@c16 int,  
        @c17 int,@c18 int,@c19 int,@c20 int,  
        @c21 int,@c22 int,@c23 int,@c24 int  
Declare   
@CompraId numeric(38),@CompaniaId int,@CompraCorrelativo varchar(80),  
@ProveedorId numeric(38),@CompraEmision date,@CompraComputo date,  
@TipoCodigo char(20),@CompraSerie varchar(60),@CompraNumero varchar(80),  
@CompraCondicion varchar(60),@CompraMoneda varchar(60),@CompraTipoCambio decimal(18,3),  
@CompraFechaPago date,@CompraUsuario varchar(80),@CompraTipoIgv varchar(60),  
@CompraValorVenta decimal(18,2),@CompraSubtotal decimal(18,2),@CompraIgv decimal(18,2),  
@CompraTotal decimal(18,2),@CompraEstado varchar(60),@CompraAsociado varchar(60),  
@compraSaldo decimal(18,2),@CompraTipoSunat decimal(18,3),@CompraConcepto varchar(60)          
Set @c1 = CharIndex('|',@orden,0)  
Set @c2 = CharIndex('|',@orden,@c1+1)  
Set @c3 = CharIndex('|',@orden,@c2+1)  
Set @c4 = CharIndex('|',@orden,@c3+1)  
Set @c5 = CharIndex('|',@orden,@c4+1)  
Set @c6= CharIndex('|',@orden,@c5+1)  
Set @c7 = CharIndex('|',@orden,@c6+1)  
Set @c8 = CharIndex('|',@orden,@c7+1)  
Set @c9 = CharIndex('|',@orden,@c8+1)  
Set @c10= CharIndex('|',@orden,@c9+1)  
Set @c11= CharIndex('|',@orden,@c10+1)  
Set @c12= CharIndex('|',@orden,@c11+1)  
Set @c13= CharIndex('|',@orden,@c12+1)  
Set @c14= CharIndex('|',@orden,@c13+1)  
Set @c15= CharIndex('|',@orden,@c14+1)  
Set @c16= CharIndex('|',@orden,@c15+1)  
Set @c17= CharIndex('|',@orden,@c16+1)  
Set @c18= CharIndex('|',@orden,@c17+1)  
Set @c19= CharIndex('|',@orden,@c18+1)  
Set @c20= CharIndex('|',@orden,@c19+1)  
Set @c21= CharIndex('|',@orden,@c20+1)  
Set @c22= CharIndex('|',@orden,@c21+1)  
Set @c23= CharIndex('|',@orden,@c22+1)  
Set @c24= Len(@orden)+1  
Set @CompraId=convert(numeric(38),SUBSTRING(@orden,1,@c1-1))  
Set @CompaniaId=convert(numeric(20),SUBSTRING(@orden,@c1+1,@c2-@c1-1))  
Set @CompraCorrelativo=SUBSTRING(@orden,@c2+1,@c3-@c2-1)  
Set @ProveedorId=convert(int,SUBSTRING(@orden,@c3+1,@c4-@c3-1))  
Set @CompraEmision=convert(date,SUBSTRING(@orden,@c4+1,@c5-@c4-1))  
Set @CompraComputo=convert(date,SUBSTRING(@orden,@c5+1,@c6-@c5-1))  
Set @TipoCodigo=SUBSTRING(@orden,@c6+1,@c7-@c6-1)  
Set @CompraSerie=SUBSTRING(@orden,@c7+1,@c8-@c7-1)  
Set @CompraNumero=SUBSTRING(@orden,@c8+1,@c9-@c8-1)  
Set @CompraCondicion=SUBSTRING(@orden,@c9+1,@c10-@c9-1)  
Set @CompraMoneda=SUBSTRING(@orden,@c10+1,@c11-@c10-1)  
Set @CompraTipoCambio=convert(decimal(18,3),SUBSTRING(@orden,@c11+1,@c12-@c11-1))  
Set @CompraFechaPago=convert(date,SUBSTRING(@orden,@c12+1,@c13-@c12-1))  
Set @CompraUsuario=SUBSTRING(@orden,@c13+1,@c14-@c13-1)  
Set @CompraTipoIgv=SUBSTRING(@orden,@c14+1,@c15-@c14-1)  
Set @CompraValorVenta=convert(decimal(18,2),SUBSTRING(@orden,@c15+1,@c16-@c15-1))  
Set @CompraSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c16+1,@c17-@c16-1))  
Set @CompraIgv=convert(decimal(18,2),SUBSTRING(@orden,@c17+1,@c18-@c17-1))  
Set @CompraTotal=convert(decimal(18,2),SUBSTRING(@orden,@c18+1,@c19-@c18-1))  
Set @CompraEstado=SUBSTRING(@orden,@c19+1,@c20-@c19-1)  
Set @CompraAsociado=SUBSTRING(@orden,@c20+1,@c21-@c20-1)  
Set @compraSaldo=convert(decimal(18,2),SUBSTRING(@orden,@c21+1,@c22-@c21-1))  
Set @CompraTipoSunat=convert(decimal(18,3),SUBSTRING(@orden,@c22+1,@c23-@c22-1))  
Set @CompraConcepto=SUBSTRING(@orden,@c23+1,@c24-@c23-1)  
Begin Transaction  
insert into Compras values(@CompaniaId,@CompraCorrelativo,@ProveedorId,GETDATE(),  
@CompraEmision,@CompraComputo,@TipoCodigo,@CompraSerie,@CompraNumero,@CompraCondicion,  
@CompraMoneda,@CompraTipoCambio,0,@CompraFechaPago,@CompraUsuario,@CompraTipoIgv,  
@CompraValorVenta,0,@CompraSubtotal,@CompraIgv,@CompraTotal,@CompraEstado,  
@CompraAsociado,@compraSaldo,'',@CompraTipoSunat,@CompraConcepto)  
set @CompraId=(select @@identity)  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
Declare @Columna varchar(max),  
  @IdProducto numeric(20),  
  @DetalleCodigo varchar(80),  
  @Descripcion varchar(255),  
  @DetalleUM   varchar(60),  
  @DetalleCantidad decimal(18,2),  
  @PrecioCosto  decimal(18,4),  
  @DetalleImprte decimal(18,4),  
  @DetalleDescuento decimal(18,4),  
  @DetalleEstado varchar(60)  
Declare @d1 int,@d2 int,@d3 int,@d4 int,  
        @d5 int,@d6 int,@d7 int,@d8 int,  
        @d9 int  
Declare @StockInicial decimal(18,2),@StockFinal decimal(18,2)  
Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  
Set @d1 = CharIndex('|',@Columna,0)  
Set @d2 = CharIndex('|',@Columna,@d1+1)  
Set @d3 = CharIndex('|',@Columna,@d2+1)  
Set @d4 = CharIndex('|',@Columna,@d3+1)  
Set @d5 = CharIndex('|',@Columna,@d4+1)  
Set @d6= CharIndex('|',@Columna,@d5+1)  
Set @d7 = CharIndex('|',@Columna,@d6+1)  
Set @d8= CharIndex('|',@Columna,@d7+1)  
Set @d9 = Len(@Columna)+1  
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@d1-1))  
Set @DetalleCodigo=SUBSTRING(@Columna,@d1+1,@d2-(@d1+1))  
Set @Descripcion=SUBSTRING(@Columna,@d2+1,@d3-(@d2+1))  
Set @DetalleUM=SUBSTRING(@Columna,@d3+1,@d4-(@d3+1))  
Set @DetalleCantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@d4+1,@d5-(@d4+1)))  
Set @PrecioCosto=Convert(decimal(18,4),SUBSTRING(@Columna,@d5+1,@d6-(@d5+1)))  
Set @DetalleImprte=Convert(decimal(18,4),SUBSTRING(@Columna,@d6+1,@d7-(@d6+1)))  
Set @DetalleDescuento=Convert(decimal(18,4),SUBSTRING(@Columna,@d7+1,@d8-(@d7+1)))  
Set @DetalleEstado=SUBSTRING(@Columna,@d8+1,@d9-(@d8+1))  
insert into DetalleCompra values(@CompraId,@IdProducto,@DetalleCodigo,  
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImprte,  
@DetalleDescuento,@DetalleEstado,0,'',1)  
if(@CompraEstado='DEVOLUCION')  
begin  
set @StockInicial=(select ProductoCantidad from Producto where IdProducto=@IdProducto)  
set @StockFinal=@StockInicial-@DetalleCantidad  
insert into Kardex values(@IdProducto,GETDATE(),'Salida Por Nota Cre.','NC '+@CompraSerie+'-'+@CompraNumero,  
@StockInicial,0,@DetalleCantidad,@PrecioCosto,@StockFinal,'SALIDA',@CompraUsuario)  
update Producto  
set ProductoCantidad=@StockFinal  
where IdProducto=@IdProducto  
end  
Fetch Next From Tabla INTO @Columna  
end  
 Close Tabla;  
 Deallocate Tabla;   
Declare TablaB Cursor For Select * From fnSplitString(@facturas,';')   
Open TablaB  
Declare @ColumnaB varchar(max),  
        @ID numeric(38),  
  @Factura varchar(80),  
  @Monto decimal(18,2),  
  @Moneda varchar(20),  
  @Acuenta decimal(18,2),  
  @Saldo decimal(18,2)  
Declare @f1 int,@f2 int,@f3 int,  
        @f4 int,@f5 int,@f6 int  
Fetch Next From TablaB INTO @ColumnaB  
 While @@FETCH_STATUS = 0  
 Begin  
Set @f1 = CharIndex('|',@ColumnaB,0)  
Set @f2 = CharIndex('|',@ColumnaB,@f1+1)  
Set @f3 = CharIndex('|',@ColumnaB,@f2+1)  
Set @f4 = CharIndex('|',@ColumnaB,@f3+1)  
Set @f5 = CharIndex('|',@ColumnaB,@f4+1)  
Set @f6= Len(@ColumnaB)+1  
set @ID=Convert(numeric(38),SUBSTRING(@ColumnaB,1,@f1-1))  
Set @Factura=SUBSTRING(@ColumnaB,@f1+1,@f2-(@f1+1))  
Set @Monto=convert(decimal(18,2),SUBSTRING(@ColumnaB,@f2+1,@f3-(@f2+1)))  
Set @Moneda=SUBSTRING(@ColumnaB,@f3+1,@f4-(@f3+1))  
Set @Acuenta=convert(decimal(18,2),SUBSTRING(@ColumnaB,@f4+1,@f5-(@f4+1)))  
Set @Saldo=convert(decimal(18,2),SUBSTRING(@ColumnaB,@f5+1,@f6-(@f5+1)))
  
insert into FacturasNC values(@CompraId,@ID,@Factura,@Monto,@Moneda,  
@Acuenta,@Saldo)  

if(@CompraEstado<>'DESCUENTO INTERNO')  
begin  
update Compras   
set CompraSaldo=@Saldo  
where CompraId=@ID  

update Compras   
set CompraEstado=case when CompraSaldo<=0   
then 'TOTALMENTE PAGADO'   
else 'PENDIENTE DE PAGO' end  
where CompraId=@ID  

end

Fetch Next From TablaB INTO @ColumnaB  
end  
 Close TablaB;  
 Deallocate TablaB;  
if(@CompraEstado='DESCUENTO INTERNO' or @CompraEstado='DESCUENTO')  
BEGIN  
Declare TablaC Cursor For Select * From fnSplitString(@Productos,';')   
Open TablaC  
Declare @ColumnaC varchar(max),  
  @DetalleIdP numeric(38),  
  @IdProductoP numeric(20),  
  @CostoP decimal(18,4),  
  @costoDolarP decimal(18,4),  
  @DescuentoBP decimal(18,4)  
Declare @p1 int,@p2 int,@p3 int,  
        @p4 int,@p5 int  
Fetch Next From TablaC INTO @ColumnaC  
 While @@FETCH_STATUS = 0  
 Begin  
Set @p1 = CharIndex('|',@ColumnaC,0)  
Set @p2 = CharIndex('|',@ColumnaC,@p1+1)  
Set @p3 = CharIndex('|',@ColumnaC,@p2+1)  
Set @p4 = CharIndex('|',@ColumnaC,@p3+1)  
Set @p5 =Len(@ColumnaC)+1  
set @DetalleIdP=Convert(numeric(38),SUBSTRING(@ColumnaC,1,@p1-1))  
Set @IdProductoP=Convert(numeric(20),SUBSTRING(@ColumnaC,@p1+1,@p2-(@p1+1)))  
Set @CostoP=convert(decimal(18,4),SUBSTRING(@ColumnaC,@p2+1,@p3-(@p2+1)))  
Set @costoDolarP=convert(decimal(18,4),SUBSTRING(@ColumnaC,@p3+1,@p4-(@p3+1)))  
Set @DescuentoBP=convert(decimal(18,4),SUBSTRING(@ColumnaC,@p4+1,@p5-(@p4+1)))  

update Producto   
set ProductoCosto=@CostoP,ProductoCostoDolar=@costoDolarP,
ProductoTipoCambio=@CompraTipoCambio  
where IdProducto=@IdProductoP   

if(@CompraEstado<>'BONIFICACION')  
begin  
if(@TipoCodigo='101' or @TipoCodigo='07')   
begin  
	update DetalleCompra  
	set DescuentoB=@DescuentoBP  
	where DetalleId=@DetalleIdP  
end  
end  
Fetch Next From TablaC INTO @ColumnaC  
end  
 Close TablaC;  
 Deallocate TablaC;  
end  
 Commit Transaction  
 select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaDetalleTurno]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaDetalleTurno]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos1 int,@pos2 int  
Declare @orden varchar(max),  
        @detalle varchar(max)  
Set @pos1 = CharIndex('[',@ListaOrden,0)  
Set @pos2=Len(@ListaOrden)+1  
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)  
Declare @c1 int,@c2 int  
Set @c1 = CharIndex('|',@orden,0)  
Set @c2 =  Len(@orden)+1      
Declare @PersonalId numeric(20),  
        @TurnoId int  
set @PersonalId=convert(numeric(20),SUBSTRING(@orden,1,@c1-1))  
set @TurnoId=convert(int,SUBSTRING(@orden,@c1+1,@c2-@c1-1))  
Declare @Aviso int  
set @Aviso=(select COUNT(d.PersonalId) from DetalleTurnos d  
where PersonalId=@PersonalId)  
Begin Transaction  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
        Declare @Columna varchar(max)  
        Declare @DetalleId numeric(38),  
        @Estado bit,  
        @Dia nvarchar(40)  
        Declare @p1 int,@p2 int,@p3 int  
Fetch Next From Tabla INTO @Columna  
While @@FETCH_STATUS = 0  
Begin  
        Set @Columna= LTRIM(RTrim(@Columna))  
  Set @p1 = CharIndex('|',@Columna,0)  
  Set @p2 = CharIndex('|',@Columna,@p1+1)  
  Set @p3=Len(@Columna)+1  
        Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))  
  Set @Estado=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))  
  Set @Dia=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))  
  if(@Aviso=0)  
        begin  
        insert into DetalleTurnos values(@PersonalId,1,@Dia,'0')  
        set @DetalleId=(select @@IDENTITY)  
        update DetalleTurnos  
  set TurnoId=@TurnoId,Estado=@Estado  
  where DetalleId=@DetalleId  
        end  
        else  
        begin  
  update DetalleTurnos  
  set TurnoId=@TurnoId,Estado=@Estado  
  where PersonalId=@PersonalId and Dia=@Dia  
  end  
Fetch Next From Tabla INTO @Columna  
End  
 Close Tabla;  
 Deallocate Tabla;  
 Commit Transaction;  
 Select 'true';  
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertaDetalleVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertaDetalleVenta] 
@Data varchar(max)  
as  
begin        
Declare @pos1 int,@pos2 int,        
  @pos3 int,@pos4 int,        
  @pos5 int,@pos6 int,        
  @pos7 int,@pos8 int,@pos9 int        
Declare @NotaID int,        
  @IdProducto numeric(20),        
  @cantidad decimal(18,2),
  @Unidad varchar(40),
  @Descripcion varchar(max),
  @PreCosto decimal(18,2),        
  @precioventa decimal(18,2),        
  @importe decimal(18,2),        
  @ValorUM decimal(18,4)        
      
Set @Data = LTRIM(RTrim(@Data))        
Set @pos1 = CharIndex('|',@Data,0)        
Set @pos2 = CharIndex('|',@Data,@pos1+1)        
Set @pos3 = CharIndex('|',@Data,@pos2+1)        
Set @pos4 = CharIndex('|',@Data,@pos3+1)        
Set @pos5= CharIndex('|',@Data,@pos4+1)        
Set @pos6= CharIndex('|',@Data,@pos5+1)
Set @pos7= CharIndex('|',@Data,@pos6+1)        
Set @pos8= CharIndex('|',@Data,@pos7+1)      
Set @pos9=Len(@Data)+1        
Set @NotaID=convert(int,SUBSTRING(@Data,1,@pos1-1))        
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))        
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)) 
Set @Unidad=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
Set @Descripcion=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
Set @PreCosto=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))      
Set @precioventa=convert(decimal(18,2),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))        
Set @importe=convert(decimal(18,2),SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1))        
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos8+1,@pos9-@pos8-1))        

insert into DetallePedido values(@NotaID,@IdProducto,@cantidad,@Unidad,@Descripcion,  
@PreCosto,@precioventa,@importe,'PENDIENTE',0,@ValorUM,'P')  
select 'true'
 
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaFactura]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaFactura]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,
        @pos13 int,@pos14 int,@pos15 int,@pos16 int,
        @pos17 int,@pos18 int,@pos19 int,@pos20 int,
        @pos21 int,@pos22 int,@pos23 int
Declare @CompaniaId int,@NotaId numeric(38),@DocuDocumento varchar(60),
         @DocuNumero varchar(60),@ClienteId numeric(20),@DocuEmision date,
         @DocuSubTotal decimal(18,2),@DocuIgv decimal(18,2),@DocuTotal decimal(18,2),
         @DocuUsuario varchar(60),@DocuSerie char(4),@TipoCodigo char(20),
         @DocuAdicional decimal(18,2),@DocuAsociado varchar(80),@DocuConcepto varchar(80),
         @DocuHASH varchar(250),@EstadoSunat varchar(80),@Letras varchar(60),
         @DocuId numeric(38),@TraeEstado varchar(80),@NotaEstado varchar(80),
         @ICBPER decimal(18,2),@CodigoSunat VARCHAR(80),@MensajeSunat varchar(max),
         @DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3 = CharIndex('|',@orden,@pos2+1)
Set @pos4 = CharIndex('|',@orden,@pos3+1)
Set @pos5 = CharIndex('|',@orden,@pos4+1)
Set @pos6= CharIndex('|',@orden,@pos5+1)
Set @pos7 = CharIndex('|',@orden,@pos6+1)
Set @pos8 = CharIndex('|',@orden,@pos7+1)
Set @pos9 = CharIndex('|',@orden,@pos8+1)
Set @pos10= CharIndex('|',@orden,@pos9+1)
Set @pos11= CharIndex('|',@orden,@pos10+1)
Set @pos12= CharIndex('|',@orden,@pos11+1)
Set @pos13= CharIndex('|',@orden,@pos12+1)
Set @pos14= CharIndex('|',@orden,@pos13+1)
Set @pos15= CharIndex('|',@orden,@pos14+1)
Set @pos16= CharIndex('|',@orden,@pos15+1)
Set @pos17= CharIndex('|',@orden,@pos16+1)
Set @pos18= CharIndex('|',@orden,@pos17+1)
Set @pos19= CharIndex('|',@orden,@pos18+1)
Set @pos20= CharIndex('|',@orden,@pos19+1)
Set @pos21= CharIndex('|',@orden,@pos20+1)
Set @pos22= CharIndex('|',@orden,@pos21+1)
Set @pos23= Len(@orden)+1
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@pos1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))
Set @DocuDocumento=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set @DocuNumero=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1))
Set @DocuEmision=convert(date,SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1))
Set @DocuSubTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1))
Set @DocuIgv=convert(decimal(18,2),SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))
Set @DocuTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1))
Set @DocuUsuario=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)
Set @DocuSerie=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)
Set @TipoCodigo=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1))
set @DocuAsociado=SUBSTRING(@orden,@pos13+1,@pos14-@pos13-1)
set @DocuConcepto=SUBSTRING(@orden,@pos14+1,@pos15-@pos14-1)
set @DocuHASH=SUBSTRING(@orden,@pos15+1,@pos16-@pos15-1)
set @EstadoSunat=SUBSTRING(@orden,@pos16+1,@pos17-@pos16-1)
set @Letras=SUBSTRING(@orden,@pos17+1,@pos18-@pos17-1)
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@pos18+1,@pos19-@pos18-1))
set @CodigoSunat=SUBSTRING(@orden,@pos19+1,@pos20-@pos19-1)
set @MensajeSunat=SUBSTRING(@orden,@pos20+1,@pos21-@pos20-1)
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@pos21+1,@pos22-@pos21-1))
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@pos22+1,@pos23-@pos22-1))
set @TraeEstado=(select top 1 n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)
if(@TraeEstado='PENDIENTE')set @NotaEstado='EMITIDO'
else set @NotaEstado=@TraeEstado
Begin Transaction
insert into DocumentoVenta values(@CompaniaId,@NotaId,@DocuDocumento,@DocuNumero,
@ClienteId,GETDATE(),@DocuEmision,'ALCONTADO',1,GETDATE(),
@DocuEmision,@Letras,@DocuSubTotal,@DocuIgv,@DocuTotal,0,
@DocuUsuario,'EMITIDO',@DocuSerie,@TipoCodigo,@DocuAdicional,@DocuAsociado,
@DocuConcepto,'',@DocuHASH,@EstadoSunat,@ICBPER,@CodigoSunat,@MensajeSunat,
@DocuGravada,@DocuDescuento,'')
Set @DocuId= @@identity
update NotaPedido 
set CompaniaId=@CompaniaId,NotaSerie=@DocuSerie,
NotaNumero=@DocuNumero,NotaEstado=@NotaEstado
where NotaId=@NotaId
   Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@Importe decimal(18,2),
		@DetalleNotaId numeric(38),
		@UM varchar(80),
		@ValorUM decimal(18,4)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @UM=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
insert into DetalleDocumento 
values(@DocuId,@IdProducto,@Cantidad,@Precio,@Importe,@DetalleNotaId,@UM,@ValorUM)
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Declare @EstadoDetalle varchar(80)
	if(@EstadoSunat='PENDIENTE')set @EstadoDetalle='PENDIENTEB'
	else set @EstadoDetalle='EMITIDO'
	update DetallePedido
	set DetalleEstado=@EstadoDetalle
	where NotaId=@NotaId
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaGasto]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaGasto]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
declare
@GastoId int,
@GastoFecha date,
@GsstoDesc varchar(max),
@GstoMonto decimal(18,2),
@GastoUsuario varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @GastoId=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @GastoFecha=convert(date,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @GsstoDesc=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @GstoMonto=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5= Len(@Data)+1
Set @GastoUsuario=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
if @GastoId=0
begin
IF EXISTS(select * from GastosFijos g where g.GsstoDesc=@GsstoDesc and
(Month(g.GastoFecha)=MONTH(@GastoFecha) and year(g.GastoFecha)=YEAR(@GastoFecha)))
select 'existe'
else
begin
insert into GastosFijos values(@GastoFecha,@GsstoDesc,@GstoMonto,GETDATE(),@GastoUsuario)
	select isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
	g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
	(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
	g.GastoUsuario
	from GastosFijos g 
	where month(g.GastoFecha)=month(GETDATE())and year(g.GastoFecha)=year(GETDATE())
	order by g.GastoFecha asc,g.GastoId asc
	FOR XML PATH('')), 1, 1, '')),'~')	
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaLiquidaVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspinsertaLiquidaVenta]
@ListaOrden varchar(Max)
as
begin
Declare @pos1 int,@pos2 int
Declare @orden varchar(max),
        @detalle varchar(max)
Set @pos1 = CharIndex('[',@ListaOrden,0)
Set @pos2 =Len(@ListaOrden)+1
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)
Declare @c1 int,@c2 int,@c3 int,@c4 int,
        @c5 int,@c6 int,@c7 int,@c8 int,
        @c9 int,@c10 int,@c11 int,@c12 int
Declare
@LiquidacionNumero varchar(80),
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60),
@CajaId nvarchar(40)
Set @c1 = CharIndex('|',@orden,0)
Set @c2 = CharIndex('|',@orden,@c1+1)
Set @c3 = CharIndex('|',@orden,@c2+1)
Set @c4 = CharIndex('|',@orden,@c3+1)
Set @c5 = CharIndex('|',@orden,@c4+1)
Set @c6= CharIndex('|',@orden,@c5+1)
Set @c7 = CharIndex('|',@orden,@c6+1)
Set @c8 = CharIndex('|',@orden,@c7+1)
Set @c9 = CharIndex('|',@orden,@c8+1)
Set @c10= CharIndex('|',@orden,@c9+1)
Set @c11= CharIndex('|',@orden,@c10+1)
Set @c12= Len(@orden)+1
set @LiquidacionNumero=SUBSTRING(@orden,1,@c1-1)
set @LiquidacionFecha=convert(date,SUBSTRING(@orden,@c1+1,@c2-@c1-1))
set @LiquidacionDescripcion=SUBSTRING(@orden,@c2+1,@c3-@c2-1)
set @LiquidacionCambio=Convert(decimal(18,3),SUBSTRING(@orden,@c3+1,@c4-@c3-1))
set @LiquidaEfectivoSol=convert(decimal(18,2),SUBSTRING(@orden,@c4+1,@c5-@c4-1))
set @LiquidaDepositoSol=convert(decimal(18,2),SUBSTRING(@orden,@c5+1,@c6-@c5-1))
set @LiquidaTotalSol=convert(decimal(18,2),SUBSTRING(@orden,@c6+1,@c7-@c6-1))
set @LiquidaEfectivoDol=convert(decimal(18,2),SUBSTRING(@orden,@c7+1,@c8-@c7-1))
set @LiquidaDepositoDol=convert(decimal(18,2),SUBSTRING(@orden,@c8+1,@c9-@c8-1))
set @LiquidaTotalDol=convert(decimal(18,2),SUBSTRING(@orden,@c9+1,@c10-@c9-1))
set @LiquidaUsuario=SUBSTRING(@orden,@c10+1,@c11-@c10-1)
set @CajaId=SUBSTRING(@orden,@c11+1,@c12-@c11-1)
Declare @LiquidacionId numeric(38)
Begin Transaction
insert into LiquidacionVenta values(@LiquidacionNumero,
GETDATE(),@LiquidacionFecha,@LiquidacionDescripcion,
@LiquidacionCambio,@LiquidaEfectivoSol,@LiquidaDepositoSol,
@LiquidaTotalSol,@LiquidaEfectivoDol,@LiquidaDepositoDol,
@LiquidaTotalDol,@LiquidaUsuario)
set @LiquidacionId=(select @@identity)
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@DocuId numeric(38),
		@NotaId numeric(38),
		@SaldoDocu decimal(18,2),
		@EfectivoSoles decimal(18, 2),
		@EfectivoDolar decimal(18, 2),
		@DepositoSoles decimal(18, 2),
		@DepositoDolar decimal(18, 2),
		@TipoCambio decimal(18, 3),
		@EntidadBanco varchar(80),
		@NroOperacion varchar(80),
		@AcuentaGeneral decimal(18, 2),
		@SaldoActual decimal(18, 2),
		@FechaPago varchar(60),
		@DocuEstado varchar(60),
		@NumeroDoc varchar(80),
		@DetalleId numeric(38)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int,@p8 int,
        @p9 int,@p10 int,@p11 int,
        @p12 int,@p13 int,@p14 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7= CharIndex('|',@Columna,@p6+1)
Set @p8 = CharIndex('|',@Columna,@p7+1)
Set @p9 = CharIndex('|',@Columna,@p8+1)
Set @p10 = CharIndex('|',@Columna,@p9+1)
Set @p11= CharIndex('|',@Columna,@p10+1)
Set @p12= CharIndex('|',@Columna,@p11+1)
Set @p13= CharIndex('|',@Columna,@p12+1)
Set @p14=Len(@Columna)+1
set @DocuId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @NumeroDoc=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
Set @SaldoDocu=convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @TipoCambio=convert(decimal(18,3),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))
Set @EfectivoSoles=convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @EfectivoDolar=convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @DepositoSoles=convert(decimal(18,2),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
Set @DepositoDolar=convert(decimal(18,2),SUBSTRING(@Columna,@p7+1,@p8-(@p7+1)))
Set @EntidadBanco=SUBSTRING(@Columna,@p8+1,@p9-(@p8+1))
Set @NroOperacion=SUBSTRING(@Columna,@p9+1,@p10-(@p9+1))
Set @AcuentaGeneral=convert(decimal(18,2),SUBSTRING(@Columna,@p10+1,@p11-(@p10+1)))
Set @FechaPago=SUBSTRING(@Columna,@p11+1,@p12-(@p11+1))
Set @SaldoActual=convert(decimal(18,2),SUBSTRING(@Columna,@p12+1,@p13-(@p12+1)))
Set @NotaId=convert(numeric(38),SUBSTRING(@Columna,@p13+1,@p14-(@p13+1)))
if (@SaldoActual <= 0) set @DocuEstado='CANCELADO'
else set @DocuEstado='EMITIDO'
insert into DetaLiquidaVenta values(
@LiquidacionId,@DocuId,@NotaId,@SaldoDocu,@EfectivoSoles,
@EfectivoDolar,@DepositoSoles,@DepositoDolar,
@TipoCambio,@EntidadBanco,@NroOperacion,
@AcuentaGeneral,@SaldoActual,@FechaPago)
set @DetalleId=(select @@IDENTITY)
if(@DepositoSoles>0)
begin
insert into CajaDetalle values(@CajaId,GETDATE(),'0','DEPOSITO','LIQUIDACION',
'LIQUIDACION DEL DOC NRO '+@NumeroDoc,@DepositoSoles,
@DepositoSoles,0,'','T','',@LiquidaUsuario,'',CONVERT(varchar,@DetalleId))
end
if(@EfectivoSoles>0)
BEGIN
insert into CajaDetalle values(@CajaId,GETDATE(),'0','INGRESO','LIQUIDACION',
'LIQUIDACION DEL DOC NRO '+@NumeroDoc,@EfectivoSoles,
@EfectivoSoles,0,'','T','',@LiquidaUsuario,'',CONVERT(varchar,@DetalleId))
END
update NotaPedido
set NotaSaldo=NotaSaldo-@AcuentaGeneral,NotaEstado=@DocuEstado
where NotaId=@NotaId
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	SELECT 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarCuenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertarCuenta]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
declare @CuentaId numeric(38),
@ProveedorId numeric(38),
@Entidad varchar(80),
@TipoCuenta varchar(80),
@Moneda varchar(80),
@NroCuenta varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @CuentaId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @ProveedorId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @Entidad=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @TipoCuenta=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @Moneda=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
Set @pos6 = Len(@Data)+1
Set @NroCuenta=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)
if(@CuentaId=0)
begin
insert into CuentaProveedor values(@ProveedorId,@Entidad,@TipoCuenta,@Moneda,@NroCuenta)
select isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.CuentaId)+'|'+c.Entidad+'|'+
c.TipoCuenta+'|'+c.Moneda+'|'+c.NroCuenta
from CuentaProveedor c
where c.ProveedorId=@ProveedorId
order by c.CuentaId desc
for xml path('')),1,1,'')),'~')
end
else
begin
update CuentaProveedor
set TipoCuenta=@TipoCuenta,NroCuenta=@NroCuenta
where CuentaId=@CuentaId
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaRechazo]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaRechazo]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,
        @pos13 int,@pos14 int,@pos15 int,@pos16 int,
        @pos17 int,@pos18 int,@pos19 int,@pos20 int,
        @pos21 int
 Declare @CompaniaId int,@NotaId numeric(38),@DocuDocumento varchar(60),
         @DocuNumero varchar(60),@ClienteId numeric(20),@DocuEmision date,
         @DocuSubTotal decimal(18,2),@DocuIgv decimal(18,2),@DocuTotal decimal(18,2),
         @DocuUsuario varchar(60),@DocuSerie char(4),@TipoCodigo char(20),
         @DocuAdicional decimal(18,2),@DocuAsociado varchar(80),@DocuConcepto varchar(80),
         @DocuHASH varchar(250),@EstadoSunat varchar(80),@Letras varchar(60),
         @DocuId numeric(38),@TraeEstado varchar(80),@NotaEstado varchar(80),
         @ICBPER decimal(18,2),@CodigoSunat VARCHAR(80),@MensajeSunat varchar(max)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3 = CharIndex('|',@orden,@pos2+1)
Set @pos4 = CharIndex('|',@orden,@pos3+1)
Set @pos5 = CharIndex('|',@orden,@pos4+1)
Set @pos6= CharIndex('|',@orden,@pos5+1)
Set @pos7 = CharIndex('|',@orden,@pos6+1)
Set @pos8 = CharIndex('|',@orden,@pos7+1)
Set @pos9 = CharIndex('|',@orden,@pos8+1)
Set @pos10= CharIndex('|',@orden,@pos9+1)
Set @pos11= CharIndex('|',@orden,@pos10+1)
Set @pos12= CharIndex('|',@orden,@pos11+1)
Set @pos13= CharIndex('|',@orden,@pos12+1)
Set @pos14= CharIndex('|',@orden,@pos13+1)
Set @pos15= CharIndex('|',@orden,@pos14+1)
Set @pos16= CharIndex('|',@orden,@pos15+1)
Set @pos17= CharIndex('|',@orden,@pos16+1)
Set @pos18= CharIndex('|',@orden,@pos17+1)
Set @pos19= CharIndex('|',@orden,@pos18+1)
Set @pos20= CharIndex('|',@orden,@pos19+1)
Set @pos21= Len(@orden)+1
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@pos1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))
Set @DocuDocumento=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set @DocuNumero=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1))
Set @DocuEmision=convert(date,SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1))
Set @DocuSubTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1))
Set @DocuIgv=convert(decimal(18,2),SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))
Set @DocuTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1))
Set @DocuUsuario=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)
Set @DocuSerie=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)
Set @TipoCodigo=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1))
set @DocuAsociado=SUBSTRING(@orden,@pos13+1,@pos14-@pos13-1)
set @DocuConcepto=SUBSTRING(@orden,@pos14+1,@pos15-@pos14-1)
set @DocuHASH=SUBSTRING(@orden,@pos15+1,@pos16-@pos15-1)
set @EstadoSunat=SUBSTRING(@orden,@pos16+1,@pos17-@pos16-1)
set @Letras=SUBSTRING(@orden,@pos17+1,@pos18-@pos17-1)
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@pos18+1,@pos19-@pos18-1))
set @CodigoSunat=SUBSTRING(@orden,@pos19+1,@pos20-@pos19-1)
set @MensajeSunat=SUBSTRING(@orden,@pos20+1,@pos21-@pos20-1)
set @TraeEstado=(select top 1 n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)
if(@TraeEstado='PENDIENTE')set @NotaEstado='EMITIDO'
else set @NotaEstado=@TraeEstado
Begin Transaction
insert into DocumentoVenta values(@CompaniaId,@NotaId,@DocuDocumento,@DocuNumero,
@ClienteId,GETDATE(),@DocuEmision,'ALCONTADO',1,GETDATE(),
@DocuEmision,'CERO CON 00/100 SOLES',0,0,0,0,
@DocuUsuario,'RECHAZADO',@DocuSerie,@TipoCodigo,0,@DocuAsociado,
@DocuConcepto,'',@DocuHASH,'RECHAZADO',0,@CodigoSunat,@MensajeSunat,0,0,'')
Set @DocuId= @@identity
update NotaPedido 
set CompaniaId=@CompaniaId,NotaSerie=@DocuSerie,
NotaNumero=@DocuNumero,NotaEstado=@NotaEstado
where NotaId=@NotaId
   Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@Importe decimal(18,2),
		@DetalleNotaId numeric(38),
		@UM varchar(80),
		@ValorUM decimal(18,4)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @UM=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
insert into DetalleDocumento 
values(@DocuId,@IdProducto,@Cantidad,@Precio,@Importe,@DetalleNotaId,@UM,@ValorUM)
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	update DetallePedido
	set DetalleEstado='PENDIENTE'
	where NotaId=@NotaId
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarGuia]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarGuia]              
@ListaOrden varchar(Max)          
as          
Begin           
Declare @posA1 int,@posA2 int,@posA3 int                  
Declare @orden varchar(max),                  
        @detalle varchar(max),                  
        @Guia varchar(max)              
                         
Set @posA1 = CharIndex('[',@ListaOrden,0)                  
Set @posA2 = CharIndex('[',@ListaOrden,@posA1+1)                  
Set @posA3 =Len(@ListaOrden)+1                  
Set @orden = SUBSTRING(@ListaOrden,1,@posA1-1)                  
Set @detalle = SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)                  
Set @Guia=SUBSTRING(@ListaOrden,@posA2+1,@posA3-@posA2-1)          
          
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,                                      
        @pos5 int,@pos6 int,@pos7 int ,@pos8 int,                          
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,          
        @pos13 int          
          
Declare @GuiaNumero varchar(60),@GuiaMotivo varchar(80),                
  @GuiaDestinatario varchar(250),@GuiaRucDes varchar(60),              
  @GuiaAlmacen varchar(80),@GuiaPartida varchar(max),              
  @GuiaLLegada varchar(max),@GuiaTramsporte varchar(80),               
  @GuiaUsuario varchar(80),@GuiaTotal decimal(18,2),              
        @ClienteId numeric(20),@GuiaTelefono varchar(80),          
        @GuiaId numeric(38),@UsuarioId int          
                 
Set @pos1=CharIndex('|',@orden,0)                                      
Set @pos2=CharIndex('|',@orden,@pos1+1)                                      
Set @pos3=CharIndex('|',@orden,@pos2+1)                                      
Set @pos4=CharIndex('|',@orden,@pos3+1)                                      
Set @pos5=CharIndex('|',@orden,@pos4+1)                                      
Set @pos6=CharIndex('|',@orden,@pos5+1)                                    
Set @pos7=CharIndex('|',@orden,@pos6+1)                            
Set @pos8=CharIndex('|',@orden,@pos7+1)                          
Set @pos9=CharIndex('|',@orden,@pos8+1)                                      
Set @pos10=CharIndex('|',@orden,@pos9+1)                                      
Set @pos11=CharIndex('|',@orden,@pos10+1)          
Set @pos12=CharIndex('|',@orden,@pos11+1)                                                    
Set @pos13=Len(@orden)+1            
          
Set @GuiaNumero=SUBSTRING(@orden,1,@pos1-1)                                      
Set @GuiaMotivo=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)                          
Set @GuiaDestinatario=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)                                      
Set @GuiaRucDes=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)                                      
Set @GuiaAlmacen=SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1)                                      
Set @GuiaPartida=SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1)                                      
Set @GuiaLLegada=SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1)                         
Set @GuiaTramsporte=SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1)                                      
Set @GuiaUsuario=SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1)                        
Set @GuiaTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1))                                      
Set @ClienteId=convert(int,SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1))                            
Set @GuiaTelefono=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)          
Set @UsuarioId=convert(int,SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1))                
          
Begin Transaction          
          
insert into GuiaRemision values(@GuiaNumero,@GuiaMotivo,              
GETDATE(),@GuiaDestinatario,@GuiaRucDes,@GuiaAlmacen,@GuiaPartida,              
@GuiaLLegada,@GuiaTramsporte,@GuiaUsuario,@GuiaTotal,'SALIDA',            
@ClienteId,'',@GuiaTelefono)                           
Set @GuiaId= @@identity          
          
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')                   
Open Tabla                                      
                                    
Declare @Columna varchar(max),                                      
  @IdProducto numeric(20),            
  @DetalleCantidad decimal(18,2),            
  @DetalleCosto decimal(18,4),            
  @DetallePrecio decimal(18, 2),            
  @DetalleImporte decimal(18, 2),            
  @DetalleEstado varchar(60),            
  @flac int,            
  @IdDetalle numeric(38),            
  @Documento varchar(80),            
  @Usuario varchar(80),            
  @Concepto varchar(80),            
  @ValorUM decimal(18,4),            
  @UniMedida varchar(40),                                   
                                      
  @StockInicial decimal(18,2),                                      
  @StockFinal decimal(18,2),@CantidadIng decimal(18,2)                                    
                                        
Declare @p1 int,@p2 int,@p3 int,@p4 int,                                      
        @p5 int,@p6 int,@p7 int,@p8 int,            
        @p9 int,@p10 int,@p11 int,@p12 int,            
        @p13 int                                    
                                            
Fetch Next From Tabla INTO @Columna                                      
 While @@FETCH_STATUS = 0                                      
 Begin                                      
Set @p1=CharIndex('|',@Columna,0)                                      
Set @p2=CharIndex('|',@Columna,@p1+1)                                      
Set @p3=CharIndex('|',@Columna,@p2+1)                                      
Set @p4=CharIndex('|',@Columna,@p3+1)                            
Set @p5=CharIndex('|',@Columna,@p4+1)                                      
Set @p6=CharIndex('|',@Columna,@p5+1)                
Set @p7=CharIndex('|',@Columna,@p6+1)            
Set @p8=CharIndex('|',@Columna,@p7+1)          
Set @p9=CharIndex('|',@Columna,@p8+1)                                      
Set @p10=CharIndex('|',@Columna,@p9+1)                
Set @p11=CharIndex('|',@Columna,@p10+1)            
Set @p12=CharIndex('|',@Columna,@p11+1)                                         
Set @p13=Len(@Columna)+1                                    
                                     
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))                            
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))                                      
Set @DetalleCosto=convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))                             
Set @DetallePrecio=convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))                            
Set @DetalleImporte=Convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))                            
Set @DetalleEstado=SUBSTRING(@Columna,@p5+1,@p6-(@p5+1))                             
Set @flac=Convert(int,SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))                
Set @IdDetalle=Convert(numeric(38),SUBSTRING(@Columna,@p7+1,@p8-(@p7+1)))            
Set @Documento=SUBSTRING(@Columna,@p8+1,@p9-(@p8+1))          
          
Set @Usuario=SUBSTRING(@Columna,@p9+1,@p10-(@p9+1))                              
Set @Concepto=SUBSTRING(@Columna,@p10+1,@p11-(@p10+1))                
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p11+1,@p12-(@p11+1)))            
Set @UniMedida=SUBSTRING(@Columna,@p12+1,@p13-(@p12+1))                                        
          
insert into DetalleGuia values(@GuiaId,@IdProducto,@DetalleCantidad,@DetalleCosto,            
@DetallePrecio,@DetalleImporte,@DetalleEstado,@IdDetalle,@ValorUM,@UniMedida)          
                                                 
set @StockInicial=(select top 1 ProductoCantidad                 
from Producto(nolock)                                       
where IdProducto=@IdProducto)                                      
                                    
set @CantidadIng=(@DetalleCantidad*@ValorUM)                                      
set @StockFinal=@StockInicial-@CantidadIng                                      
                                    
          
if(@flac=1)          
begin           
update DetallePedido            
set CantidadSaldo=CantidadSaldo-@DetalleCantidad--@CantidadIng          
where DetalleId=@IdDetalle         
end          
           
update producto             
set ProductoCantidad =@StockFinal            
where IDProducto=@IDProducto            
                                                            
insert into Kardex values(@IdProducto,GETDATE(),'Salida por Guia',@Documento,          
@StockInicial,0,@CantidadIng,@DetalleCosto,@StockFinal,'SALIDA',@Usuario)                                    
                                  
Fetch Next From Tabla INTO @Columna                                      
end                       
Close Tabla;                                      
Deallocate Tabla;                    
delete from TemporalGuia           
where UsuarioID=@UsuarioId and Concepto=@Concepto                             
 --Commit Transaction;                  
 --select @GuiaId                  
if(len(@Guia)>0)                  
begin                  
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')                   
Open TablaB                  
Declare @ColumnaB varchar(max)                
Declare @g1 int,@g2 int,                
        @g3 int,@g4 int,@g5 int                
                
Declare @CantidadA decimal(18,2),                 
        @IdProductoU numeric(20),                                 
        @CantidadU decimal(18,2),                                    
        @UmU varchar(40),                                                                   
        @ValorUMU decimal(18,4)                
                
Declare @IniciaStockB decimal(18,2),                
        @StockFinalB decimal(18,2)                
                          
Fetch Next From TablaB INTO @ColumnaB                  
 While @@FETCH_STATUS = 0                  
 Begin                  
Set @g1 = CharIndex('|',@ColumnaB,0)                                   
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                                    
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                                    
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                                    
Set @g5=Len(@ColumnaB)+1                   
                 
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))                
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))                
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))                  
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))                  
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))                      
                
 Declare @CantidadSalB decimal(18,2)                 
                
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                            
                                
 set @IniciaStockB=(select top 1 p.ProductoCantidad                 
 from Producto p where p.IdProducto=@IdProductoU)              
           
 set @StockFinalB=@IniciaStockB - @CantidadSalB                                                  
                
 insert into Kardex values(@IdProductoU,GETDATE(),'Salida por Guia',@Documento,@IniciaStockB,                                      
 0,@CantidadSalB,0,@StockFinalB,'SALIDA',@GuiaUsuario)               
                                                       
 update producto                                     
 set  ProductoCantidad =ProductoCantidad - @CantidadSalB                                   
 where IDProducto=@IdProductoU               
          
Fetch Next From TablaB INTO @ColumnaB                  
end                  
    Close TablaB;                  
    Deallocate TablaB;                  
    Commit Transaction;                  
    select convert(varchar,@GuiaId)           
end                  
else                  
begin           
    Commit Transaction;                  
    select convert(varchar,@GuiaId)           
end              
                              
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarGuiaING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspInsertarGuiaING]        
@ListaOrden varchar(Max)        
as        
begin              
Declare @posA1 int,@posA2 int,@posA3 int        
Declare @orden varchar(max),        
        @detalle varchar(max),        
        @Guia varchar(max)                   
Set @posA1 = CharIndex('[',@ListaOrden,0)        
Set @posA2 = CharIndex('[',@ListaOrden,@posA1+1)        
Set @posA3 =Len(@ListaOrden)+1
      
Set @orden = SUBSTRING(@ListaOrden,1,@posA1-1)        
Set @detalle = SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)        
Set @Guia=SUBSTRING(@ListaOrden,@posA2+1,@posA3-@posA2-1)
    
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,        
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,        
        @pos9 int,@pos10 int,@pos11 int
               
Declare @GuiaId numeric(38),@GuiaConcepto varchar(40),        
  @GuiaMotivo varchar(80),@AlmacenId numeric(20),        
  @GuiaObservacion varchar(max),        
  @GuiaResponsable varchar(80),@GuiaUsuario varchar(80),        
  @UsuarioId int,@RazonSocial varchar(300),        
  @GuiaDoc varchar(40),@GuiaDocNumero varchar(80) 
       
Set @pos1 = CharIndex('|',@orden,0)        
Set @pos2 = CharIndex('|',@orden,@pos1+1)        
Set @pos3 = CharIndex('|',@orden,@pos2+1)        
Set @pos4 = CharIndex('|',@orden,@pos3+1)        
Set @pos5 = CharIndex('|',@orden,@pos4+1)        
Set @pos6= CharIndex('|',@orden,@pos5+1)        
Set @pos7 = CharIndex('|',@orden,@pos6+1)        
Set @pos8 = CharIndex('|',@orden,@pos7+1)        
Set @pos9 = CharIndex('|',@orden,@pos8+1)        
Set @pos10 = CharIndex('|',@orden,@pos9+1)        
Set @pos11= Len(@orden)+1        
Set @GuiaId=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))        
Set @GuiaConcepto=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)        
Set @GuiaMotivo=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)        
Set @AlmacenId=convert(numeric(20),SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1))        
Set @GuiaObservacion=SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1)        
Set @GuiaResponsable=SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1)        
Set @GuiaUsuario=SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1)        
Set @UsuarioId=convert(int,SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))        
Set @RazonSocial=SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1)        
Set @GuiaDoc=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)        
Set @GuiaDocNumero=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)        
Begin Transaction    
       
insert into GuiaIngreso values(@GuiaConcepto,@GuiaMotivo,GETDATE(),@AlmacenId,        
@GuiaObservacion,@GuiaUsuario,@RazonSocial,        
@GuiaDoc,@GuiaDocNumero,'EMITIDO')        
Set @GuiaId= @@identity    
       
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')         
Open Tabla        
Declare @Columna varchar(max),    
  @IdProducto numeric(20),        
  @Cantidad decimal(18,2),    
  @UniMedida varchar(40),         
  @Descripcion varchar(max),        
  @ValorUM decimal(18,4),        
  @IniciaStock decimal(18,2),        
  @StockFinal decimal(18,4),        
  @CantValor  decimal(18,4),    
  @PrecioCosto decimal(18,4)        
       
Declare @p1 int,@p2 int,        
        @p3 int,@p4 int,        
        @p5 int        
Fetch Next From Tabla INTO @Columna        
 While @@FETCH_STATUS = 0        
 Begin        
Set @p1 = CharIndex('|',@Columna,0)        
Set @p2 = CharIndex('|',@Columna,@p1+1)        
Set @p3 = CharIndex('|',@Columna,@p2+1)        
Set @p4 = CharIndex('|',@Columna,@p3+1)           
Set @p5= Len(@Columna)+1        
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))        
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))        
Set @UniMedida=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))        
Set @Descripcion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))        
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))        
    
insert into DetalleIngreso        
values(@GuiaId,@IdProducto,@Cantidad,@UniMedida,@Descripcion,@ValorUM)        
    
set @IniciaStock=(select top 1 p.ProductoCantidad from producto p(nolock)    
where p.IdProducto=@IdProducto)        
set @CantValor=(@Cantidad*@ValorUM)    
    
set @PrecioCosto=(select top 1 p.ProductoCosto from producto p(nolock)    
where p.IdProducto=@IdProducto)        
    
set @StockFinal=@IniciaStock+@CantValor    
     
insert into Kardex values(@IdProducto,GETDATE(),@GuiaMotivo,convert(varchar,@GuiaId),@IniciaStock,        
@CantValor,0,@PrecioCosto,@StockFinal,@GuiaConcepto,@GuiaUsuario)            
       
update Producto      
set ProductoCantidad=@StockFinal        
where IdProducto=@IdProducto     
       
Fetch Next From Tabla INTO @Columna        
end        
 Close Tabla;        
 Deallocate Tabla;        
 delete from TemporalING        
 where UsuarioId=@UsuarioId and Concepto=SUBSTRING(@GuiaConcepto,1,1)  
 --Commit Transaction;        
 --select @GuiaId        
if(len(@Guia)>0)        
begin        
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')         
Open TablaB        
Declare @ColumnaB varchar(max)      
Declare @g1 int,@g2 int,      
        @g3 int,@g4 int,@g5 int      
      
Declare @CantidadA decimal(18,2),       
        @IdProductoU numeric(20),                       
        @CantidadU decimal(18,2),                          
        @UmU varchar(40),                                                         
        @ValorUMU decimal(18,4)      
      
Declare @IniciaStockB decimal(18,2),      
        @StockFinalB decimal(18,2)      
                
Fetch Next From TablaB INTO @ColumnaB        
 While @@FETCH_STATUS = 0        
 Begin        
Set @g1 = CharIndex('|',@ColumnaB,0)                         
Set @g2 = CharIndex('|',@ColumnaB,@g1+1)                          
Set @g3 = CharIndex('|',@ColumnaB,@g2+1)                          
Set @g4 = CharIndex('|',@ColumnaB,@g3+1)                          
Set @g5=Len(@ColumnaB)+1         
       
set @CantidadA=Convert(decimal(18,2),SUBSTRING(@ColumnaB,1,@g1-1))      
Set @IdProductoU=Convert(numeric(20),SUBSTRING(@ColumnaB,@g1+1,@g2-(@g1+1)))      
Set @CantidadU=Convert(decimal(18,2),SUBSTRING(@ColumnaB,@g2+1,@g3-(@g2+1)))        
Set @UmU=SUBSTRING(@ColumnaB,@g3+1,@g4-(@g3+1))        
Set @ValorUMU=Convert(decimal(18,4),SUBSTRING(@ColumnaB,@g4+1,@g5-(@g4+1)))            
      
 Declare @CantidadSalB decimal(18,2)       
      
 set @CantidadSalB=(@CantidadA * @CantidadU)* @ValorUMU                  
                      
 set @IniciaStockB=(select top 1 p.ProductoCantidad       
 from Producto p where p.IdProducto=@IdProductoU)    
 
 set @StockFinalB=@IniciaStockB + @CantidadSalB                                        
      
 insert into Kardex values(@IdProductoU,GETDATE(),@GuiaMotivo,convert(varchar,@GuiaId),@IniciaStockB,                            
 @CantidadSalB,0,0,@StockFinalB,'INGRESO',@GuiaUsuario)     
                                             
 update producto                           
 set  ProductoCantidad =ProductoCantidad + @CantidadSalB                         
 where IDProducto=@IdProductoU     

Fetch Next From TablaB INTO @ColumnaB        
end        
    Close TablaB;        
    Deallocate TablaB;        
    Commit Transaction;        
    select convert(varchar,@GuiaId) 
end        
else        
begin        
    Commit Transaction;        
    select convert(varchar,@GuiaId) 
end    
                    
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarGuiaStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspInsertarGuiaStock]    
@ListaOrden varchar(Max)          
as          
begin                
Declare @posA1 int,@posA2 int          
Declare @orden varchar(max),          
        @detalle varchar(max)                  
Set @posA1 = CharIndex('[',@ListaOrden,0)         
Set @posA2 =Len(@ListaOrden)+1  
        
Set @orden = SUBSTRING(@ListaOrden,1,@posA1-1)          
Set @detalle = SUBSTRING(@ListaOrden,@posA1+1,@posA2-@posA1-1)
   
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,    
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,    
        @pos9 int,@pos10 int,@pos11 int,@pos12 int   
Declare @GuiaId numeric(38),@GuiaConcepto varchar(40),    
  @GuiaMotivo varchar(80),@AlmacenId numeric(20),    
  @GuiaObservacion varchar(max),
  @GuiaResponsable varchar(80),@GuiaUsuario varchar(80),    
  @UsuarioId int,@NotaId varchar(80),@RazonSocial varchar(300),    
  @GuiaDoc varchar(40),@GuiaDocNumero varchar(80)  
Set @pos1 = CharIndex('|',@orden,0)    
Set @pos2 = CharIndex('|',@orden,@pos1+1)    
Set @pos3 = CharIndex('|',@orden,@pos2+1)    
Set @pos4 = CharIndex('|',@orden,@pos3+1)    
Set @pos5 = CharIndex('|',@orden,@pos4+1)    
Set @pos6= CharIndex('|',@orden,@pos5+1)    
Set @pos7 = CharIndex('|',@orden,@pos6+1)    
Set @pos8 = CharIndex('|',@orden,@pos7+1)    
Set @pos9 = CharIndex('|',@orden,@pos8+1)    
Set @pos10 = CharIndex('|',@orden,@pos9+1)    
Set @pos11= CharIndex('|',@orden,@pos10+1)    
Set @pos12= Len(@orden)+1    
Set @GuiaId=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))    
Set @GuiaConcepto=SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1)    
Set @GuiaMotivo=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)    
Set @AlmacenId=convert(numeric(20),SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1))    
Set @GuiaObservacion=SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1)    
Set @GuiaResponsable=SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1)    
Set @GuiaUsuario=SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1)    
Set @UsuarioId=convert(int,SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))    
Set @NotaId=SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1)    
Set @RazonSocial=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)    
Set @GuiaDoc=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)    
Set @GuiaDocNumero=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)    
Begin Transaction    
insert into GuiaAlmacen values(@GuiaConcepto,@GuiaMotivo,GETDATE(),@AlmacenId,    
@GuiaObservacion,@GuiaResponsable,@GuiaUsuario,'E',@NotaId,@RazonSocial,    
@GuiaDoc,@GuiaDocNumero)    
Set @GuiaId= @@identity    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
Declare @Columna varchar(max),    
  @IdStock numeric(38),    
  @Cantidad decimal(18,2),    
  @Descripcion varchar(max),    
  @UniMedida varchar(40),    
  @ValorUM decimal(18,4),    
  @IniciaStock decimal(18,2),    
  @StockFinal decimal(18,4),    
  @CantValor  decimal(18,4),    
  @IdProducto numeric(20)    
Declare @p1 int,@p2 int,    
        @p3 int,@p4 int,    
        @p5 int,@p6 int    
Fetch Next From Tabla INTO @Columna    
 While @@FETCH_STATUS = 0    
 Begin    
Set @p1 = CharIndex('|',@Columna,0)    
Set @p2 = CharIndex('|',@Columna,@p1+1)    
Set @p3 = CharIndex('|',@Columna,@p2+1)    
Set @p4 = CharIndex('|',@Columna,@p3+1)    
Set @p5= CharIndex('|',@Columna,@p4+1)    
Set @p6= Len(@Columna)+1    
Set @IdStock=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))    
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))    
Set @UniMedida=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))    
Set @Descripcion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))    
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))    
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))    
insert into DetalleStock    
values(@GuiaId,@IdStock,@Cantidad,@UniMedida,@Descripcion,@ValorUM,@NotaId,@IdProducto,'E')    
set @IniciaStock=(select top 1 Cantidad from Stock(nolock) where IdStock=@IdStock)    
set @CantValor=(@Cantidad*@ValorUM)    
if(@GuiaConcepto='INGRESO')    
BEGIN     
set @StockFinal=@IniciaStock+@CantValor    
insert into KardexAlmacen values(@IdStock,GETDATE(),@GuiaMotivo,@GuiaId,@IniciaStock,    
@CantValor,0,@StockFinal,@GuiaConcepto,@GuiaUsuario)    
END    
else    
begin    
set @StockFinal=@IniciaStock-@CantValor    
insert into KardexAlmacen values(@IdStock,GETDATE(),@GuiaMotivo,@GuiaId,@IniciaStock,    
0,@CantValor,@StockFinal,@GuiaConcepto,@GuiaUsuario)    
end    
update Stock    
set Cantidad=@StockFinal    
where IdStock=@IdStock    
Fetch Next From Tabla INTO @Columna    
end    
 Close Tabla;    
 Deallocate Tabla;    
 delete from TemporalAlmacen    
 where UsuarioId=@UsuarioId and Concepto=SUBSTRING(@GuiaConcepto,1,1)    
 Commit Transaction;    
 select convert(varchar,@GuiaId)        
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarHuella]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertarHuella]  
@PersonalId numeric(20),  
@PARAM_HUELLA image  
as  
begin  
UPDATE PERSONAL   
SET HUELLA=@PARAM_HUELLA   
WHERE PersonalId=@PersonalId  
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarNC]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,
        @pos13 int,@pos14 int,@pos15 int,@pos16 int,
        @pos17 int,@pos18 int,@pos19 int,@pos20 int,
        @pos21 int,@pos22 int,@pos23 int,@pos24 int
 Declare @CompaniaId int,@NotaId numeric(38),@DocuDocumento varchar(60),
         @DocuNumero varchar(60),@ClienteId numeric(20),@DocuEmision date,
         @DocuSubTotal decimal(18,2),@DocuIgv decimal(18,2),@DocuTotal decimal(18,2),
         @DocuUsuario varchar(60),@DocuSerie char(4),@TipoCodigo char(20),
         @DocuAdicional decimal(18,2),@DocuAsociado varchar(80),@DocuConcepto varchar(80),
         @DocuHASH varchar(250),@EstadoSunat varchar(80),@Letras varchar(60),@NroReferencia varchar(80),
         @DocuId numeric(38),@KardexDocu varchar(80),@ICBPER decimal(18,2),
         @CodigoSunat VARCHAR(80),@MensajeSunat varchar(max),
         @DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3 = CharIndex('|',@orden,@pos2+1)
Set @pos4 = CharIndex('|',@orden,@pos3+1)
Set @pos5 = CharIndex('|',@orden,@pos4+1)
Set @pos6= CharIndex('|',@orden,@pos5+1)
Set @pos7 = CharIndex('|',@orden,@pos6+1)
Set @pos8 = CharIndex('|',@orden,@pos7+1)
Set @pos9 = CharIndex('|',@orden,@pos8+1)
Set @pos10= CharIndex('|',@orden,@pos9+1)
Set @pos11= CharIndex('|',@orden,@pos10+1)
Set @pos12= CharIndex('|',@orden,@pos11+1)
Set @pos13= CharIndex('|',@orden,@pos12+1)
Set @pos14= CharIndex('|',@orden,@pos13+1)
Set @pos15= CharIndex('|',@orden,@pos14+1)
Set @pos16= CharIndex('|',@orden,@pos15+1)
Set @pos17= CharIndex('|',@orden,@pos16+1)
Set @pos18= CharIndex('|',@orden,@pos17+1)
Set @pos19= CharIndex('|',@orden,@pos18+1)
Set @pos20= CharIndex('|',@orden,@pos19+1)
Set @pos21= CharIndex('|',@orden,@pos20+1)
Set @pos22= CharIndex('|',@orden,@pos21+1)
Set @pos23= CharIndex('|',@orden,@pos22+1)
Set @pos24= Len(@orden)+1
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@pos1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))
Set @DocuDocumento=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set @DocuNumero=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1))
Set @DocuEmision=convert(date,SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1))
Set @DocuSubTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1))
Set @DocuIgv=convert(decimal(18,2),SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))
Set @DocuTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1))
Set @DocuUsuario=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)
Set @DocuSerie=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)
Set @TipoCodigo=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1))
set @DocuAsociado=SUBSTRING(@orden,@pos13+1,@pos14-@pos13-1)
set @DocuConcepto=SUBSTRING(@orden,@pos14+1,@pos15-@pos14-1)
set @DocuHASH=SUBSTRING(@orden,@pos15+1,@pos16-@pos15-1)
set @EstadoSunat=SUBSTRING(@orden,@pos16+1,@pos17-@pos16-1)
set @Letras=SUBSTRING(@orden,@pos17+1,@pos18-@pos17-1)
set @NroReferencia=SUBSTRING(@orden,@pos18+1,@pos19-@pos18-1)
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@pos19+1,@pos20-@pos19-1))
set @CodigoSunat=SUBSTRING(@orden,@pos20+1,@pos21-@pos20-1)
set @MensajeSunat=SUBSTRING(@orden,@pos21+1,@pos22-@pos21-1)
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@pos22+1,@pos23-@pos22-1))
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@pos23+1,@pos24-@pos23-1))
Begin Transaction
insert into DocumentoVenta values(@CompaniaId,@NotaId,@DocuDocumento,@DocuNumero,
@ClienteId,GETDATE(),@DocuEmision,'ALCONTADO',1,GETDATE(),
@DocuEmision,@Letras,@DocuSubTotal,@DocuIgv,@DocuTotal,0,
@DocuUsuario,'EMITIDO',@DocuSerie,@TipoCodigo,@DocuAdicional,@DocuAsociado,
@DocuConcepto,@NroReferencia,@DocuHASH,@EstadoSunat,@ICBPER,@CodigoSunat,@MensajeSunat,
@DocuGravada,@DocuDescuento,'')
Set @DocuId= @@identity
Update DocumentoVenta
set DocuAsociado=convert(varchar,@DocuId)
where DocuId=@DocuAsociado
update NotaPedido
set NotaEstado='ANULADO'
where NotaId=@NotaId
   Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@Importe decimal(18,2),
		@DetalleNotaId numeric(38),
		@UM varchar(80),
		@ValorUM decimal(18,4),
		@StockInicial decimal(18,2),
		@StockFinal decimal(18,2),@CantidadIng decimal(18,2)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,1,@p1-1))
Set @UM=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
insert into DetalleDocumento 
values(@DocuId,@IdProducto,@Cantidad,@Precio,@Importe,@DetalleNotaId,@UM,@ValorUM)
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	SELECT 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarNotaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarNotaB]      
@ListaOrden varchar(Max)      
as      
begin      
Declare @pos1 int,@pos2 int,@pos3 int      
Declare @orden varchar(max),      
        @detalle varchar(max),      
        @Guia varchar(max)      
Set @pos1 = CharIndex('[',@ListaOrden,0)      
Set @pos2 = CharIndex('[',@ListaOrden,@pos1+1)      
Set @pos3 =Len(@ListaOrden)+1      
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)      
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)      
Set @Guia=SUBSTRING(@ListaOrden,@pos2+1,@pos3-@pos2-1)      
Declare @c1 int,@c2 int,@c3 int,@c4 int,      
        @c5 int,@c6 int,@c7 int,@c8 int,      
        @c9 int,@c10 int,@c11 int,@c12 int,      
        @c13 int,@c14 int,@c15 int,@c16 int,      
        @c17 int,@c18 int,@c19 int,@c20 int,      
        @c21 int,@c22 int,@c23 int,@c24 int,      
        @c25 int,@c26 int,@c27 int,@c28 int,      
        @c29 int,@c30 int,@c31 int,@c32 int,      
        @c33 int      
Declare       
  @NotaDocu varchar(60),@ClienteId numeric(20),      
  @NotaUsuario varchar(60),@NotaFormaPago varchar(60),      
  @NotaCondicion varchar(60),@NotaDireccion varchar(max),      
  @NotaTelefono varchar(60),@NotaSubtotal decimal (18,2),      
  @NotaMovilidad decimal(18,2),@NotaDescuento decimal (18, 2),      
  @NotaTotal decimal (18,2),@NotaAcuenta decimal(18,2),      
  @NotaSaldo decimal(18,2),@NotaAdicional decimal(18,2),      
  @NotaTarjeta decimal(18,2),@NotaPagar decimal(18,2),      
  @NotaEstado varchar(60),@CompaniaId int,      
  @NotaEntrega varchar(40),@NotaConcepto varchar(60),      
  @Serie char(4),@Numero varchar(60),      
  @NotaGanancia decimal(18,2),@Letra varchar(max),      
  @DocuAdicional decimal(18,2),@DocuHash varchar(250),      
  @EstadoSunat varchar(80),@DocuSubtotal decimal(18,2),      
  @DocuIGV decimal(18,2),@UsuarioId int,@ICBPER decimal(18,2),      
  @DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)      
Set @c1 = CharIndex('|',@orden,0)      
Set @c2 = CharIndex('|',@orden,@c1+1)      
Set @c3 = CharIndex('|',@orden,@c2+1)      
Set @c4 = CharIndex('|',@orden,@c3+1)      
Set @c5 = CharIndex('|',@orden,@c4+1)      
Set @c6= CharIndex('|',@orden,@c5+1)      
Set @c7 = CharIndex('|',@orden,@c6+1)      
Set @c8 = CharIndex('|',@orden,@c7+1)      
Set @c9 = CharIndex('|',@orden,@c8+1)      
Set @c10= CharIndex('|',@orden,@c9+1)      
Set @c11= CharIndex('|',@orden,@c10+1)      
Set @c12= CharIndex('|',@orden,@c11+1)      
Set @c13= CharIndex('|',@orden,@c12+1)      
Set @c14= CharIndex('|',@orden,@c13+1)      
Set @c15= CharIndex('|',@orden,@c14+1)      
Set @c16= CharIndex('|',@orden,@c15+1)      
Set @c17= CharIndex('|',@orden,@c16+1)      
Set @c18 = CharIndex('|',@orden,@c17+1)      
Set @c19 = CharIndex('|',@orden,@c18+1)      
Set @c20= CharIndex('|',@orden,@c19+1)      
Set @c21= CharIndex('|',@orden,@c20+1)      
Set @c22= CharIndex('|',@orden,@c21+1)      
Set @c23= CharIndex('|',@orden,@c22+1)      
Set @c24= CharIndex('|',@orden,@c23+1)      
Set @c25= CharIndex('|',@orden,@c24+1)      
Set @c26= CharIndex('|',@orden,@c25+1)      
Set @c27= CharIndex('|',@orden,@c26+1)      
Set @c28= CharIndex('|',@orden,@c27+1)      
Set @c29= CharIndex('|',@orden,@c28+1)      
Set @c30= CharIndex('|',@orden,@c29+1)      
Set @c31= CharIndex('|',@orden,@c30+1)      
Set @c32= CharIndex('|',@orden,@c31+1)      
Set @c33= Len(@orden)+1      
set @NotaDocu=SUBSTRING(@orden,1,@c1-1)      
set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@c1+1,@c2-@c1-1))      
set @NotaUsuario=SUBSTRING(@orden,@c2+1,@c3-@c2-1)      
set @NotaFormaPago=SUBSTRING(@orden,@c3+1,@c4-@c3-1)      
set @NotaCondicion=SUBSTRING(@orden,@c4+1,@c5-@c4-1)      
set @NotaDireccion=SUBSTRING(@orden,@c5+1,@c6-@c5-1)      
set @NotaTelefono=SUBSTRING(@orden,@c6+1,@c7-@c6-1)      
set @NotaSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c7+1,@c8-@c7-1))      
set @NotaMovilidad=convert(decimal(18,2),SUBSTRING(@orden,@c8+1,@c9-@c8-1))      
set @NotaDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c9+1,@c10-@c9-1))      
set @NotaTotal=convert(decimal(18,2),SUBSTRING(@orden,@c10+1,@c11-@c10-1))      
set @NotaAcuenta=convert(decimal(18,2),SUBSTRING(@orden,@c11+1,@c12-@c11-1))      
set @NotaSaldo=convert(decimal(18,2),SUBSTRING(@orden,@c12+1,@c13-@c12-1))      
set @NotaAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c13+1,@c14-@c13-1))      
set @NotaTarjeta=convert(decimal(18,2),SUBSTRING(@orden,@c14+1,@c15-@c14-1))      
set @NotaPagar=convert(decimal(18,2),SUBSTRING(@orden,@c15+1,@c16-@c15-1))      
set @NotaEstado=SUBSTRING(@orden,@c16+1,@c17-@c16-1)      
set @CompaniaId=convert(int,SUBSTRING(@orden,@c17+1,@c18-@c17-1))      
set @NotaEntrega=SUBSTRING(@orden,@c18+1,@c19-@c18-1)      
set @NotaConcepto=SUBSTRING(@orden,@c19+1,@c20-@c19-1)      
set @Serie=convert(char(4),SUBSTRING(@orden,@c20+1,@c21-@c20-1))      
set @Numero=SUBSTRING(@orden,@c21+1,@c22-@c21-1)      
set @NotaGanancia=convert(decimal(18,2),SUBSTRING(@orden,@c22+1,@c23-@c22-1))      
set @Letra=SUBSTRING(@orden,@c23+1,@c24-@c23-1)      
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c24+1,@c25-@c24-1))      
set @DocuHash=SUBSTRING(@orden,@c25+1,@c26-@c25-1)      
set @EstadoSunat=SUBSTRING(@orden,@c26+1,@c27-@c26-1)      
set @DocuSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c27+1,@c28-@c27-1))      
set @DocuIGV=convert(decimal(18,2),SUBSTRING(@orden,@c28+1,@c29-@c28-1))      
set @UsuarioId=convert(int,SUBSTRING(@orden,@c29+1,@c30-@c29-1))      
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@c30+1,@c31-@c30-1))      
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@c31+1,@c32-@c31-1))      
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c32+1,@c33-@c32-1))      
declare @NotaId numeric(38),      
        @DocuId numeric(38)=0      
Begin Transaction  
    
update Cliente      
set ClienteDespacho=@NotaDireccion,ClienteTelefono=@NotaTelefono      
where ClienteId=@ClienteId      
    
delete from TemporalVenta       
where UsuarioID=@UsuarioId    
    
delete from TemporalAlmacen      
where UsuarioId=@UsuarioId and Concepto='S'     
    
declare @cod varchar(13)      
SET @cod=(select TOP 1 dbo.genenerarNroFactura(@Serie,@CompaniaId,@NotaDocu) AS ID FROM DocumentoVenta)      
insert into NotaPedido values(@NotaDocu,@ClienteId,GETDATE(),@NotaUsuario,      
@NotaFormaPago,@NotaCondicion,1,GETDATE(),@NotaDireccion,@NotaTelefono,      
@NotaSubtotal,@NotaMovilidad,@NotaDescuento,@NotaTotal,@NotaAcuenta,@NotaSaldo,      
@NotaAdicional,@NotaTarjeta,@NotaPagar,@NotaEstado,@CompaniaId,      
@NotaEntrega,'','',@NotaConcepto,@Serie,@cod,@NotaGanancia,@ICBPER,'')      
set @NotaId=(select @@IDENTITY)      
if @NotaDocu='BOLETA'      
begin      
set @EstadoSunat='PENDIENTE'      
insert into DocumentoVenta values      
(@CompaniaId,@NotaId,'BOLETA',@cod,@ClienteId,GETDATE(),      
GETDATE(),@NotaCondicion,1,GETDATE(),cast(convert(date,GETDATE()) as varchar(10)),@Letra,@DocuSubtotal,      
@DocuIGV,@NotaPagar,0,@NotaUsuario,'EMITIDO',@Serie,'03',@DocuAdicional,'','VENTA','',@DocuHash,@EstadoSunat,      
@ICBPER,'','',@DocuGravada,@DocuDescuento,'')      
set @DocuId=(select @@IDENTITY)      
end      
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')       
Open Tabla      
Declare @Columna varchar(max),      
  @IdProducto numeric(20),      
  @DetalleCantidad decimal(18,2),      
  @DetalleUm varchar(40),      
  @Descripcion varchar(140),      
  @DetalleCosto decimal(18,4),       
  @DetallePrecio decimal(18,2),      
  @DetalleImporte decimal(18,2),      
  @DetalleEstado varchar(60),
  @Estado nvarchar(1),     
  @ValorUM decimal(18,4),@CantidadSaldo decimal(18,2)      
Declare @p1 int,@p2 int,@p3 int,@p4 int,      
        @p5 int,@p6 int,@p7 int,@p8 int,      
        @p9 int,@p10 int     
Fetch Next From Tabla INTO @Columna      
 While @@FETCH_STATUS = 0      
 Begin      
Set @p1 = CharIndex('|',@Columna,0)      
Set @p2 = CharIndex('|',@Columna,@p1+1)      
Set @p3 = CharIndex('|',@Columna,@p2+1)      
Set @p4 = CharIndex('|',@Columna,@p3+1)      
Set @p5 = CharIndex('|',@Columna,@p4+1)      
Set @p6= CharIndex('|',@Columna,@p5+1)      
Set @p7= CharIndex('|',@Columna,@p6+1)      
Set @p8 = CharIndex('|',@Columna,@p7+1)
Set @p9= CharIndex('|',@Columna,@p8+1)         
Set @p10=Len(@Columna)+1      
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))      
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))      
Set @DetalleUm=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))      
Set @Descripcion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))      
Set @DetalleCosto=convert(decimal(18,4),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))      
Set @DetallePrecio=convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))      
Set @DetalleImporte=convert(decimal(18,2),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))      
Set @DetalleEstado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))          
set @ValorUM=convert(decimal(18,4),SUBSTRING(@Columna,@p8+1,@p9-(@p8+1)))
Set @Estado=SUBSTRING(@Columna,@p9+1,@p10-(@p9+1))

if(@NotaEntrega='INMEDIATA')Set @CantidadSaldo=0      
else Set @CantidadSaldo=@DetalleCantidad  
      
insert into DetallePedido values(@NotaId,@IdProducto,@DetalleCantidad,      
@DetalleUm,@Descripcion,@DetalleCosto, @DetallePrecio,      
@DetalleImporte,@DetalleEstado,@CantidadSaldo,@ValorUM,@Estado)
      
if(@DocuId<>0)      
begin      
	insert into DetalleDocumento values      
	(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,@DetalleImporte,      
	@NotaId,@DetalleUm,@ValorUM)      
end      
Fetch Next From Tabla INTO @Columna      
end      
 Close Tabla;      
 Deallocate Tabla;      
if(len(@Guia)>0)      
begin      
Declare TablaB Cursor For Select * From fnSplitString(@Guia,';')       
Open TablaB      
Declare @ColumnaB varchar(max),      
        @GuiaId numeric(38)      
Declare @g1 int      
Fetch Next From TablaB INTO @ColumnaB      
 While @@FETCH_STATUS = 0      
 Begin      
Set @g1=Len(@ColumnaB)+1      
set @GuiaId=Convert(numeric(20),SUBSTRING(@ColumnaB,1,@g1-1))      
insert into GuiaRelacion values(@GuiaId,@NotaId)      
update GuiaRemision      
set GuiaEstado='CANJEADO'      
where GuiaId=@GuiaId      
Fetch Next From TablaB INTO @ColumnaB      
end      
  Close TablaB;      
  Deallocate TablaB;  
  Commit Transaction;      
  select convert(varchar,@NotaId)+'¬'+@cod      
end      
else      
begin   
    Commit Transaction;      
    select convert(varchar,@NotaId)+'¬'+@cod      
end      
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarNotaB_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspinsertarNotaB_web]
    @ListaOrden varchar(Max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspinsertarNotaB_web] @ListaOrden = @ListaOrden;
END
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarRB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarRB]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @c1 int,@c2 int,@c3 int,@c4 int,
        @c5 int,@c6 int,@c7 int,@c8 int,
        @c9 int,@c10 int,@c11 int,@c12 int,
        @c13 int,@c14 INT
Declare @CompaniaId int,@ResumenSerie varchar(250),
@Secuencia numeric(38),@FechaReferencia date,
@SubTotal decimal(18,2),@IGV decimal(18,2),
@Total decimal(18,2),@ResumenTiket varchar(250),
@CodigoSunat  varchar(80),@HASHCDR   varchar(max),
@Usuario varchar(80),@Status int,@Estado char(1),
@RangoNumero varchar(80),@ICBPER decimal(18,2)
Set @c1 = CharIndex('|',@orden,0)
Set @c2 = CharIndex('|',@orden,@c1+1)
Set @c3 = CharIndex('|',@orden,@c2+1)
Set @c4 = CharIndex('|',@orden,@c3+1)
Set @c5 = CharIndex('|',@orden,@c4+1)
Set @c6= CharIndex('|',@orden,@c5+1)
Set @c7 = CharIndex('|',@orden,@c6+1)
Set @c8 = CharIndex('|',@orden,@c7+1)
Set @c9 = CharIndex('|',@orden,@c8+1)
Set @c10= CharIndex('|',@orden,@c9+1)
Set @c11= CharIndex('|',@orden,@c10+1)
Set @c12= CharIndex('|',@orden,@c11+1)
Set @c13= CharIndex('|',@orden,@c12+1)
Set @c14= Len(@orden)+1
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@c1-1))
Set @ResumenSerie=SUBSTRING(@orden,@c1+1,@c2-@c1-1)
Set @Secuencia=convert(int,SUBSTRING(@orden,@c2+1,@c3-@c2-1))
set @FechaReferencia=convert(date,SUBSTRING(@orden,@c3+1,@c4-@c3-1))
set @SubTotal=convert(decimal(18,2),SUBSTRING(@orden,@c4+1,@c5-@c4-1))
set @IGV=convert(decimal(18,2),SUBSTRING(@orden,@c5+1,@c6-@c5-1))
set @Total=convert(decimal(18,2),SUBSTRING(@orden,@c6+1,@c7-@c6-1))
set @ResumenTiket=SUBSTRING(@orden,@c7+1,@c8-@c7-1)
set @CodigoSunat=SUBSTRING(@orden,@c8+1,@c9-@c8-1)
set @HASHCDR=SUBSTRING(@orden,@c9+1,@c10-@c9-1)
set @Usuario=SUBSTRING(@orden,@c10+1,@c11-@c10-1)
set @Status=SUBSTRING(@orden,@c11+1,@c12-@c11-1)
set @RangoNumero=SUBSTRING(@orden,@c12+1,@c13-@c12-1)
set @ICBPER=SUBSTRING(@orden,@c13+1,@c14-@c13-1)
if(@Status=3)
begin
set @SubTotal=0-@SubTotal
set @IGV=0-@IGV
set @ICBPER=0-@ICBPER
set @Total=0-@Total
set @Estado='B'--BAJA
end
else
begin
set @Estado='E'--ENVIADO
end
Begin Transaction
insert into ResumenBoletas values
(@CompaniaId,@ResumenSerie,@Secuencia,@FechaReferencia,Getdate(),
@SubTotal,@IGV,@Total,@ResumenTiket,@CodigoSunat,@HASHCDR,'',@Usuario,
@Estado,@RangoNumero,@ICBPER)
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @DocuId numeric(38)
Declare @p1 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = Len(@Columna)+1
Set @DocuId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
if(@Status=1)--Declarar 3 Anular
begin
update DocumentoVenta
set DocuHash=@HASHCDR,EstadoSunat='ENVIADO'
where DocuId=@DocuId
end
else
begin
update DocumentoVenta
set DocuHash=@HASHCDR,DocuEstado='BAJA',EstadoSunat='ENVIADO',
DocuSubTotal=0,DocuIgv=0,DocuTotal=0,ICBPER=0
where DocuId=@DocuId
end
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
SELECT
isnull((select STUFF ((select '¬'+convert(varchar,r.ResumenId)+'|'+convert(varchar,r.CompaniaId)+'|'+
(IsNull(convert(varchar,r.FechaReferencia,103),''))+'|'+
(IsNull(convert(varchar,r.FechaEnvio,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,r.FechaEnvio,114),1,8),''))+'|'+
r.ResumenSerie+'-'+convert(varchar,r.Secuencia)+'|'+r.RangoNumero+'|'+
CONVERT(VarChar(50),cast(r.SubTotal as money ), 1)+'|'+
CONVERT(VarChar(50),cast( r.IGV as money ), 1)+'|'+
CONVERT(VarChar(50),cast( r.ICBPER as money ), 1)+'|'+
CONVERT(VarChar(50),cast(r.Total as money ), 1)+'|'+
r.ResumenTiket+'|'+r.CodigoSunat+'|'+r.HASHCDR+'|'+r.MensajeSunat+'|'+
r.Usuario+'|'+c.CompaniaRUC+'|'+
c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+r.Estado+'||'+c.TokenApi+'|'+ClienIdToken
FROM ResumenBoletas r
inner join Compania c
on c.CompaniaId=r.CompaniaId
where Month(r.FechaReferencia)=MONTH(Getdate()) and YEAR(r.FechaReferencia)=year(Getdate())
order by r.CompaniaId,r.FechaEnvio asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaSeries]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaSeries]
@detalle varchar(max)
as
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
		Declare @Columna varchar(max)
Declare @p1 int,@p2 int,
        @p3 int,@p4 int,@p5 int
Declare @UsuarioID int,@UsuarioSerie varchar(4),
        @EnviaBoleta Bit,@EnviarFactura Bit,
        @Admin Bit,@B int,@F int,@A int
	Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)    
Set @p5 = Len(@Columna)+1 
Set @UsuarioID=convert(int,SUBSTRING(@Columna,1,@p1-1))
Set @UsuarioSerie=SUBSTRING(@Columna,@p1+1,@p2-@p1-1) 
Set @EnviaBoleta=SUBSTRING(@Columna,@p2+1,@p3-@p2-1)
Set @EnviarFactura=SUBSTRING(@Columna,@p3+1,@p4-@p3-1)
Set @Admin=SUBSTRING(@Columna,@p4+1,@p5-@p4-1)
if(@EnviaBoleta='False')set @B=0
else set @B=1
if(@EnviarFactura='False')set @f=0
else set @f=1
if(@Admin='False')set @A=0
else set @A=1
update Usuarios
set UsuarioSerie=@UsuarioSerie,EnviaBoleta=@B,EnviarFactura=@F,
Administrador=@A
where UsuarioID=@UsuarioID
Fetch Next From Tabla INTO @Columna
	end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaStockB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaStockB]  
@Data varchar(max)  
as  
begin  
Declare @IdStock numeric(38),  
  @Cantidad decimal(18,2),  
  @Descripcion varchar(max),  
  @UniMedida varchar(40),  
  @ValorUM decimal(18,4),  
  @NotaId varchar(80),  
  @IdProducto numeric(20),  
  @ESTADO NVARCHAR(1),  
  @Cliente varchar(300),  
  @Usuario varchar(80),  
  @GuiaId numeric(38)  
Declare @p1 int,@p2 int,@p3 int,  
        @p4 int,@p5 int,@p6 int,  
        @p7 int,@p8 int,@p9 int,  
        @p10 int      
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = CharIndex('|',@Data,@p3+1)  
Set @p5 = CharIndex('|',@Data,@p4+1)  
Set @p6 =CharIndex('|',@Data,@p5+1)  
Set @p7=CharIndex('|',@Data,@p6+1)  
Set @p8=CharIndex('|',@Data,@p7+1)  
Set @p9=CharIndex('|',@Data,@p8+1)  
Set @p10 = Len(@Data)+1  
Set @IdStock=Convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Data,@p1+1,@p2-(@p1+1)))  
Set @UniMedida=SUBSTRING(@Data,@p2+1,@p3-(@p2+1))  
Set @Descripcion=SUBSTRING(@Data,@p3+1,@p4-(@p3+1))  
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Data,@p4+1,@p5-(@p4+1)))  
set @NotaId=SUBSTRING(@Data,@p5+1,@p6-(@p5+1))  
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Data,@p6+1,@p7-(@p6+1)))  
set @ESTADO=SUBSTRING(@Data,@p7+1,@p8-(@p7+1))  
Set @Cliente=SUBSTRING(@Data,@p8+1,@p9-(@p8+1))  
set @Usuario=SUBSTRING(@Data,@p9+1,@p10-(@p9+1))  
set @GuiaId=isnull((select top 1 GuiaId from GuiaAlmacen where NotaId=@NotaId),0)  
if(@GuiaId=0)  
begin  
--Begin Transaction  
--insert into GuiaAlmacen values('SALIDA','SALIDA POR VENTA',GETDATE(),7,'',@Usuario,@Usuario,'E',@NotaId,@Cliente,'','','')  
--set @GuiaId=(select @@IDENTITY)  
--insert into DetalleStock  
--values(@GuiaId,@IdStock,@Cantidad,@UniMedida,@Descripcion,@ValorUM,@NotaId,@IdProducto,@ESTADO)  
--Commit Transaction;  
--select 'true'  
--end  
--else  
--begin  
--insert into DetalleStock  
--values(@GuiaId,@IdStock,@Cantidad,@UniMedida,@Descripcion,@ValorUM,@NotaId,@IdProducto,@ESTADO)  
select 'true'  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaTemporalAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaTemporalAlmacen]          
@Data varchar(max)          
as          
begin          
Declare @pos1 int,@pos2 int,          
        @pos3 int,@pos4 int,          
        @pos5 int,@pos6 int,          
        @pos7 int,@pos8 int,@pos9 int          
Declare @TemporalId numeric(38),@UsuarioId int,          
        @IdStok numeric(38),@Cantidad decimal(18,2),          
        @ValorUM decimal(18,4),@UniMedida varchar(80),          
        @Concepto  char(1),@IdProducto numeric(20),      
        @CantInicial decimal(18,2)          
Set @Data = LTRIM(RTrim(@Data))          
Set @pos1 = CharIndex('|',@Data,0)          
Set @pos2 = CharIndex('|',@Data,@pos1+1)          
Set @pos3 = CharIndex('|',@Data,@pos2+1)          
Set @pos4 = CharIndex('|',@Data,@pos3+1)          
Set @pos5 = CharIndex('|',@Data,@pos4+1)          
Set @pos6 =CharIndex('|',@Data,@pos5+1)          
Set @pos7=CharIndex('|',@Data,@pos6+1)          
Set @pos8=CharIndex('|',@Data,@pos7+1)       
Set @pos9= Len(@Data)+1        
        
Set @TemporalId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))          
Set @UsuarioId=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))          
Set @IdStok=convert(numeric(38),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))          
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))          
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))          
Set @UniMedida=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)          
Set @Concepto=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)          
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1))    
Set @CantInicial=convert(decimal(18,2),SUBSTRING(@Data,@pos8+1,@pos9-@pos8-1))         
         
if(@TemporalId='0')          
begin          
insert into TemporalAlmacen values(@UsuarioId,@IdStok,          
@Cantidad,@ValorUM,@UniMedida,@Concepto,@IdProducto,@CantInicial)          
end          
else          
begin          
update TemporalAlmacen          
set Cantidad=@Cantidad,ValorUM=@ValorUM,          
UniMedida=@UniMedida,Concepto=@Concepto--,IdProducto=@IdProducto          
where TemporalId=@TemporalId          
end          
select          
isnull((select STUFF ((select '¬'+          
convert(varchar,t.TemporalId)+'|'+convert(varchar,t.UsuarioId)+'|'+          
convert(varchar,t.IdStok)+'|'+CONVERT(VarChar(50),cast(t.Cantidad as money ), 1)+'|'+t.UniMedida+'|'+          
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar,t.ValorUM)+'|'+t.Concepto+'|'+      
convert(varchar,s.IdProducto)+'|'+CONVERT(varchar,t.CanInicial)+'|'+  
p.ProductoImagen          
from TemporalAlmacen t          
inner join Stock s          
on s.IdStock=t.IdStok          
inner join Producto p          
on p.IdProducto=s.IdProducto          
where t.UsuarioId=@UsuarioId and Concepto=@Concepto          
for xml path('')),1,1,'')),'~')          
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaTemporalING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaTemporalING]            
@Data varchar(max)            
as            
begin            
Declare @pos1 int,@pos2 int,            
        @pos3 int,@pos4 int,            
        @pos5 int,@pos6 int,            
        @pos7 int            
Declare @TemporalId numeric(38),@UsuarioId int,            
        @Cantidad decimal(18,2),@ValorUM decimal(18,4),  
        @UniMedida varchar(80),@Concepto char(1),  
        @IdProducto numeric(20)         
Set @Data = LTRIM(RTrim(@Data))            
Set @pos1 = CharIndex('|',@Data,0)            
Set @pos2 = CharIndex('|',@Data,@pos1+1)            
Set @pos3 = CharIndex('|',@Data,@pos2+1)            
Set @pos4 = CharIndex('|',@Data,@pos3+1)            
Set @pos5 = CharIndex('|',@Data,@pos4+1)            
Set @pos6 =CharIndex('|',@Data,@pos5+1)                
Set @pos7= Len(@Data)+1          
          
Set @TemporalId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))            
Set @UsuarioId=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))            
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))            
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))            
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))            
Set @UniMedida=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)            
Set @Concepto=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)         
           
if(@TemporalId='0')            
begin            
insert into TemporalING values(@UsuarioId,@IdProducto,            
@Cantidad,@ValorUM,@UniMedida,@Concepto)            
end            
else            
begin            
update TemporalING            
set Cantidad=@Cantidad,ValorUM=@ValorUM,            
UniMedida=@UniMedida,Concepto=@Concepto          
where TemporalId=@TemporalId            
end            
select            
isnull((select STUFF ((select '¬'+            
convert(varchar,t.TemporalId)+'|'+convert(varchar,t.UsuarioId)+'|'+            
convert(varchar,t.IdProducto)+'|'+CONVERT(VarChar(50),cast(t.Cantidad as money ), 1)+'|'+t.UniMedida+'|'+            
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar,t.ValorUM)+'|'+t.Concepto+'|'+      
p.ProductoImagen+'|'+p.ProductoObs             
from TemporalING t           
inner join Producto p            
on p.IdProducto=t.IdProducto            
where t.UsuarioId=@UsuarioId and Concepto=@Concepto            
for xml path('')),1,1,'')),'~')        
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertaTemVenta]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertaTemVenta]
@Data varchar(max)
as
begin      
Declare @pos1 int,@pos2 int,      
  @pos3 int,@pos4 int,      
  @pos5 int,@pos6 int,      
  @pos7 int      
Declare @UsuarioID int,      
  @IdProducto numeric(20),      
  @cantidad decimal(18,2),      
  @precioventa decimal(18,2),      
  @importe decimal(18,2),      
  @ValorUM decimal(18,4),      
  @Unidad varchar(40)   
Set @Data = LTRIM(RTrim(@Data))      
Set @pos1 = CharIndex('|',@Data,0)      
Set @pos2 = CharIndex('|',@Data,@pos1+1)      
Set @pos3 = CharIndex('|',@Data,@pos2+1)      
Set @pos4 = CharIndex('|',@Data,@pos3+1)      
Set @pos5= CharIndex('|',@Data,@pos4+1)      
Set @pos6= CharIndex('|',@Data,@pos5+1)     
Set @pos7=Len(@Data)+1      
Set @UsuarioID=convert(int,SUBSTRING(@Data,1,@pos1-1))      
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))      
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))      
Set @precioventa=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))      
Set @importe=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))      
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))      
Set @Unidad=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)
insert into TemporalVenta values(@UsuarioID,@IdProducto,@cantidad,
@precioventa,@importe,@ValorUM,@Unidad,'P')
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertaUnion]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertaUnion]    
@Data varchar(max)    
as    
begin    
Declare @pos1 int,@pos2 int,    
        @pos3 int,@pos4 int,   
  @pos5 int,@pos6 int,   
  @pos7 int  
Declare @Id int,  
        @IdProducto numeric(20),  
        @IdProductoB numeric(20),  
  @Cantidad decimal(18,2),  
  @UM varchar(80),  
  @Precio decimal(18,2),  
  @ValorUM decimal(18,4)  
  
Set @Data = LTRIM(RTrim(@Data))    
Set @pos1 = CharIndex('|',@Data,0)  
Set @pos2 = CharIndex('|',@Data,@pos1+1)  
Set @pos3 = CharIndex('|',@Data,@pos2+1)  
Set @pos4 = CharIndex('|',@Data,@pos3+1)  
Set @pos5 = CharIndex('|',@Data,@pos4+1)  
Set @pos6 = CharIndex('|',@Data,@pos5+1)  
Set @pos7 = Len(@Data)+1      
  
Set @Id =convert(int,SUBSTRING(@Data,1,@pos1-1))    
Set @IdProducto=convert(numeric,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))  
Set @IdProductoB=convert(numeric,SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))   
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))    
Set @UM=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)  
Set @Precio=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))    
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))  
      
if (@Id=0)   
begin  
  
insert into ProductoUnion values(@IdProducto,@IdProductoB,@Cantidad,@UM,@Precio,@ValorUM,'P')  
select 'true'  
  
end   
else    
begin    
  
update ProductoUnion   
set Cantidad=@Cantidad,Estado='P'   
where Id=@Id    
select 'true'    
  
end    
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaBajas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListaBajas]
@Data varchar(max)
as
begin
Declare @p1 int
Declare @CompaniaId int
Set @Data = LTRIM(RTrim(@Data))
set @CompaniaId=@Data
select
'DocuId|Compania|NotaId|FechaEmision|Documento|Numero|RazonSocial|DNI|SubTotal|IGV|ICBPER|Total|Usuario|Estado¬100|80|100|115|95|130|350|90|115|115|100|115|160|125¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+convert(varchar,d.NotaId)+'|'+
(Convert(char(10),d.DocuEmision,103))+'|'+d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+
c.ClienteRazon+'|'+c.ClienteDni+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money), -1))+'|'+
(convert(varchar(50), CAST(d.ICBPER as money), -1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money), -1))+'|'+
d.DocuUsuario+'|'+d.EstadoSunat
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
where d.TipoCodigo='03'and((d.CompaniaId=@CompaniaId and DocuEstado='ANULADO' and EstadoSunat='ENVIADO'))
order by d.DocuSerie,d.DocuNumero asc
FOR XML path ('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaDetalleAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaDetalleAlmacen]      
@GuiaId varchar(80)      
as      
begin      
select      
'DetalleId|GuiaId|IdStock|Cantidad|UM|Descripcion|ValorUm|Concepto|IdProducto|Inicial|Imagen¬80|80|80|100|100|490|80|80|80|80|100¬String|String|String|String|String|String|String|String|String|String|String¬'+      
isnull((select STUFF ((select '¬'+      
convert(varchar,d.DetalleId)+'|'+convert(varchar,d.GuiaId)+'|'+      
convert(varchar,d.IdStock)+'|'+CONVERT(VarChar(50),cast(d.Cantidad as money ), 1)+'|'+d.UniMedida+'|'+      
d.Descripcion+'|'+convert(varchar,d.ValorUM)+'||'+convert(varchar,s.IdProducto)+'|0|'+p.ProductoImagen   
from DetalleStock d      
inner join Stock s      
on s.IdStock=d.IdStock
inner join Producto p
on p.IdProducto=s.IdProducto      
where GuiaId=@GuiaId      
for xml path('')),1,1,'')),'~')      
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaDetalleAlmacenB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaDetalleAlmacenB]
@NotaId varchar(80)
as
begin
select
'DetalleId|GuiaId|IdStock|Cantidad|UM|Descripcion|ValorUm|Concepto|IdProducto¬80|80|80|100|100|550|80|80|80¬String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+
convert(varchar,d.DetalleId)+'|'+convert(varchar,d.GuiaId)+'|'+
convert(varchar,d.IdStock)+'|'+CONVERT(VarChar(50),cast(d.Cantidad as money ), 1)+'|'+d.UniMedida+'|'+
d.Descripcion+'|'+convert(varchar,d.ValorUM)+'||'+convert(varchar,s.IdProducto)
from DetalleStock d
inner join Stock s
on s.IdStock=d.IdStock
where d.NotaId=@NotaId and d.ESTADO='P'
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaDetalleING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaDetalleING]          
@GuiaId varchar(80)          
as          
begin          
select  
'DetalleId|GuiaId|IdPro|Cantidad|UM|Descripcion|ValorUm|Concepto|Imagen|OBS¬80|80|80|100|100|490|80|80|100|80¬String|String|String|String|String|String|String|String|String|String¬'+          
isnull((select STUFF ((select '¬'+          
convert(varchar,d.DetalleId)+'|'+convert(varchar,d.GuiaId)+'|'+          
convert(varchar,d.IdProducto)+'|'+CONVERT(VarChar(50),cast(d.Cantidad as money ), 1)+'|'+d.UniMedida+'|'+          
d.Descripcion+'|'+convert(varchar,d.ValorUM)+'||'+p.ProductoImagen+'|'+
p.ProductoObs       
from DetalleIngreso d   
inner join Producto p    
on p.IdProducto=d.IdProducto          
where GuiaId=@GuiaId          
for xml path('')),1,1,'')),'~')          
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaDetalleturno]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usplistaDetalleturno]  
@PersonalId nvarchar(20)  
as   
Select  
isnull((select STUFF ((select '¬'+   
convert(char(1),d.Estado)+'|'+  
d.Dia+'|'+  
convert(varchar,d.TurnoId)  
from DetalleTurnos d  
where d.PersonalId=@PersonalId  
order by d.DetalleId asc  
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[uspListaDocumentos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspListaDocumentos]    
@Data varchar(max)    
as    
begin    
Declare @p1 int    
Declare @CompaniaId int    
declare @fechaReferencia date    
Set @Data = LTRIM(RTrim(@Data))    
set @CompaniaId=@Data    
set @fechaReferencia=(select top 1 DocuEmision from DocumentoVenta    
where TipoCodigo='03'and((CompaniaId=@CompaniaId and EstadoSunat='PENDIENTE') and DocuEmision<convert(date,GETDATE()))    
group by DocuEmision    
order by DocuEmision asc)    
select    
'DocuId|Compania|NotaId|FechaEmision|Documento|Numero|RazonSocial|DNI|SubTotal|IGV|ICBPER|Total|Usuario|Estado¬100|80|100|115|95|130|350|90|115|115|100|115|160|125¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+    
isnull((select STUFF((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+convert(varchar,d.NotaId)+'|'+    
(Convert(char(10),d.DocuEmision,103))+'|'+d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+    
c.ClienteRazon+'|'+c.ClienteDni+'|'+    
(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))+'|'+    
(convert(varchar(50), CAST(d.DocuIgv as money), -1))+'|'+    
(convert(varchar(50), CAST(d.ICBPER as money), -1))+'|'+    
(convert(varchar(50), CAST(d.DocuTotal as money), -1))+'|'+    
d.DocuUsuario+'|'+d.EstadoSunat    
from DocumentoVenta d    
inner join Cliente c    
on c.ClienteId=d.ClienteId    
where d.TipoCodigo='03'and((d.CompaniaId=@CompaniaId and EstadoSunat='PENDIENTE') and d.DocuEmision=@fechaReferencia)    
order by d.DocuSerie,d.DocuNumero asc    
FOR XML path ('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaFacturaPendiente]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaFacturaPendiente]
as
begin
select 
'DocuID|NotaId|FechaEmision|Documento|Numero|Cliente|RUC|Descuento|SubTotal|IGV|ICBPER|Total|Usuario|Compania|Movilidad|Adicional|TipoCodigo|Serie|Nro|Forma¬90|100|100|100|130|350|100|100|110|110|90|110|150|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.NotaId)+'|'+
Convert(char(10),d.DocuEmision,103)+'|'+d.DocuDocumento+'|'+
d.DocuSerie+'-'+d.DocuNumero+'|'+cl.ClienteRazon+'|'+cl.ClienteRuc+'|'+
CONVERT(VarChar(50), cast(n.NotaDescuento as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DocuIgv as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.ICBPER as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)+'|'+d.DocuUsuario+'|'+c.CompaniaRazonSocial+'|'+
CONVERT(VarChar(50), cast(n.NotaMovilidad as money ), 1)+'|'+
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)+'|'+
LTRIM(RTrim(d.TipoCodigo))+'|'+d.DocuSerie+'|'+d.DocuNumero+'|'+
n.NotaFormaPago
from DocumentoVenta d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join Cliente cl
on cl.ClienteId=d.ClienteId
inner join Compania c
on c.CompaniaId=d.CompaniaId
where d.EstadoSunat='PENDIENTE' and (d.TipoCodigo='01' or d.TipoCodigo='07')
order by d.CompaniaId,d.DocuEmision asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaFacturasNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListaFacturasNC]
@CompraId varchar(38)
as
begin
select 
isnull((select STUFF((select '¬'+ convert(varchar,c.AsociadoID)+'|'+c.Factura+'|'+
CONVERT(VarChar(50), cast(c.Monto as money ), 1)+'|'+c.Moneda+'|'+
CONVERT(VarChar(50), cast(c.Acuenta as money ), 1)+'|'+
CONVERT(VarChar(50), cast(c.Saldo as money ), 1)+'|'+CONVERT(varchar,c.ID)
from FacturasNC c
where c.CompraId=@CompraId
order by c.ID asc 
FOR XML PATH('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaGuiaAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaGuiaAlmacen]  
@Concepto varchar(80)  
as  
begin  
select  
'NroGuia|NotaId|FechaEmision|Motivo|RazonSocial|Documento|Numero|Observaciones|Responsable|Usuario|Almacen¬80|80|80|80|80|80|80|80|80|80|80¬String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF ((select '¬'+convert(varchar,g.GuiaId)+'|'+g.NotaId+'|'+  
(IsNull(convert(varchar,g.GuiaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GuiaRegistro,114),1,8),''))+'|'+  
g.GuiaMotivo+'|'+g.RazonSocial+'|'+g.GuiaDoc+'|'+g.GuiaDocNumero+'|'+g.GuiaObservacion+'|'+  
g.GuiaResponsable+'|'+g.GuiaUsuario+'|'+convert(varchar,g.AlmacenId)  
from GuiaAlmacen G  
where g.GuiaConcepto=@Concepto and(MONTH(g.GuiaRegistro)=MONTH(GETDATE()) and YEAR(g.GuiaRegistro)=YEAR(GETDATE()))  
order by g.GuiaId desc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaGuiaFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaGuiaFecha]
@Id varchar(80),
@fechainicio date,
@fechafin date
as
begin
select
'NroGuia|NotaId|FechaEmision|Motivo|RazonSocial|Documento|Numero|Observaciones|Responsable|Usuario|Almacen¬80|80|80|80|80|80|80|80|80|80|80¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,g.GuiaId)+'|'+g.NotaId+'|'+
(IsNull(convert(varchar,g.GuiaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GuiaRegistro,114),1,8),''))+'|'+
g.GuiaMotivo+'|'+g.RazonSocial+'|'+g.GuiaDoc+'|'+g.GuiaDocNumero+'|'+g.GuiaObservacion+'|'+
g.GuiaResponsable+'|'+g.GuiaUsuario+'|'+convert(varchar,g.AlmacenId)
from GuiaAlmacen G
where GuiaConcepto=@Id and (Convert(char(10),g.GuiaRegistro,103) BETWEEN @fechainicio AND @fechafin)
order by g.GuiaId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaGuiaFechaING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaGuiaFechaING]    
@Id varchar(80),    
@fechainicio date,    
@fechafin date    
as    
begin    
select        
'NroGuia|FechaEmision|Motivo|RazonSocial|Documento|Numero|Observaciones|Usuario|Almacen|Estado¬80|80|80|80|80|80|80|80|80|80¬String|String|String|String|String|String|String|String|String|String¬'+      
isnull((select STUFF ((select '¬'+convert(varchar,g.GuiaId)+'|'+     
(IsNull(convert(varchar,g.GuiaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GuiaRegistro,114),1,8),''))+'|'+      
g.GuiaMotivo+'|'+g.RazonSocial+'|'+g.GuiaDoc+'|'+g.GuiaDocNumero+'|'+g.GuiaObservacion+'|'+g.GuiaUsuario+'|'+
convert(varchar,g.AlmacenId)+'|'+g.Estado      
from GuiaIngreso G  
where GuiaConcepto=@Id and (Convert(char(10),g.GuiaRegistro,103) BETWEEN @fechainicio AND @fechafin)    
order by g.GuiaId desc    
for xml path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaGuiaIngreso]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaGuiaIngreso]   
@Concepto varchar(80)      
as      
begin      
select      
'NroGuia|FechaEmision|Motivo|RazonSocial|Documento|Numero|Observaciones|Usuario|Almacen|Estado¬80|80|80|80|80|80|80|80|80|80¬String|String|String|String|String|String|String|String|String|String¬'+      
isnull((select STUFF ((select '¬'+convert(varchar,g.GuiaId)+'|'+     
(IsNull(convert(varchar,g.GuiaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GuiaRegistro,114),1,8),''))+'|'+      
g.GuiaMotivo+'|'+g.RazonSocial+'|'+g.GuiaDoc+'|'+g.GuiaDocNumero+'|'+g.GuiaObservacion+'|'+g.GuiaUsuario+'|'+
convert(varchar,g.AlmacenId)+'|'+g.Estado      
from GuiaIngreso G
where g.GuiaConcepto=@Concepto and(MONTH(g.GuiaRegistro)=MONTH(GETDATE()) and YEAR(g.GuiaRegistro)=YEAR(GETDATE()))      
order by g.GuiaId desc      
for xml path('')),1,1,'')),'~')      
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaKardexB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usplistaKardexB] 
@IdStock numeric(38)
as
begin
	select 
	'KardexId|IdStock|FechaMovimiento|Motivo|Documento|StockInicial|CantidadIngre|CantidadSali|StockFinal|Concepto|Responsable¬100|100|145|260|145|115|115|115|115|100|160¬String|String|String|String|String|String|String|String|String|String|String¬'+
	isnull((select STUFF ((select '¬'+convert(varchar,k.KardexId)+'|'+CONVERT(varchar,k.IdStock)+'|'+
	(IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+
	k.KardexMotivo+'|'+k.KardexDocumento+'|'+
	CONVERT(VarChar(50), cast(k.StockInicial as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadSalida as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.StockFinal as money ), 1)+'|'+
	K.KadexConcepto+'|'+k.Usuario
	from KardexAlmacen k with(nolock)
	where k.IdStock=@IdStock and (Month(k.KardexFecha)=Month(GETDATE()) and YEAR(k.kardexFecha)=year(getdate()))
	order by k.KardexId desc
	for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListarArchivos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListarArchivos]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int
Declare @fechainicio date,
        @fechafin date
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2= Len(@Data)+1
Set @fechainicio=convert(date,SUBSTRING(@Data,1,@p1-1))
Set @fechafin=convert(date,SUBSTRING(@Data,@p1+1,@p2-@p1-1))
SELECT
'ID|FechaHora|Descripcion|Importe|Encargado|Ruta¬90|140|400|110|155|90¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
d.DetalleConcepto+'|'+CONVERT(varChar(max),cast(d.DetalleMonto as money ), 1)+'|'+
c.CajaEncargado+'|'+d.RutaImagen
from CajaDetalle d
inner join Caja c
on c.CajaId=d.CajaId
where (Convert(char(10),d.DetalleFecha,103) BETWEEN @fechainicio AND @fechafin)and(d.NotaId=0 and d.DetalleMovimiento='SALIDA')
order by d.DetalleId desc
FOR XML PATH('')), 1, 1, '')),'~')+'['+
'ID|FechaHora|Descripcion|Importe|Encargado|Ruta¬90|140|400|110|155|90¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
d.DetalleConcepto+'|'+CONVERT(varChar(max),cast(d.DetalleMonto as money ), 1)+'|'+
c.CajaEncargado+'|'+d.RutaImagen
from CajaDetalle d
inner join Caja c
on c.CajaId=d.CajaId
where (Convert(char(10),d.DetalleFecha,103) BETWEEN @fechainicio AND @fechafin) and(d.NotaId=0 and d.DetalleMovimiento='INGRESO' and d.Vista='')
order by d.DetalleId desc
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistarDetaCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistarDetaCaja]
@CajaId numeric(38)
as
begin
set @CajaId=isnull((select top 1 CajaId from Caja c
where c.CajaEstado='ACTIVO'
order by c.CajaId desc),0)
select
'Id|Fecha|Descripcion|Importe|Ruta|GastoId|Referencia¬80|150|420|115|100|100|100¬String|String|String|String|String|String|String¬'+
isnull((select stuff((select '¬'+convert(varchar,d.DetalleId)+'|'+
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
d.DetalleConcepto+'|'+
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+d.RutaImagen+'|'+d.GastoId+'|'+
d.DetalleReferencia
from CajaDetalle d
where d.CajaId=@CajaId and (d.NotaId=0 and d.DetalleMovimiento='INGRESO' and d.Vista='')
order by d.DetalleId desc
for xml path('')),1,1,'')),'~')+'['+
'Id|Fecha|Descripcion|Importe|Ruta|GastoId|Referencia¬80|150|420|115|100|100|100¬String|String|String|String|String|String|String¬'+
isnull((select stuff((select '¬'+convert(varchar,d.DetalleId)+'|'+
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
d.DetalleConcepto+'|'+
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+d.RutaImagen+'|'+d.GastoId+'|'+
d.DetalleReferencia
from CajaDetalle d
where d.CajaId=@CajaId and (d.NotaId=0 and d.DetalleMovimiento='SALIDA' and d.Vista='')
order by d.DetalleId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaResumen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usplistaResumen]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int
Declare @MES INT,@ANNO INT
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2= Len(@Data)+1
Set @MES=convert(int,SUBSTRING(@Data,1,@p1-1))
Set @ANNO=convert(int,SUBSTRING(@Data,@p1+1,@p2-@p1-1))
SELECT
'Id|Compania|FechaEmision|FechaEnvio|Serie|RangoNumeros|SubTotal|IGV|ICBPER|Total|Ticket|CDSunat|HASHCDR|Mensaje|Usuario|RUC|UserSol|ClaveSol|ESTADO|Intentos|TokenApi|IdToken¬100|100|100|100|100|100|100|100|110|110|110|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+ 
isnull((select STUFF ((select '¬'+convert(varchar,r.ResumenId)+'|'+convert(varchar,r.CompaniaId)+'|'+
(IsNull(convert(varchar,r.FechaReferencia,103),''))+'|'+
(IsNull(convert(varchar,r.FechaEnvio,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,r.FechaEnvio,114),1,8),''))+'|'+
r.ResumenSerie+'-'+convert(varchar,r.Secuencia)+'|'+r.RangoNumero+'|'+
CONVERT(VarChar(50),cast(r.SubTotal as money ), 1)+'|'+
CONVERT(VarChar(50),cast( r.IGV as money ), 1)+'|'+
CONVERT(VarChar(50),cast( r.ICBPER as money ), 1)+'|'+
CONVERT(VarChar(50),cast(r.Total as money ), 1)+'|'+
r.ResumenTiket+'|'+r.CodigoSunat+'|'+r.HASHCDR+'|'+r.MensajeSunat+'|'+
r.Usuario+'|'+c.CompaniaRUC+'|'+
c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+r.Estado+'||'+c.TokenApi+'|'+ClienIdToken
FROM ResumenBoletas r
inner join Compania c
on c.CompaniaId=r.CompaniaId
where Month(r.FechaReferencia)=@MES and YEAR(r.FechaReferencia)=@ANNO
order by r.CompaniaId,r.FechaEnvio asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListarLogCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListarLogCaja]      
@fechainicio date,      
@fechafin date      
as      
begin      
select       
'Id|FechaRegistro|NotaId|Accion|Movimiento|Justificacion|Monto|Cajero|Autoriza¬100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String¬'+      
isnull((select stuff((SELECT '¬'+ convert(varchar,l.LogId)+'|'+      
(IsNull(convert(varchar,l.FechaRegistro,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,l.FechaRegistro,114),1,8),''))+'|'+      
l.NotaId+'|'+l.Accion+'|'+l.Movimiento+'|'+l.Justificacion+'|'+      
CONVERT(VarChar(50), cast(l.Monto as money ), 1)+'|'+l.Cajero+'|'+l.Autoriza      
from logCaja l      
where (Convert(char(10),l.FechaRegistro,103) BETWEEN @fechainicio AND @fechafin)      
order by l.LogId desc      
for xml path('')),1,1,'')),'~')
--+'['+     
-- 'Id|Descripcion|UM|FechaMovimiento|Documento|Ingreso|PrecioCosto|Concepto|Responsable¬90|90|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String¬'+      
-- isnull((select stuff((SELECT '¬'+ convert(varchar,k.KardexId)+'|'+    
-- p.ProductoNombre+ ' '+p.ProductoMarca+'|'+p.ProductoUM+'|'+      
-- (IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+     
-- replace(k.KardexDocumento,'NV-','')+'|'+      
-- CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+    
-- CONVERT(VarChar(50), cast(k.PrecioCosto as money ), 1)+'|'+        
-- K.KadexConcepto+'|'+k.Usuario    
-- from Kardex k with(nolock)    
-- inner join Producto p    
-- on p.IdProducto=k.IdProducto     
-- where  (Convert(char(10),k.KardexFecha,103) BETWEEN @fechainicio AND @fechafin) and KardexMotivo='Anulacion por Venta'     
-- order by k.KardexId desc      
-- for xml path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[usplistarNC]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistarNC]
as
begin
select
'DocuId|Compania|NroNota|FechaEmision|Documento|Numero|RazonSocial|RUC|Referencia|Nro|Serie|SubTotal|IGV|ICBPER|Total|Usuario|Estado|Direccion|Asociado|CompaniaRazon|CompaniaRUC|Concepto|Gravada|Descuento|Adcional¬100|80|100|110|115|120|340|105|120|100|100|115|115|90|115|150|130|100|100|100|100|220|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+
d.DocuNroGuia+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+
(convert(varchar(50), CAST(d.ICBPER as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado+'|'+
co.CompaniaRazonSocial+'|'+co.CompaniaRUC+'|'+d.DocuConcepto+'|'+
(convert(varchar(50), CAST(d.DocuGravada as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuDescuento as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuAdicional as money),1))
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join Compania co
on co.CompaniaId=d.CompaniaId
where d.TipoCodigo='07'and (Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate()))
order by d.DocuId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistarNCFecha]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistarNCFecha]
@fechainicio date,
@fechafin date
as
begin
select
'DocuId|Compania|NroNota|FechaEmision|Documento|Numero|RazonSocial|RUC|Referencia|Nro|Serie|SubTotal|IGV|ICBPER|Total|Usuario|Estado|Direccion|Asociado|CompaniaRazon|CompaniaRUC|Concepto|Gravada|Descuento|Adcional¬100|80|100|110|115|120|340|105|120|100|100|115|115|90|115|150|130|100|100|100|100|220|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+
d.DocuNroGuia+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+
(convert(varchar(50), CAST(d.ICBPER as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado+'|'+
co.CompaniaRazonSocial+'|'+co.CompaniaRUC+'|'+d.DocuConcepto+'|'+
(convert(varchar(50), CAST(d.DocuGravada as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuDescuento as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuAdicional as money),1))
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join Compania co
on co.CompaniaId=d.CompaniaId
where d.TipoCodigo='07' and(Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)
order by d.DocuId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListarStock]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListarStock]        
@AlmacenId numeric(20)        
as        
begin        
select        
'IdStock|Id|Codigo|Descripcion|Cantidad|UnidadM|PrecioVenta|PrecioCosto|ValorUM|ValorCritico|Imagen|Usuario|Inversion¬100|100|120|470|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String¬'+        
isnull((select STUFF ((select '¬'+convert(varchar,s.IdStock)+'|'+        
convert(varchar,s.IdProducto)+'|'+p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+        
CONVERT(VarChar(50), cast(s.Cantidad as money ), 1)+'|'+p.ProductoUM+'|'+        
CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)+'|'+        
CONVERT(VarChar(50), cast(p.ProductoCosto as money ), 1)+'|'+        
'1'+'|'+convert(varchar,s.ValorUM)+'|'+p.ProductoImagen+'|'+        
s.Usuario+' '+(IsNull(convert(varchar,s.FechaEdicion,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,s.FechaEdicion,114),1,8),''))+'|'+        
CONVERT(VarChar(50),cast((s.Cantidad*p.ProductoCosto) as money ), 1)        
from Stock s (nolock)      
inner join Producto p (nolock)        
on p.IdProducto=s.IdProducto        
where s.AlmacenId=@AlmacenId and (s.Estado='BUENO' and s.Cantidad>0)       
order by p.ProductoNombre+ ' '+p.productoMarca asc        
for xml path('')),1,1,'')),'~')+'¬'+    
isnull((select STUFF ((select '¬'+convert(varchar,s.IdStock)+'|'+        
convert(varchar,s.IdProducto)+'|'+p.ProductoCodigo+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+        
CONVERT(VarChar(50), cast(s.Cantidad/u.ValorUM as money ), 1)+'|'+u.UMDescripcion+'|'+        
CONVERT(VarChar(50), cast(u.PrecioVenta as money ), 1)+'|'+        
CONVERT(VarChar(50), cast(u.PrecioCosto as money ), 1)+'|'+convert(varchar,u.ValorUM)+'|'+convert(varchar,u.ValorUM)+'|'+p.ProductoImagen+'|'+        
s.Usuario+' '+(IsNull(convert(varchar,s.FechaEdicion,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,s.FechaEdicion,114),1,8),''))+'|'+        
CONVERT(VarChar(50),cast((s.Cantidad*p.ProductoCosto) as money ), 1)        
from Stock s (nolock)        
inner join Producto p (nolock)       
on p.IdProducto=s.IdProducto    
inner join UnidadMedida u(nolock)      
on p.IdProducto=u.IdProducto     
where s.AlmacenId=@AlmacenId and (s.Estado='BUENO' and s.Cantidad>0)       
order by p.ProductoNombre+ ' '+p.productoMarca asc        
for xml path('')),1,1,'')),'~')         
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaSeries]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListaSeries]
as
begin
select
'UsuarioId|CompaniaId|Compania|Usuario|Serie|EnviaBoleta|EnviarFactura|Admin¬100|85|100|180|90|100|100|100¬String|String|String|String|String|Boolean|Boolean|Boolean¬'+
isnull((select STUFF ((select '¬'+ convert(varchar,u.UsuarioID)+'|'+convert(varchar,p.CompaniaId)+'|'+c.CompaniaRazonSocial+'|'+
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+
u.UsuarioSerie+'|'+convert(char(1),u.EnviaBoleta)+'|'+convert(char(1),u.EnviarFactura)+'|'+
convert(char(1),u.Administrador)
from Usuarios u
inner join Personal p
on p.PersonalId=u.PersonalId
inner join Compania c
on c.CompaniaId=p.CompaniaId
where u.UsuarioEstado='ACTIVO'
order by p.PersonalNombres asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaTempoAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaTempoAlmacen]        
@Data varchar(max)        
as        
Declare @p1 int,@p2 int        
Declare @UsuarioId int,@Concepto char(1)        
Set @Data = LTRIM(RTrim(@Data))        
Set @p1 = CharIndex('|',@Data,0)        
Set @p2 =Len(@Data)+1        
Set @UsuarioId=convert(int,SUBSTRING(@Data,1,@p1-1))        
Set @Concepto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)        
begin
select
'TemId|UsuarioId|IdStock|Cantidad|UM|Descripcion|ValorUm|Concepto|IdProducto|CanIni|Imagen¬80|80|80|100|100|490|80|80|80|100|100¬String|String|String|String|String|String|String|String|String|String|String¬'+        
isnull((select STUFF ((select '¬'+        
convert(varchar,t.TemporalId)+'|'+convert(varchar,t.UsuarioId)+'|'+        
convert(varchar,t.IdStok)+'|'+CONVERT(VarChar(50),cast(t.Cantidad as money ), 1)+'|'+t.UniMedida+'|'+        
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar,t.ValorUM)+'|'+t.Concepto+'|'+    
convert(varchar,s.IdProducto)+'|'+CONVERT(varchar,t.CanInicial)+'|'+
p.ProductoImagen       
from TemporalAlmacen t     
inner join Stock s    
on s.IdStock=t.IdStok        
inner join Producto p        
on p.IdProducto=s.IdProducto        
where t.UsuarioId=@UsuarioId and Concepto=@Concepto        
for xml path('')),1,1,'')),'~')        
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaTempoING]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaTempoING]          
@Data varchar(max)          
as          
Declare @p1 int,@p2 int          
Declare @UsuarioId int,@Concepto char(1)          
Set @Data = LTRIM(RTrim(@Data))          
Set @p1 = CharIndex('|',@Data,0)          
Set @p2 =Len(@Data)+1          
Set @UsuarioId=convert(int,SUBSTRING(@Data,1,@p1-1))          
Set @Concepto=SUBSTRING(@Data,@p1+1,@p2-@p1-1)          
begin          
select          
'TemId|UsuarioId|IdProducto|Cantidad|UM|Descripcion|ValorUm|Concepto|Imagen|OBS¬80|80|80|100|100|490|80|80|80|80¬String|String|String|String|String|String|String|String|String|String¬'+          
isnull((select STUFF ((select '¬'+          
convert(varchar,t.TemporalId)+'|'+convert(varchar,t.UsuarioId)+'|'+          
convert(varchar,t.IdProducto)+'|'+CONVERT(VarChar(50),cast(t.Cantidad as money ), 1)+'|'+t.UniMedida+'|'+          
p.ProductoNombre+' '+p.ProductoMarca+'|'+convert(varchar,t.ValorUM)+'|'+t.Concepto+'|'+    
p.ProductoImagen+'|'+p.ProductoObs           
from TemporalING t         
inner join Producto p          
on p.IdProducto=t.IdProducto          
where t.UsuarioId=@UsuarioId and Concepto=@Concepto          
for xml path('')),1,1,'')),'~')          
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaTotalAlmacenes]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaTotalAlmacenes]              
as              
begin              
select               
'Id|Codigo|Descripcion|Cant_Total|1_Piso|2_PISO|3_Piso|Cuartito|Km19|PrecioVenta|Costo|Inversion|VentaNeta|Ganancia|Marca¬0|0|0|0|0|0|0|0|0|0|0|0|0|0|0¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+         
(select STUFF((select '¬'+               
convert(varchar,isnull(a.ID,b.ID))+'|'+              
isnull(a.Codigo,b.Codigo)+'|'+              
isnull(a.Deccripcion,isnull(b.Deccripcion,isnull(c.Deccripcion,d.Deccripcion)))+'|'+              
convert(varchar,isnull(a.CanTienda,'0')+isnull(b.SegundoPiso,'0')+isnull(c.TercerPiso,'0')+isnull(d.Cuartito,'0'))+'|'+
--isnull(a.CantidadNB,ISNULL(b.CantidadNB,isnull(c.CantidadNB,isnull(d.CantidadNB,'0')))))
       
convert(varchar,isnull(a.CanTienda,'0')) +'|'+              
convert(varchar,isnull(b.SegundoPiso,'0'))+'|'+              
convert(varchar,isnull(c.TercerPiso,'0'))+'|'+              
convert(varchar,isnull(d.Cuartito,'0'))+'|'+ 
'0.00|'+       
--convert(varchar,isnull(a.CantidadNB,ISNULL(b.CantidadNB,isnull(c.CantidadNB,isnull(d.CantidadNB,'0'))))) 
           
convert(varchar,isnull(a.PrecioVenta,ISNULL(b.PrecioVenta,isnull(c.PrecioVenta,isnull(d.PrecioVenta,'0'))))) +'|'+              
convert(varchar,isnull(a.Costo,ISNULL(b.Costo,isnull(c.costo,isnull(d.costo,'0')))))+'||||'+        
isnull(a.Marca,isnull(b.Marca,isnull(c.Marca,d.Marca)))           
from(select               
p.IdProducto as ID,p.ProductoCodigo as Codigo,p.ProductoNombre+' '+p.ProductoMarca as Deccripcion,              
p.ProductoCantidad as CanTienda,p.ProductoVenta as PrecioVenta,             
p.ProductoCosto as Costo,p.ProductoMarca as Marca
--,p.CantidadNB as CantidadNB         
from Producto p              
where p.ProductoEstado='BUENO')a              
full join(                
select P.IdProducto as ID,p.ProductoCodigo as Codigo,p.ProductoNombre+' '+p.ProductoMarca as Deccripcion,              
isnull(s.Cantidad,'0') as SegundoPiso,p.ProductoVenta as PrecioVenta,          
p.ProductoCosto as Costo,p.ProductoMarca as Marca
--,p.CantidadNB as CantidadNB           
from Stock S              
RIGHT JOIN Producto p              
ON S.IdProducto=p.IdProducto              
where  s.AlmacenId='12' and s.Estado='BUENO')b on a.ID=b.ID--segundo piso              
full join(                
select P.IdProducto as ID,p.ProductoCodigo as Codigo,p.ProductoNombre+' '+p.ProductoMarca as Deccripcion,              
isnull(s.Cantidad,'0') as TercerPiso,              
p.ProductoVenta as PrecioVenta,          
p.ProductoCosto as Costo,p.ProductoMarca as Marca
--,p.CantidadNB as CantidadNB                
from Stock S              
RIGHT JOIN Producto p              
ON S.IdProducto=p.IdProducto              
where s.AlmacenId='7' and s.Estado='BUENO')c on a.ID=c.ID--tercer piso              
full join(                
select P.IdProducto as ID,p.ProductoCodigo as Codigo,p.ProductoNombre+' '+p.ProductoMarca as Deccripcion,              
isnull(s.Cantidad,'0') as Cuartito,              
p.ProductoVenta as PrecioVenta,          
p.ProductoCosto as Costo,p.ProductoMarca as Marca
--,p.CantidadNB as CantidadNB              
from Stock S              
RIGHT JOIN Producto p              
ON S.IdProducto=p.IdProducto              
where s.AlmacenId='13' and s.Estado='BUENO')d on a.ID=d.ID --cuartito              
order by a.Deccripcion asc              
FOR XML PATH('')),1,1,''))                
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaUnionPro]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaUnionPro]     
@IdProducto nvarchar(20)    
as    
begin    
select    
'Id|IdProducto|Cantidad|Unidad|Descripcion|PreVenta|ValorUM|Importe|Estado¬80|80|80|80|80|80|80|80|80¬String|String|String|String|String|String|String|String|String¬'+    
isnull((select STUFF ((select '¬'+convert(varchar,u.Id)+'|'+  
CONVERT(varchar,u.IdProductoB)+'|'+convert(varchar,u.Cantidad)+'|'+u.UM+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+  
CONVERT(VarChar(50),cast(u.Precio as money ), 1)+'|'+  
convert(varchar,u.ValorUM)+'|'+   
CONVERT(VarChar(50),cast((u.Cantidad*u.Precio) as money ), 1)+'|'+    
u.Estado  
from ProductoUnion u (nolock)  
inner join Producto P (nolock)  
on p.IdProducto=u.IdProductoB  
where u.IdProducto=@IdProducto    
order by u.Id asc    
for xml path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[uspOrdersGrabar]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[uspOrdersGrabar]
@ListaOrden varchar(Max),
@PKardex varchar(max)
As
Begin
	Declare @IdBloque numeric(38)
	Set  @IdBloque= -1
	Declare @pos int
	Declare @c1 int,@c2 int,@c3 int
	Set @pos = CharIndex('[',@ListaOrden,0)
	Declare @orden varchar(max)
	Declare @detalle varchar(max)
	Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
	Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
	Set @c1= CharIndex('|',@orden,0)
	Set @c2= CharIndex('|',@orden,@c1+1)
	Set @c3 =Len(@orden)+1
	declare @BloqueCaja numeric(38),
    @BloqueTotal decimal(18,2),@Cajero VARCHAR(80)
	Set @BloqueCaja=Convert(numeric(38),SUBSTRING(@orden,1,@c1-1))
	Set @BloqueTotal=Convert(decimal(18,2),SUBSTRING(@orden,@c1+1,@c2-(@c1+1)))
	Set @Cajero=SUBSTRING(@orden,@c2+1,@c3-(@c2+1))
	Begin Transaction
	Insert Into BLOQUE values(@BloqueCaja,GETDATE(),@BloqueTotal)
	Set @IdBloque= @@identity
	Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
		Declare @Columna varchar(max),
		@CajaId numeric(38),
		@NotaId numeric(38),
		@Monto decimal(18,2)
		Declare @pos1 int
		Declare @pos2 int
		Declare @pos3 int
	Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
		Set @pos1 = CharIndex('|',@Columna,0)
		Set @pos2 = CharIndex('|',@Columna,@pos1+1)
		Set @pos3 =Len(@Columna)+1
        Set @CajaId= Convert(numeric(38),SUBSTRING(@Columna,1,@pos1-1))
		Set @NotaId= Convert(numeric(38),SUBSTRING(@Columna,@pos1+1,@pos2-(@pos1+1)))
		Set @Monto= Convert(decimal(18,2),SUBSTRING(@Columna,@pos2+1,@pos3-@pos2-1))
		insert into DetalleBloque values(@IdBloque,@NotaId)
		insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,'INGRESO','','COBRO EN BLOQUE',@Monto,@Monto,0,'','T','',@Cajero,'','')
		update NotaPedido 
        set NotaSaldo=0,NotaAcuenta=@Monto,NotaEstado='CANCELADO',CajaId=@CajaId
        where NotaId=@NotaId
		Fetch Next From Tabla INTO @Columna
	End
	Close Tabla;
	Deallocate Tabla;
	begin
	DECLARE @Kardex VARCHAR(MAX)
    Set @Kardex =@PKardex
	Declare TablaB Cursor For Select * From fnSplitString(@Kardex,';')	
Open TablaB
		Declare @ColumnaB varchar(max),
		@IdProducto numeric(20),
		@Documento varchar(150),
		@CantSalida decimal(18,2),
		@PrecioCosto decimal(18,4),
		@Usuario varchar(80)
		Declare @p1 int
		Declare @p2 int
		Declare @p3 int
		declare @p4 int
		declare @p5 int
		declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)
Fetch Next From TablaB INTO @ColumnaB
	While @@FETCH_STATUS = 0
	Begin
		Set @p1 = CharIndex('|',@ColumnaB,0)
		Set @p2 = CharIndex('|',@ColumnaB,@p1+1)
		Set @p3 = CharIndex('|',@ColumnaB,@p2+1)
		Set @p4 = CharIndex('|',@ColumnaB,@p3+1)
		Set @p5 =Len(@ColumnaB)+1
        Set @IdProducto=Convert(numeric(20),SUBSTRING(@ColumnaB,1,@p1-1))
		Set @Documento= Convert(varchar(150),SUBSTRING(@ColumnaB,@p1+1,@p2-(@p1+1)))
		Set @CantSalida= Convert(varchar(80),SUBSTRING(@ColumnaB,@p2+1,@p3-(@p2+1)))
		Set @PrecioCosto= Convert(varchar(80),SUBSTRING(@ColumnaB,@p3+1,@p4-(@p3+1)))
		Set @Usuario= Convert(varchar(80),SUBSTRING(@ColumnaB,@p4+1,@p5-@p4-1))
		set @IniciaStock=(select top 1 ProductoCantidad from Producto(nolock) where IdProducto=@IdProducto)
		set @StockFinal=@IniciaStock-@CantSalida
		insert into Kardex values(@IdProducto,GETDATE(),'Salida por Venta',@Documento,@IniciaStock,
		0,@CantSalida,@PrecioCosto,@StockFinal,'SALIDA',@Usuario)
		update producto 
	    set  ProductoCantidad =ProductoCantidad - @CantSalida
	    where IDProducto=@IdProducto
		Fetch Next From TablaB INTO @ColumnaB
	End
	Close TablaB;
	Deallocate TablaB;
	end
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[uspPersonalBaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspPersonalBaja]
as
begin
select
'Id|Personal|AREA|FechaBaja|Estado¬90|360|160|100|100¬String|String|String|String|String¬'+
isnull((select stuff((SELECT '¬'+ convert(varchar,P.PersonalId)+'|'+
P.PersonalNombres+' '+P.PersonalApellidos+'|'+a.AreaNombre+'|'+
p.PersonalBajaFecha+'|'+p.PersonalEstado
from Personal P
inner join Area a
on a.AreaId=p.AreaId
where p.PersonalEstado='DESACTIVO'
order by P.PersonalNombres+' '+P.PersonalApellidos asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspReEnviarFactura]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspReEnviarFactura]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
        @p3 int
DECLARE @NotaId numeric(38),@CodigoSunat VARCHAR(80),
        @MensajeSunat varchar(max)
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 =Len(@Data)+1
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CodigoSunat=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @MensajeSunat=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
update DocumentoVenta
set EstadoSunat='ENVIADO',CodigoSunat=@CodigoSunat,
MensajeSunat=@MensajeSunat
where NotaId=@NotaId and (TipoCodigo='01' and EstadoSunat='PENDIENTE')
update DetallePedido
set DetalleEstado='EMITIDO'
where NotaId=@NotaId
select 'true' 
end
GO
/****** Object:  StoredProcedure [dbo].[uspReEnviarNotaCredito]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspReEnviarNotaCredito]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
        @p3 int
DECLARE @DocuId numeric(38),@CodigoSunat VARCHAR(80),
        @MensajeSunat varchar(max)
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 =Len(@Data)+1
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CodigoSunat=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @MensajeSunat=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
update DocumentoVenta
set EstadoSunat='ENVIADO',CodigoSunat=@CodigoSunat,MensajeSunat=@MensajeSunat
where DocuId=@DocuId and (TipoCodigo='07' and EstadoSunat='PENDIENTE')
select 'true' 
end
GO
/****** Object:  StoredProcedure [dbo].[uspReporteAnual]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspReporteAnual]
@CompaniaId int,
@ANNO int
AS
begin
SELECT
--isnull(b.NroMes,s.NroMes) as NroMes,
--isnull(b.Mes,S.Mes) as Mes, 
isnull(b.NroMes,isnull(S.NroMes,isnull(d.NroMes,isnull(x.NroMes,z.NroMes)))) as NroMes,
isnull(b.Mes,isnull(S.Mes,isnull(d.Mes,isnull(x.Mes,z.Mes)))) as Mes,
convert(varchar(50),cast((ISNULL(b.Monto,0))as money),1) as Ventas,
convert(varchar(50),cast((ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0))as money),1) as Compras,
convert(varchar(50),cast((ISNULL(b.Monto,0)-(ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0)))as money),1) as Ganancia
FROM(
select month(d.DocuEmision) as NroMes,Datename(MONTH,d.DocuEmision)as Mes,sum(d.DocuTotal)as Monto
from DocumentoVenta d with(nolock)
where (CompaniaId=@CompaniaId and year(d.DocuEmision)=@ANNO)and(D.DocuDocumento<>'PROFORMA V')
group by month(d.DocuEmision),Datename(MONTH,d.DocuEmision)) b
full join
(
    select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,SUM(c.CompraTotaL)as Monto
	from Compras c with(nolock)--FACTURAS EN SOLES
	where (c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO)and(c.TipoCodigo='01' and c.CompraMoneda='SOLES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)s on s.NroMes=b.NroMes
full join(
	select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
	from Compras c with(nolock)--FACTURAS EN DOLARES
	where (c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO) and (c.TipoCodigo='01' and c.CompraMoneda='DOLARES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)d on d.NroMes=b.NroMes
full join (
	select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,sum(c.CompraTotal) as Monto
	from Compras c with(nolock)--nota de credito en soles
	where (c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO) AND(c.TipoCodigo='07' and c.CompraMoneda='SOLES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)x on x.NroMes=b.NroMes
full join(
	select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
	from Compras c with(nolock)--credito EN DOLARES
	where c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO and (c.TipoCodigo='07' and c.CompraMoneda='DOLARES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)z on z.NroMes=b.NroMes
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[uspResumenDetalle]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspResumenDetalle]       
@fechainicio date,      
@fechafin date      
as      
begin      
select       
'ID|Descripcion|Cantidad|UM|Importe¬90|400|110|100|115¬String|String|String|String|String¬'+      
isnull((select STUFF((select '¬'+convert(varchar,d.IdProducto)+'|'+      
d.DetalleDescripcion+'|'+      
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+      
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)      
from NotaPedido n      
inner join DetallePedido d      
on d.NotaId=n.NotaId      
where n.NotaConcepto='MERCADERIA' and n.NotaEstado='CANCELADO'
and (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)      
group by d.IdProducto,d.DetalleDescripcion,d.DetalleUm      
order by d.DetalleDescripcion asc      
for xml path('')),1,1,'')),'~')+'['+   
'ID|Descripcion|Cantidad¬90|400|110¬String|String|String¬'+   
isnull((select STUFF((select top 8 '¬'+convert(varchar,d.IdProducto)+'|'+        
d.DetalleDescripcion+' '+d.DetalleUm+'|'+        
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)    
from NotaPedido n        
inner join DetallePedido d        
on d.NotaId=n.NotaId        
where (n.NotaConcepto='MERCADERIA' and n.NotaEstado='CANCELADO')and 
(Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)      
group by d.IdProducto,d.DetalleDescripcion,d.DetalleUm        
order by SUM(d.DetalleCantidad) desc        
for xml path('')),1,1,'')),'~')     
end
GO
/****** Object:  StoredProcedure [dbo].[uspResumenDetalleZ]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspResumenDetalleZ]
@Valores varchar(max)     
as        
begin
Declare @Mes int,        
        @Anno int,
        @IdSubLinea int
Declare @a1 int,@a2 int,@a3 int

Set @Valores= LTRIM(RTrim(@Valores))
Set @a1=CharIndex('|',@Valores,0)
Set @a2=CharIndex('|',@Valores,@a1+1)
Set @a3=Len(@Valores)+1
set @Mes=SUBSTRING(@Valores,1,@a1-1)
set @Anno=SUBSTRING(@Valores,@a1+1,@a2-@a1-1)
set @IdSubLinea=SUBSTRING(@Valores,@a2+1,@a3-@a2-1)       
select         
'ID|Descripcion|Cantidad¬90|400|110¬String|String|String¬'+        
isnull((select STUFF((select top 5 '¬'+convert(varchar,d.IdProducto)+'|'+        
d.DetalleDescripcion+' '+d.DetalleUm+'|'+        
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)    
from NotaPedido n        
inner join DetallePedido d        
on d.NotaId=n.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto        
where p.IdSubLinea=@IdSubLinea and (month(n.NotaFecha)=@Mes and year(n.NotaFecha)=@Anno) and     
(n.NotaConcepto='MERCADERIA' and n.NotaEstado='CANCELADO')      
group by d.IdProducto,d.DetalleDescripcion,d.DetalleUm        
order by SUM(d.DetalleCantidad) desc        
for xml path('')),1,1,'')),'~')        
end
GO
/****** Object:  StoredProcedure [dbo].[uspResumenSubLinea]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspResumenSubLinea]      
@Data varchar(max)      
as      
Declare @IdSubLinea numeric(20),      
        @fechainicio date,      
        @fechafin date      
Declare @p1 int,@p2 int,@p3 int      
Set @p1 = CharIndex('|',@Data,0)      
Set @p2 = CharIndex('|',@Data,@p1+1)      
Set @p3 = Len(@Data)+1      
Set @IdSubLinea=convert(numeric(20),SUBSTRING(@Data,1,@p1-1))      
Set @fechainicio=convert(date,SUBSTRING(@Data,@p1+1,@p2-@p1-1))      
Set @fechafin=SUBSTRING(@Data,@p2+1,@p3-@p2-1)      
begin      
select       
'ID|Descripcion|Cantidad|UM|Importe¬90|400|110|100|115¬String|String|String|String|String¬'+      
isnull((select STUFF((select '¬'+convert(varchar,d.IdProducto)+'|'+      
d.DetalleDescripcion+'|'+      
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+      
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)      
from NotaPedido n      
inner join DetallePedido d      
on d.NotaId=n.NotaId      
inner join Producto p      
on p.IdProducto=d.IdProducto      
where p.IdSubLinea=@IdSubLinea and 
n.NotaConcepto='MERCADERIA' and n.NotaEstado='CANCELADO'
and (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)      
group by d.IdProducto,d.DetalleDescripcion,d.DetalleUm      
order by SUM(d.DetalleCantidad) desc      
for xml path('')),1,1,'')),'~')+'['+  
'ID|Descripcion|Cantidad¬90|400|110¬String|String|String¬'+   
isnull((select STUFF((select top 8 '¬'+convert(varchar,d.IdProducto)+'|'+        
d.DetalleDescripcion+' '+d.DetalleUm+'|'+        
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)    
from NotaPedido n        
inner join DetallePedido d        
on d.NotaId=n.NotaId  
inner join Producto p  
on p.IdProducto=d.IdProducto  
where p.IdSubLinea=@IdSubLinea and 
n.NotaConcepto='MERCADERIA' and n.NotaEstado='CANCELADO' and   
(Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)        
group by d.IdProducto,d.DetalleDescripcion,d.DetalleUm        
order by SUM(d.DetalleCantidad) desc        
for xml path('')),1,1,'')),'~')     
end
GO
/****** Object:  StoredProcedure [dbo].[uspRetornaBoletaPorTicket]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspRetornaBoletaPorTicket]
@ResumenId varchar(80)
as
begin
declare @FechaEmision date
declare @Dia int,@Mes int,@ANNO int
set @FechaEmision=(select top 1 r.FechaReferencia from ResumenBoletas r where r.ResumenId=@ResumenId)
set @Dia=DAY(@FechaEmision)
set @Mes=MONTH(@FechaEmision)
set @ANNO=YEAR(@FechaEmision)
update ResumenBoletas
set MensajeSunat='NO SE GENERO EL TICKET DE RESPUESTA DE SUNAT'
where ResumenId=@ResumenId
update DocumentoVenta
set EstadoSunat='PENDIENTE'
WHERE (DAY(DocuEmision)=@Dia AND MONTH(DocuEmision)=@Mes and YEAR(DocuEmision)=@ANNO) and TipoCodigo='03'
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspRetornarBoletas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspRetornarBoletas]
@ResumenId numeric(38)
as
begin
declare @FechaEmision date
declare @Dia int,@Mes int,@ANNO int
set @FechaEmision=(select top 1 r.FechaReferencia from ResumenBoletas r where r.ResumenId=@ResumenId)
set @Dia=DAY(@FechaEmision)
set @Mes=MONTH(@FechaEmision)
set @ANNO=YEAR(@FechaEmision)
update DocumentoVenta
set EstadoSunat='PENDIENTE'
WHERE (DAY(DocuEmision)=@Dia AND MONTH(DocuEmision)=@Mes and YEAR(DocuEmision)=@ANNO) and TipoCodigo='03'
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspStockInsertaCsv]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspStockInsertaCsv]    
@detalle varchar(max)    
as    
begin    
Begin Transaction    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
Declare @Columna varchar(max)    
Declare @p1 int,@p2 int,    
        @p3 int,@p4 int,    
        @p5 int  
Declare @AlmacenId  numeric(20),@IdProducto  numeric(20),    
        @Cantidad  decimal(18,2),@ValorUM  decimal(18,4),    
        @Usuario varchar(80),@IdStock numeric(38)   
Fetch Next From Tabla INTO @Columna    
 While @@FETCH_STATUS = 0    
 begin    
Set @Columna= LTRIM(RTrim(@Columna))    
Set @p1 = CharIndex('|',@Columna,0)    
Set @p2=CharIndex('|',@Columna,@p1+1)    
Set @p3=CharIndex('|',@Columna,@p2+1)    
Set @p4=CharIndex('|',@Columna,@p3+1)    
Set @p5= Len(@Columna)+1  
  
Set @AlmacenId=convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))    
Set @IdProducto=convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-@p1-1))    
Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-@p2-1))    
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Columna,@p3+1,@p4-@p3-1))    
Set @Usuario=SUBSTRING(@Columna,@p4+1,@p5-@p4-1)  
  
IF NOT EXISTS(select u.IdProducto from   
Stock u   
where u.IdProducto=@IdProducto and u.AlmacenId=@AlmacenId)  
BEGIN

set @Cantidad=@Cantidad*@ValorUM
  
insert into Stock values(@AlmacenId,@IdProducto,@Cantidad,@ValorUM,'BUENO',@Usuario,GETDATE())   
set @IdStock=(select @@IDENTITY)  
  
insert into KardexAlmacen values(@IdStock,GETDATE(),'Nuevo Registro','Nuevo Registro',    
0,@Cantidad,0,@Cantidad,'INGRESO',@Usuario)  
  
END  
Fetch Next From Tabla INTO @Columna    
end    
 Close Tabla;    
 Deallocate Tabla;    
 Commit Transaction;    
 select 'true'    
end
GO
/****** Object:  StoredProcedure [dbo].[usptraeNewCodePro]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usptraeNewCodePro]
as
begin
select top 1 convert(numeric(38),substring(p.ProductoCodigo,4,LEN(p.ProductoCodigo)))+1 as Codigo 
from producto p 
where ProductoCodigo like'%MR00%' 
order by convert(numeric(38),substring(p.ProductoCodigo,4,LEN(p.ProductoCodigo))) desc
end
GO
/****** Object:  StoredProcedure [dbo].[uspTraerDV]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspTraerDV]  
@Valores varchar(max)  
as  
begin  
  
Declare @NotaId numeric(38),@DocuIdA numeric(38)  
Declare @a1 int,@a2 int  
Set @Valores= LTRIM(RTrim(@Valores))  
Set @a1 = CharIndex('|',@Valores,0)  
Set @a2= Len(@Valores)+1  
  
set @NotaId=SUBSTRING(@Valores,1,@a1-1)  
set @DocuIdA=SUBSTRING(@Valores,@a1+1,@a2-@a1-1)  
  
IF EXISTS(select top 1 NotaId   
from DocumentoVenta   
where NotaId=@NotaId and (TipoCodigo<>'07' and TipoCodigo <>'00'))  
begin  
Declare @lista varchar(max)  
Declare @Estado varchar(20),@Asociado varchar(40),  
@TipoCodigo char(2),@Serie char(4)  
Declare @DocuId numeric(38)  
declare @1 int,@2 int,@3 int,@4 int  
set @lista=(select top 1 d.DocuEstado+'|'+d.DocuAsociado+'|'+convert(char(2),d.TipoCodigo)+'|'+convert(varchar,d.DocuId)   
from DocumentoVenta d   
where NotaId=@NotaId and (TipoCodigo<>'07' and TipoCodigo <>'00'))  
Set @lista = LTRIM(RTrim(@lista))  
Set @1 = CharIndex('|',@lista,0)  
Set @2 = CharIndex('|',@lista,@1+1)  
Set @3 = CharIndex('|',@lista,@2+1)  
Set @4 = Len(@lista)+1  
set @Estado=SUBSTRING(@lista,1,@1-1)  
set @Asociado=SUBSTRING(@lista,@1+1,@2-@1-1)  
set @TipoCodigo=SUBSTRING(@lista,@2+1,@3-@2-1)  
set @DocuId=convert(numeric(38),SUBSTRING(@lista,@3+1,@4-@3-1))  
  
  
Declare @EstadoSunat varchar(40)  
  
set @EstadoSunat=isnull((select top 1 d.EstadoSunat  
from DocumentoVenta d  
where d.NotaId=@NotaId  
order by d.DocuId desc),'')  
  
if(@TipoCodigo='01')set @Serie='FZ01'  
else if(@TipoCodigo='03')set @Serie='BN01'  
--if(@Estado='ANULADO')select 'ANULADO'  
if(len(@Asociado)>0 and @DocuIdA=0)select 'CANJEADO'  
else  
begin  
Declare @Data varchar(max)  
Declare @NotaConcepto varchar(20)  
Declare @Entrega varchar(40)  
Declare @FormaPago varchar(40)  
Declare @NotaEstado varchar(40)  
declare @p1 int,@p2 int,@p3 int,@p4 int   
set @Data=(select top 1 NotaConcepto+'|'+n.NotaEntrega+'|'+n.NotaFormaPago+'|'+n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)  
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3= CharIndex('|',@Data,@p2+1)  
Set @p4 = Len(@Data)+1  
set @NotaConcepto=SUBSTRING(@Data,1,@p1-1)  
set @Entrega=SUBSTRING(@Data,@p1+1,@p2-@p1-1)  
set @FormaPago=SUBSTRING(@Data,@p2+1,@p3-@p2-1)  
set @NotaEstado=SUBSTRING(@Data,@p3+1,@p4-@p3-1)  
select  
isnull((select STUFF((select top 1'¬'+d.DocuCondicion+'|'+d.EstadoSunat+'|'+d.DocuDocumento+'|'+  
d.DocuSerie+'-'+d.DocuNumero+'|'+convert(varchar,d.ClienteId)+'|'+  
c.ClienteRazon+'|'+c.ClienteRuc+'|'+c.ClienteDni+'|'+c.ClienteDireccion+'|'+  
(Convert(char(10),d.DocuEmision,103))+'  '+d.DocuUsuario+'|'+  
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)+'|'+convert(varchar,d.CompaniaId)+'|'+  
(select dbo.genenerarNroFactura(@Serie,d.CompaniaId,'NOTA DE CREDITO'))+'|'+  
@Entrega+'|'+@FormaPago+'|'+@NotaEstado+'|'+convert(varchar,d.NotaId)+'|'+  
convert(varchar,d.DocuId)+'|'+@Serie+'|'+co.CompaniaRazonSocial+'|'+co.CompaniaComercial+'|'+  
co.CompaniaRUC+'|'+co.CompaniaUserSecun+'|'+co.ComapaniaPWD+'|'+co.CompaniaPFX+'|'+  
co.CompaniaClave+'|'+co.CompaniaEmail+'|'+co.CompaniaDireccion+'|'+co.CompaniaTelefono+'|'+  
co.CompaniaNomUBG+'|'+co.CompaniaCodigoUBG+'|'+co.CompaniaDistrito+'|'+co.CompaniaDirecSunat+'|'+  
CONVERT(VarChar(50), cast((n.NotaMovilidad+n.NotaAdicional) as money ),1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuGravada as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuDescuento as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuIgv as money ), 1)  
from DocumentoVenta d  
inner join NotaPedido n  
on n.NotaId=d.NotaId  
inner join Cliente c  
on c.ClienteId=d.ClienteId  
inner join Compania co  
on co.CompaniaId=d.CompaniaId  
where d.NotaId=@NotaId and (TipoCodigo<>'07' and TipoCodigo <>'00')  
for xml path('')),1,1,'')),'~')+'['+  
'Cantidad|UM|Descripcion|Precio|Importe|DetalleId|IdProducto|valorUM|PrecioSunat|IGVPrecio|ImporteSunat|Codigo|Linea|CodSunat¬103|100|350|110|115|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+  
d.DetalleUM+'|'+p.ProductoNombre+' '+p.ProductoMarca+'|'+  
CONVERT(VarChar(50), cast(d.DetallPrecio as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+  
convert(varchar,d.DetalleNotaId)+'|'+convert(varchar,d.IdProducto)+'|'+  
convert(varchar,d.ValorUM)+'|'+  
convert(varchar,convert(decimal(18,6),d.DetallPrecio/1.18))+'|'+  
convert(varchar,(convert(decimal(18,6),d.DetallPrecio/1.18)* d.DetalleCantidad)*0.18)+'|'+  
convert(varchar,convert(decimal(18,6),d.DetallPrecio/1.18)* d.DetalleCantidad) +'|'+  
p.ProductoCodigo+'|'+s.NombreSublinea+'|'+s.CodigoSUNAT  
from DetalleDocumento d  
inner join Producto p  
on p.IdProducto=d.IdProducto  
inner join Sublinea s  
on s.IdSubLinea=p.IdSubLinea  
where DocuId=@DocuId  
order by d.DetalleId asc  
for xml path('')),1,1,'')),'~')  
end  
end  
else  
begin  
select 'NO EXISTE'  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspTraerGastosA]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspTraerGastosA]
@Data varchar(max)
as
begin
Declare @CajaId nvarchar(40),@CajaIdB nvarchar(40)
Declare @p1 int,@p2 int
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = Len(@Data)+1
Set @CajaId=SUBSTRING(@Data,1,@p1-1)
Set @CajaIdB=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Declare @Monto decimal(18,2)
set @Monto=isnull((select SUM(d.DetalleMonto)
FROM MAYOLICA.dbo.CajaDetalle d
WHERE d.CajaId=@CajaIdB AND d.NotaId<>'0' AND d.DetalleMovimiento='INGRESO'),0)
update CajaDetalle 
set DetalleMonto=@Monto
where CajaId=@CajaId and DetalleConcepto='VENTA TOTAL DE MAYOLICA'
update MAYOLICA.dbo.Caja
set  CajaIngresos=@Monto,CajaTotal=@Monto
where CajaId=@CajaIdB
Select
isnull((select STUFF((select '¬'+ c.DetalleConcepto+'|'+
case when c.DetalleMonto<=0 then
''
else CONVERT(VarChar(max),cast(c.DetalleMonto as money ), 1) end +'|'+
c.Estado+'|'+CONVERT(varchar,c.DetalleId)+'|S'
from CajaDetalle c
where (CajaId=@CajaId and NotaId='0') and c.DetalleMovimiento='SALIDA'
order by c.DetalleId asc
FOR XML path ('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ c.DetalleConcepto+'|'+
case when c.DetalleMonto<=0 then
''
else CONVERT(VarChar(max),cast(c.DetalleMonto as money ), 1) end +'|'+
c.Estado+'|'+CONVERT(varchar,c.DetalleId)+'|I'
from CajaDetalle c
where (CajaId=@CajaId and NotaId='0')and c.DetalleMovimiento='INGRESO'
order by c.DetalleId asc
FOR XML path ('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+
CONVERT(VarChar(50), cast(SUM(d.DetalleMonto) as money ), 1)
FROM Mayolica.dbo.CajaDetalle d
WHERE d.CajaId=@CajaIdB AND d.NotaId<>'0' AND d.DetalleMovimiento='TARJETA'
for xml path('')),1,1,'')),'0.00')+'['+
isnull((select STUFF((select '¬'+
CONVERT(VarChar(50), cast(SUM(d.DetalleMonto) as money ), 1)
FROM Mayolica.dbo.CajaDetalle d
WHERE d.CajaId=@CajaIdB AND d.NotaId<>'0' AND d.DetalleMovimiento='DEPOSITO'
for xml path('')),1,1,'')),'0.00')+'['+
CONVERT(VarChar(max),cast(@Monto as money ), 1)
end
GO
/****** Object:  StoredProcedure [dbo].[usptraerIdCaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usptraerIdCaja]
as
begin
select isnull((select stuff((select '¬'+ convert(varchar,c.CajaId)+
'|'+CONVERT(VarChar(50), cast(c.MontoIniSOl as money), 1)  
from Caja c 
where c.CajaEstado='ACTIVO' 
order by c.CajaId desc 
for xml path('')),1,1,'')),'0|0.00')+'['+
isnull((select stuff((select '¬'+ CONVERT(VarChar(50), cast(m.Monto as money), 1) 
from MontoMaximo m
for xml path('')),1,1,'')),'0')
end
GO
/****** Object:  StoredProcedure [dbo].[uspTraerNotaEli]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspTraerNotaEli]
@NotaId varchar(38)
as
begin
select
isnull((select stuff((SELECT '¬'+
co.CompaniaRazonSocial+'|'+
n.NotaConcepto+'|'+
n.NotaSerie+'-'+n.NotaNumero+'|'+
n.NotaCondicion+'|'+
n.NotaFormaPago+'|'+
n.NotaEntrega+'|'+
(Convert(char(10),n.NotaFechaPago,103))+'|'+  
c.ClienteRazon+'|'+
c.ClienteRuc+'|'+c.ClienteDni+'|'+
c.ClienteDespacho+'|'+
c.ClienteTelefono+'|'+
n.NotaEstado+'|'+
convert(varchar,n.NotaFecha,103)+' '+SUBSTRING(convert(varchar,n.NotaFecha,114),1,8)+'|'+ 
n.NotaUsuario+'|'+
convert(varchar,n.FechaEdita)+'|'+
CONVERT(VarChar(50),cast(n.NotaSubtotal as money ), 1)+'|'+
CONVERT(VarChar(50),cast(n.NotaMovilidad as money ), 1)+'|'+
CONVERT(VarChar(50),cast(n.NotaDescuento as money ), 1)+'|'+
CONVERT(VarChar(50),cast(n.NotaAdicional as money ), 1)+'|'+
CONVERT(VarChar(50),cast(n.NotaTotal as money ), 1)+'|'+
CONVERT(VarChar(50),cast(n.NotaAcuenta as money ), 1)+'|'+
CONVERT(VarChar(50),cast(n.NotaSaldo as money ), 1)+'|'+
convert(varchar,n.ICBPER)+'|'+
CONVERT(VarChar(50),cast(n.NotaPagar as money ), 1)+'|'+
n.NotaDocu
from NotaPedido n
inner join Cliente c
on c.ClienteId=n.ClienteId
inner join Compania co
on co.CompaniaId=n.CompaniaId
where n.NotaId=@NotaId
for xml path('')),1,1,'')),'~')+'['+
'Cantidad|UM|Descripcion|PrecioUni|Importe¬100|100|100|100|100¬String|String|String|String|String¬'+      
isnull((select stuff((SELECT '¬'+ CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+      
d.DetalleUm+'|'+      
d.DetalleDescripcion+'|'+     
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+      
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)
from DetallePedido d        
where d.NotaId=@NotaId      
order by d.DetalleId asc      
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usptraerPedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usptraerPedido]    
@Data varchar(max)    
as     
begin  
Declare @NotaId numeric(38),@AlmacenId int  
Declare @a1 int,@a2 int  
Set @Data= LTRIM(RTrim(@Data))  
Set @a1 = CharIndex('|',@Data,0)  
Set @a2= Len(@Data)+1  
  
set @NotaId=convert(numeric(38),SUBSTRING(@Data,1,@a1-1))  
set @AlmacenId=convert(int,SUBSTRING(@Data,@a1+1,@a2-@a1-1))  
    
IF EXISTS(select top 1 n.NotaId       
from NotaPedido n    
where n.NotaId=@NotaId and n.NotaConcepto='MERCADERIA' and (n.NotaDocu<>'PROFORMA' and n.NotaEstado<>'ANULADO'))    
BEGIN    
select      
isnull((select STUFF((select top 1'¬'+    
convert(varchar,n.NotaId)+'|'+n.NotaDocu+'|'+    
c.ClienteRazon+'|'+n.NotaSerie+'-'+n.NotaNumero+'|'+    
n.NotaUsuario    
    
FROM NotaPedido n    
inner join Cliente c    
on c.ClienteId=n.ClienteId    
where n.NotaId=@NotaId    
    
for xml path('')),1,1,'')),'~')+'['+        
'IdSock|IdPro|Cantidad|CantInicial|UM|Descripcion|STOCK|ValorUM|Imagen¬80|80|80|80|80|80|80|80|100¬String|String|String|String|String|String|String|String|String¬'+        
isnull((select STUFF ((select '¬'+        
convert(varchar,s.IdStock)+'|'+        
convert(varchar,d.IdProducto)+'||'+    
CONVERT(VarChar(50),cast(d.DetalleCantidad as money ), 1)+'|'+d.DetalleUm+'|'+        
p.ProductoNombre+' '+p.ProductoMarca+'|'+CONVERT(VarChar(50),cast(s.Cantidad as money ), 1)+'|'+    
convert(varchar,d.ValorUM)+'|'+p.ProductoImagen       
    
from DetallePedido d    
inner join Stock s    
on  s.IdProducto=d.IdProducto       
inner join Producto p        
on p.IdProducto=d.IdProducto          
where d.NotaId=@NotaId and s.AlmacenId=@AlmacenId  
    
for xml path('')),1,1,'')),'~')       
    
end    
else    
begin    
select 'NO EXISTE'    
end    
end
GO
/****** Object:  StoredProcedure [dbo].[uspTraerPFX]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspTraerPFX]  
@Data varchar(max)
as  
begin
Declare @CompaniaId int,@Serie nvarchar(4)  
Declare @pos1 int,@pos2 int
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = Len(@Data)+1
Set @CompaniaId =convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @Serie=SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1)
SELECT   
isnull((select STUFF ((select top 1'¬'+convert(varchar,c.CompaniaId)+'|'+c.CompaniaRazonSocial+'|'+  
c.CompaniaComercial+'|'+c.CompaniaRUC+'|'+c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+c.CompaniaPFX+'|'+c.CompaniaClave+'|'+  
convert(varchar,dbo.genenerarNroFactura(@Serie,@CompaniaId,'FACTURA'))+'|'+c.CompaniaEmail+'|'+c.CompaniaDireccion+'|'+  
c.CompaniaTelefono+'|'+CompaniaNomUBG+'|'+CompaniaCodigoUBG+'|'+CompaniaDistrito+'|'+CompaniaDirecSunat  
FROM Compania c  
where c.CompaniaId=@CompaniaId  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[usptraerSecuenciaResumen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usptraerSecuenciaResumen]  
@CompaniaId varchar(20)  
as  
begin  
Declare @COUNT INT  
set @COUNT=(select COUNT(*) from ResumenBoletas
where CompaniaId =@CompaniaId 
)  
if(@COUNT=0)  
begin  
select '1'  
end  
else  
begin  
select top 1 convert(varchar,Secuencia+1)  
from ResumenBoletas where CompaniaId =@CompaniaId  
order by Secuencia desc  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspTrunks]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspTrunks]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int
Declare @fechainicio date,
        @fechafin date
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 =Len(@Data)+1
Set @fechainicio=convert(date,SUBSTRING(@Data,1,@p1-1))
Set @fechafin=convert(date,SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Declare @Aviso int
set @Aviso=isnull((select COUNT(DetalleId) 
from EnvioTrunsk e
where Fecha=@fechafin),0)
if(@Aviso=0)
begin
Select
'DocuId|Compania|NotaId|FechaEmision|Documento|Numero|RazonSocial|RUC|DNI|Direccion|Usuario|SubTotal|IGV|Total¬100|90|100|120|120|140|350|100|90|400|160|120|120|120¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+Convert(varchar,d.DocuId)+'|'+
convert(varchar,d.CompaniaId)+'|'+convert(varchar,d.NotaId)+'|'+
(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.DocuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+
c.ClienteRuc+'|'+c.ClienteDni+'|'+
case when(len(c.ClienteDespacho)=0)then
c.ClienteDireccion else c.ClienteDespacho end+'|'+d.DocuUsuario+'|'+
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DocuIgv as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
where d.DocuEstado<>'ANULADO' and d.DocuTotal >=200 and d.ClienteId<>47 and (d.TipoCodigo='03' or d.TipoCodigo='01')and 
(Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)
order by d.DocuEmision,d.DocuSerie,d.DocuNumero asc
for xml path('')),1,1,'')),'~')+'['+
'DetalleId|DocuId|Cantidad|UM|Descripcion|PrecioUni|Importe¬100|100|100|100|350|115|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+CONVERT(varchar,d.DetalleId)+'|'+convert(varchar,d.DocuId)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+DetalleUM+'|'+
p.ProductoNombre+' '+p.ProductoMarca+'|'+
CONVERT(VarChar(50), cast(d.DetallPrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)
from DetalleDocumento d
inner join Producto p
on p.IdProducto=d.IdProducto
inner join DocumentoVenta do
on do.DocuId=d.DocuId
where do.DocuEstado<>'ANULADO' and do.DocuTotal >=200 and do.ClienteId<>47 and(do.TipoCodigo='03' or do.TipoCodigo='01')and(Convert(char(10),do.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)
order by do.DocuEmision,do.DocuSerie,do.DocuNumero asc
for xml path('')),1,1,'')),'~')
end
else
begin
Select
'DocuId|Compania|NotaId|FechaEmision|Documento|Numero|RazonSocial|RUC|DNI|Direccion|Usuario|SubTotal|IGV|Total¬100|90|100|120|120|140|350|100|90|400|160|120|120|120¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
'~[DetalleId|DocuId|Cantidad|UM|Descripcion|PrecioUni|Importe¬100|100|100|100|350|115|120¬String|String|String|String|String|String|String¬'+'~'
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspUsuarioBaja]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspUsuarioBaja]
as
begin
select
'Id|Usuario|AREA|FechaBaja|Estado¬90|260|250|100|100¬String|String|String|String|String¬'+
isnull((select stuff((SELECT '¬'+ convert(varchar,u.UsuarioID)+'|'+
u.UsuarioAlias+'|'+a.AreaNombre+'|'+
p.PersonalBajaFecha+'|'+p.PersonalEstado
from Usuarios u
inner join Personal P
on p.PersonalId=u.PersonalId
inner join Area a
on a.AreaId=p.AreaId
where u.UsuarioEstado='DESACTIVO'
order by P.PersonalNombres+' '+P.PersonalApellidos asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspUtilitario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspUtilitario]
as
begin
select 
'TABLAS|TABLE['+
isnull((select STUFF((select '¬'+s.name+'|'+s.name
from sys.tables s
order by s.name asc
for XMl path('')),1,1,'')),'~')+'['+
'TYPO|COLUMN_NAME|DATA_TYPE|TAMANO¬0|220|150|115¬'+
isnull((select STUFF((select '¬'+ I.DATA_TYPE+'|'+I.COLUMN_NAME+'|'+I.DATA_TYPE+'|'+
       isnull(convert(varchar,case when CHARACTER_MAXIMUM_LENGTH is null then
       NUMERIC_PRECISION
       else CHARACTER_MAXIMUM_LENGTH end),'0')+','+isnull(convert(varchar,NUMERIC_SCALE),'0')+'|'+
       I.TABLE_NAME
FROM   INFORMATION_SCHEMA.COLUMNS I
order by TABLE_NAME asc
for XMl path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidaEdicionAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspValidaEdicionAlmacen]
@NotaId varchar(80)
as
begin
Select
isnull((select STUFF((select '¬' +convert(varchar,s.IdProducto)+'|'+s.ESTADO
from DetalleStock s
INNER JOIN DetallePedido d
on d.IdProducto=s.IdProducto
where s.NotaId=@NotaId
group by s.IdProducto,s.ESTADO
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidarAlmacenero]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspValidarAlmacenero]
@Codigo varchar(80)        
as        
begin        

Declare @Data varchar(300)
  
set @Data=isnull((select STUFF ((select top 1 '¬'+convert(varchar,p.PersonalId)+'|'+CONVERT(varchar,p.AreaId)+'|'+
SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)
from Personal p 
where p.PersonalCodigo=@Codigo and p.PersonalEstado='ACTIVO' 
for xml path('')),1,1,'')),'')
  

if(@Data='')
begin
select 'false'
end
else
begin
Declare @PersonalId int,
        @AreaID int,@Personal varchar(80)
        
Declare @pos1 int,@pos2 int, @pos3 int   
  
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)

Set @pos3 = Len(@Data)+1

Set @PersonalId=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @AreaID=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @Personal=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
		

Declare @UsuarioId int, 
		@Asistencia int
		 
set @UsuarioId=isnull((select top 1 u.UsuarioID from Usuarios u        
inner join Personal p        
on p.PersonalId=u.PersonalId        
where p.PersonalCodigo=@Codigo and u.UsuarioEstado='ACTIVO' and p.AreaId<>6),0)  


if(@UsuarioId=0)        
begin    
set @Asistencia=(select COUNT(1)from Asistencia a 
inner join Personal p
on p.PersonalId=a.PersonalId               
where a.PersonalId=@PersonalId and (Day(a.Fecha)=Day(GETDATE()) and Month(a.Fecha)=MONTH(GETDATE()) and year(a.Fecha)=year(GETDATE())))          
if(@Asistencia=0 and @AreaId<>6)          
begin          
Select 'NO ASISTIO'          
end          
else  
begin     
select @Personal        
end        
end       
else        
begin        
Declare @cajero int        
set @cajero=(select isnull((select STUFF ((select top 1 '¬'+convert(varchar,c.UsuarioId)        
from Caja c        
order by c.CajaId desc        
for xml path('')),1,1,'')),0))        
if(@cajero=@UsuarioId)        
begin        
select 'Cajero'        
end        
else        
begin       
set @Asistencia=(select COUNT(1)from Asistencia a 
inner join Personal p
on p.PersonalId=a.PersonalId               
where a.PersonalId=@PersonalId and (Day(a.Fecha)=Day(GETDATE()) and Month(a.Fecha)=MONTH(GETDATE()) and year(a.Fecha)=year(GETDATE())))         
if(@Asistencia=0 and @AreaId<>6)        
begin          
Select 'NO ASISTIO'          
end          
else          
begin

if(@AreaId=8) 
begin
select 'Almacen' 
end
else
begin          
select @Personal
end                
end       
end      
end  
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidarApertura]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspValidarApertura]      
as      
begin      
Declare @BoletaPen int      
Declare @ConsultaPen int       
Declare @AnuladosPen int      
Declare @Aviso varchar(40)      
Declare @ConsultaError int       
set @BoletaPen=(select top 1 count(DocuId) from DocumentoVenta      
where TipoCodigo='03'and EstadoSunat='PENDIENTE'      
and DocuEmision<convert(date,GETDATE()))      
set @ConsultaPen=(select COUNT(ResumenId) from ResumenBoletas      
where CodigoSunat='')      
set @AnuladosPen=(select COUNT(d.DocuId) from DocumentoVenta d      
where d.TipoCodigo='03'and(DocuEstado='ANULADO' and d.EstadoSunat='ENVIADO'))      
set @ConsultaError=(select COUNT(ResumenId) from ResumenBoletas      
where CodigoSunat='env:Server' or CodigoSunat='env:Client')

IF EXISTS(select f.Fecha from Feriados f
where f.Fecha=convert(date,GETDATE()))
begin

set @Aviso='true'
select @Aviso   

end  

else
begin

if(@BoletaPen>0)      
begin      
set @Aviso='BOLETA'      
END      
else if(@AnuladosPen>0)      
begin      
set @Aviso='ANULADOS'      
end      
else if(@ConsultaPen>0)      
begin      
set @Aviso='CONSULTA'      
end      
else if(@ConsultaError>0)      
begin      
set @Aviso='ERROR'      
end      
else      
begin      
--Declare @Dia varchar(40)      
--set @Dia=(select dbo.diaNombre(GETDATE()))      
--if(@Dia='Domingo')      
--begin      
set @Aviso='true'      
end      

 select @Aviso      
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidarCajero]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspValidarCajero]        
@Codigo varchar(80)        
as        
begin        

Declare @Data varchar(300)
  
set @Data=isnull((select STUFF ((select top 1 '¬'+convert(varchar,p.PersonalId)+'|'+CONVERT(varchar,p.AreaId)+'|'+
SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)
from Personal p 
where p.PersonalCodigo=@Codigo and p.PersonalEstado='ACTIVO' 
for xml path('')),1,1,'')),'')
  

if(@Data='')
begin
select 'false'
end
else
begin
Declare @PersonalId int,
        @AreaID int,@Personal varchar(80)
        
Declare @pos1 int,@pos2 int, @pos3 int   
  
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)

Set @pos3 = Len(@Data)+1

Set @PersonalId=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @AreaID=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @Personal=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
		

Declare @UsuarioId int, 
		@Asistencia int
		 
set @UsuarioId=isnull((select top 1 u.UsuarioID from Usuarios u        
inner join Personal p        
on p.PersonalId=u.PersonalId        
where p.PersonalCodigo=@Codigo and u.UsuarioEstado='ACTIVO' and p.AreaId<>6),0)  


if(@UsuarioId=0)        
begin    
set @Asistencia=(select COUNT(1)from Asistencia a 
inner join Personal p
on p.PersonalId=a.PersonalId               
where a.PersonalId=@PersonalId and (Day(a.Fecha)=Day(GETDATE()) and Month(a.Fecha)=MONTH(GETDATE()) and year(a.Fecha)=year(GETDATE())))          
if(@Asistencia=0 and @AreaId<>6)          
begin          
Select 'NO ASISTIO'          
end          
else  
begin     
select @Personal        
end        
end       
else        
begin        
Declare @cajero int        
set @cajero=(select isnull((select STUFF ((select top 1 '¬'+convert(varchar,c.UsuarioId)        
from Caja c        
order by c.CajaId desc        
for xml path('')),1,1,'')),0))        
if(@cajero=@UsuarioId)        
begin        
select 'Cajero'        
end        
else        
begin       
set @Asistencia=(select COUNT(1)from Asistencia a 
inner join Personal p
on p.PersonalId=a.PersonalId               
where a.PersonalId=@PersonalId and (Day(a.Fecha)=Day(GETDATE()) and Month(a.Fecha)=MONTH(GETDATE()) and year(a.Fecha)=year(GETDATE())))         
if(@Asistencia=0 and @AreaId<>6)        
begin          
Select 'NO ASISTIO'          
end          
else          
begin    
          
select @Personal
                
end       
end      
end  
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidarCajeroB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspValidarCajeroB]    
@Codigo varchar(80)        
as        
begin        

Declare @Data varchar(300)
  
set @Data=isnull((select STUFF ((select top 1 '¬'+convert(varchar,p.PersonalId)+'|'+CONVERT(varchar,p.AreaId)+'|'+
SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)
from Personal p 
where p.PersonalCodigo=@Codigo and p.PersonalEstado='ACTIVO' 
for xml path('')),1,1,'')),'')
  

if(@Data='')
begin
select 'false'
end
else
begin
Declare @PersonalId int,
        @AreaID int,@Personal varchar(80)
        
Declare @pos1 int,@pos2 int, @pos3 int   
  
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)

Set @pos3 = Len(@Data)+1

Set @PersonalId=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @AreaID=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @Personal=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
		
Declare  @Asistencia int
             
set @Asistencia=(select COUNT(1)from Asistencia a 
inner join Personal p
on p.PersonalId=a.PersonalId               
where a.PersonalId=@PersonalId and (Day(a.Fecha)=Day(GETDATE()) and Month(a.Fecha)=MONTH(GETDATE()) and year(a.Fecha)=year(GETDATE())))         
if(@Asistencia=0 and @AreaId<>6)        
begin          
Select 'NO ASISTIO'          
end          
else          
begin         
select @Personal               
end       
end      
end  
GO
/****** Object:  StoredProcedure [dbo].[uspValidaSalidaAlmacen]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[uspValidaSalidaAlmacen]
@UsuarioID INT
as
Select
isnull((select STUFF((select '¬' +convert(varchar,t.IdProducto)
from TemporalVenta t
INNER join Stock S
ON S.IdProducto=T.IdProducto
INNER JOIN Producto P
ON P.IdProducto=S.IdProducto
where t.UsuarioID=@UsuarioID and(t.IdProducto NOT IN (select a.IdProducto 
from TemporalAlmacen a
where a.UsuarioId=@UsuarioID and a.Concepto='S')and p.ProductoCantidad<=0)
order by t.temporalId asc
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[uspValidaUsuario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspValidaUsuario]          
@Data varchar(max)          
as          
begin          
Declare @p1 int,@p2 int,          
        @p3 int          
Declare @Usuario varchar(150),          
        @Clave varchar(150),          
        @Maquina VARCHAR(140)           
Set @Data = LTRIM(RTrim(@Data))          
Set @p1 = CharIndex('|',@Data,0)          
Set @p2 = CharIndex('|',@Data,@p1+1)          
Set @p3 = Len(@Data)+1          
Set @Usuario=SUBSTRING(@Data,1,@p1-1)          
Set @Clave=SUBSTRING(@Data,@p1+1,@p2-@p1-1)          
set @Maquina=SUBSTRING(@Data,@p2+1,@p3-@p2-1)          
SELECT           
isnull((select STUFF ((select top 1 '¬'+  
convert(varchar,U.UsuarioID)+'|'+  
convert(varchar,p.PersonalId)+'|'+  
a.AreaNombre+'|'+          
(SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1))+'|'+          
convert(varchar,p.CompaniaId)+'|'+  
c.CompaniaRazonSocial+'|'+  
c.CompaniaRUC+'|'+  
u.UsuarioSerie+'|'+  
convert(varchar(1),u.EnviaBoleta)+'|'+          
convert(varchar(1),u.EnviarFactura)+'|'+  
c.CompaniaComercial+'|'+convert(varchar,c.ICBPER)+'|'+  
convert(varchar,c.DescuentoMax)+'|'+  
CONVERT(varchar,c.EfectivoMax)+'|'+     
c.CorreoSGO+'|'+  
c.PasswordCorreo+'|'+  
c.CorreosAdmin+'|'+  
        
case when (CONVERT(date,GETDATE())>=(c.RenovacionOSE)) then        
'VENCIDO'        
else        
case when ((dateadd(DAY,-6,c.RenovacionOSE))<= CONVERT(date,GETDATE())) then        
'POR VENCER'        
else        
'PREMIUM' end end+'|'+(Convert(char(10),c.RenovacionOSE,103))+'|'+      
      
case when (CONVERT(date,GETDATE())>=(c.RenovacionFirma)) then        
'VENCIDO'        
else        
case when ((dateadd(DAY,-6,c.RenovacionFirma))<= CONVERT(date,GETDATE())) then        
'POR VENCER'        
else        
'PREMIUM' end end+'|'+(Convert(char(10),c.RenovacionFirma,103)) +'|'+       
        
        
case when (CONVERT(date,GETDATE())>=(c.RenovacionSome)) then        
'VENCIDO'        
else        
case when ((dateadd(DAY,-6,c.RenovacionSome))<= CONVERT(date,GETDATE())) then        
'POR VENCER'        
else        
'PREMIUM' end end+'|'+(Convert(char(10),c.RenovacionSome,103))  
         
FROM Usuarios U          
inner join Personal p          
on p.PersonalId=U.PersonalId          
inner join Area a          
on a.AreaId=p.AreaId          
inner join Compania c          
on c.CompaniaId=p.CompaniaId          
where U.UsuarioAlias=@Usuario AND dbo.desincrectar(U.UsuarioClave)=@Clave and Usuarioestado ='ACTIVO'and p.PersonalEstado='ACTIVO'          
for xml path('')),1,1,'')),'~')+'['+          
isnull((select STUFF ((select top 1 '¬'+convert(varchar,m.EstadoC)          
from MAQUINAS m          
where m.Maquina=@Maquina and m.EstadoC=1          
for xml path('')),1,1,'')),'')+'['+          
isnull((select STUFF ((select top 1 '¬'+convert(varchar,c.UsuarioId)          
from Caja c          
order by c.CajaId desc          
for xml path('')),1,1,'')),'')+'['+          
isnull((select STUFF ((select top 1 '¬'+convert(varchar,m.Estado)          
from MAQUINAS m          
where m.Maquina=@Maquina          
for xml path('')),1,1,'')),'')          
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidaUsuarioWeb]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspValidaUsuarioWeb]
@Data VARCHAR(MAX)
AS
BEGIN
    DECLARE @p1 INT, @p2 INT

    DECLARE @Usuario VARCHAR(150),
            @Clave VARCHAR(150)

    SET @Data = LTRIM(RTRIM(@Data))

    SET @p1 = CHARINDEX('|', @Data, 0)
    SET @p2 = LEN(@Data) + 1

    SET @Usuario = SUBSTRING(@Data, 1, @p1 - 1)
    SET @Clave   = SUBSTRING(@Data, @p1 + 1, @p2 - @p1 - 1)

    SELECT
    ISNULL((
        SELECT STUFF((
            SELECT TOP 1
                '¬' +
                CONVERT(VARCHAR, U.UsuarioID) + '|' +
                CONVERT(VARCHAR, p.PersonalId) + '|' +
                ISNULL(a.AreaNombre, '') + '|' +
                (
                    ISNULL(SUBSTRING(p.PersonalNombres + ' ', 1, CHARINDEX(' ', p.PersonalNombres + ' ') - 1), '') + ' ' +
                    ISNULL(SUBSTRING(p.PersonalApellidos + ' ', 1, CHARINDEX(' ', p.PersonalApellidos + ' ') - 1), '')
                ) + '|' +
                CONVERT(VARCHAR, p.CompaniaId) + '|' +

                ISNULL(c.CompaniaRazonSocial, '') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.DescuentoMax), '0') + '|' +

                ISNULL(c.CompaniaRUC, '') + '|' +
                ISNULL(c.CompaniaNomUBG, '') + '|' +
                ISNULL(c.CompaniaComercial, '') + '|' +
                ISNULL(c.CompaniaDirecSunat, '') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.EfectivoMax), '0') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.TarjetaPorcentaje), '0') + '|' +
                ISNULL(CONVERT(VARCHAR(20), c.ICBPER), '0') + '|' +
                ISNULL(CONVERT(VARCHAR(1), c.BoletaPorLote), '0') + '|' +

                ISNULL(c.CorreoSGO, '') + '|' +
                ISNULL(c.PasswordCorreo, '') + '|' +
                ISNULL(c.CorreosAdmin, '')

            FROM Usuarios U
            INNER JOIN Personal p ON p.PersonalId = U.PersonalId
            INNER JOIN Area a ON a.AreaId = p.AreaId
            INNER JOIN Compania c ON c.CompaniaId = p.CompaniaId
            WHERE U.UsuarioAlias = @Usuario
              AND dbo.desincrectar(U.UsuarioClave) = @Clave
              AND U.UsuarioEstado = 'ACTIVO'
              AND p.PersonalEstado = 'ACTIVO'
            FOR XML PATH('')
        ), 1, 1, '')
    ), '~')
END
GO
/****** Object:  StoredProcedure [dbo].[uspVentanaStocks]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspVentanaStocks]      
@Data varchar(max)      
as      
Begin      
Declare @p1 int,@p2 int,  
        @p3 int--,@p4 int      
Declare @IdProducto numeric(38),      
        @Cantidad decimal(18,2),  
        @Unidad varchar(40)--,  
        --@AvisoNB nvarchar(1)            
Declare @Stock decimal(18,2),      
        @Diferencia decimal(18,2),  
        @Aviso varchar(max)  
              
Set @Data = LTRIM(RTrim(@Data))      
Set @p1 = CharIndex('|',@Data,0)      
Set @p2 = CharIndex('|',@Data,@p1+1)  
--Set @p3 = CharIndex('|',@Data,@p2+1)     
Set @p3= Len(@Data)+1      
  
Set @IdProducto =convert(int,SUBSTRING(@Data,1,@p1-1))      
      
if(SUBSTRING(@Data,@p1+1,@p2-@p1-1)='')set @Cantidad=0      
else Set @Cantidad=convert(decimal(18,2),SUBSTRING(@Data,@p1+1,@p2-@p1-1))      
      
Set @Unidad=SUBSTRING(@Data,@p2+1,@p3-@p2-1)  
--Set @AvisoNB=SUBSTRING(@Data,@p3+1,@p4-@p3-1)   
      
set @Aviso=isnull((select top 1 convert(varchar,p.ProductoCantidad)     
from Producto p     
where p.IdProducto=@IdProducto and p.ProductoUM=@Unidad),'false')      
      
if(@Aviso='false')      
begin      
set @Stock=isnull((select top 1 cast((p.ProductoCantidad/u.ValorUM) as decimal(18,2))     
from Producto p      
inner join UnidadMedida u      
on p.IdProducto=u.IdProducto      
where p.IdProducto=@IdProducto and u.UMDescripcion=@Unidad),0)      
end      
else      
begin      
set @Stock=@Aviso      
end      
      
if(@Cantidad=0)set @Diferencia=0      
else      
begin      
if(@Stock<0)set @Diferencia=@Cantidad      
else set @Diferencia=@Cantidad-@Stock      
end  
--if(@AvisoNB='1')  
--begin  
  
--select      
--'IdStock|IdProducto|AlmacenNombre|Descripcion|Cantidad|Stock|UM|ValorUM¬80|80|230|80|110|120|120|80¬String|String|String|String|String|String|String|String¬'+      
--isnull((select STUFF ((select '¬'+convert(varchar,s.IdStock)+'|'+convert(varchar,s.IdProducto)+'|'+a.AlmacenNombre+'|'+      
--p.ProductoNombre+' '+p.ProductoMarca+'|'+CONVERT(VarChar(max),cast(@Diferencia as money ), 1)+'|'+      
--CONVERT(VarChar(max),cast(s.Cantidad as money ), 1)+'|'+p.ProductoUM+'|1'      
--from Stock s      
--inner join Producto p      
--on s.IdProducto=p.IdProducto      
--inner join Almacen a      
--on a.AlmacenId=s.AlmacenId      
--where s.IdProducto=@IdProducto      
--for xml path('')),1,1,'')),'~')+'¬'+  
    
--isnull((select STUFF ((select '¬'+convert(varchar,s.IdStock)+'|'+      
--convert(varchar,s.IdProducto)+'|'+a.AlmacenNombre+'|'+      
--p.ProductoNombre+' '+p.ProductoMarca+'|'+''+'|'+      
--CONVERT(VarChar(max), cast((s.Cantidad/u.ValorUM)as money ), 1)+'|'+      
--u.UMDescripcion+'|'+convert(varchar,u.ValorUM)      
--from Stock s      
--inner join Producto p      
--on s.IdProducto=p.IdProducto      
--inner join UnidadMedida u      
--on p.IdProducto=u.IdProducto      
--inner join Almacen a      
--on a.AlmacenId=s.AlmacenId      
--where s.IdProducto=@IdProducto      
--for xml path('')),1,1,'')),'~')+'¬'+  
  
--isnull((select STUFF ((select '¬'+convert(varchar,p.IdProducto)+'|'+  
--convert(varchar,P.IdProducto)+'|KM 19 TUPAC|'+      
--p.ProductoNombre+' '+p.ProductoMarca+'|'+CONVERT(VarChar(max),cast(@Diferencia as money ), 1)+'|'+      
--CONVERT(VarChar(max),cast(p.CantidadNB as money ), 1)+'|'+p.ProductoUM+'|1'      
--from Producto p  
--where p.IdProducto=@IdProducto         
--for xml path('')),1,1,'')),'~')+'['+  
--CONVERT(VarChar(50),cast(@Cantidad as money ), 1)+'|'+CONVERT(VarChar(50),cast(@Stock as money ), 1)+'|'+      
--CONVERT(VarChar(50),cast(@Diferencia as money ), 1)     
--end  
--else  
--begin    
select      
'IdStock|IdProducto|AlmacenNombre|Descripcion|Cantidad|Stock|UM|ValorUM¬80|80|230|80|110|120|120|80¬String|String|String|String|String|String|String|String¬'+      
isnull((select STUFF ((select '¬'+convert(varchar,s.IdStock)+'|'+convert(varchar,s.IdProducto)+'|'+a.AlmacenNombre+'|'+      
p.ProductoNombre+' '+p.ProductoMarca+'|'+CONVERT(VarChar(max),cast(@Diferencia as money ), 1)+'|'+      
CONVERT(VarChar(max),cast(s.Cantidad as money ), 1)+'|'+p.ProductoUM+'|1'      
from Stock s      
inner join Producto p      
on s.IdProducto=p.IdProducto      
inner join Almacen a      
on a.AlmacenId=s.AlmacenId      
where s.IdProducto=@IdProducto      
for xml path('')),1,1,'')),'~')+'¬'+      
isnull((select STUFF ((select '¬'+convert(varchar,s.IdStock)+'|'+      
convert(varchar,s.IdProducto)+'|'+a.AlmacenNombre+'|'+      
p.ProductoNombre+' '+p.ProductoMarca+'|'+''+'|'+      
CONVERT(VarChar(max), cast((s.Cantidad/u.ValorUM)as money ), 1)+'|'+      
u.UMDescripcion+'|'+convert(varchar,u.ValorUM)      
from Stock s      
inner join Producto p      
on s.IdProducto=p.IdProducto      
inner join UnidadMedida u      
on p.IdProducto=u.IdProducto      
inner join Almacen a      
on a.AlmacenId=s.AlmacenId      
where s.IdProducto=@IdProducto      
for xml path('')),1,1,'')),'~')+'['+  
CONVERT(VarChar(50),cast(@Cantidad as money ), 1)+'|'+CONVERT(VarChar(50),cast(@Stock as money ), 1)+'|'+      
CONVERT(VarChar(50),cast(@Diferencia as money ), 1)      
--end  
end
GO
/****** Object:  StoredProcedure [dbo].[validarDatos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[validarDatos]
@NotaId numeric(38)
as
begin
select a.NotaId,a.NotaEstado,a.Cantidad,isnull(b.Documento,0) as Emitidos,isnull(b.Acuenta,0)as Acuenta 
from 
(select n.NotaId,n.NotaEstado,
COUNT(IdDetalle) as Cantidad 
from DetalleGuia g 
inner join DetallePedido d 
on d.DetalleId=g.IdDetalle 
right join NotaPedido n
on n.NotaId=d.NotaId
where n.NotaId=@NotaId
group by n.NotaId,n.NotaEstado) a 
full join 
(select l.NotaId as NotaId,COUNT(l.NotaId) as Documento ,COUNT(l.DocuId) as Acuenta 
from DetaLiquidaVenta l
where l.NotaId=@NotaId
group by l.NotaId) b 
on a.NotaId=b.NotaId
end
GO
/****** Object:  StoredProcedure [dbo].[ventanaDeudas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ventanaDeudas]
as
begin
select n.NotaId as ID,c.ClienteRazon,c.ClienteRuc,(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))as DocuRegistro,
(Convert(char(10),n.NotaFechaPago,103)) as FechaPago,
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end Documento
,CONVERT(VarChar(50),cast(n.NotaSaldo as money ), 1) as SaldoDoc,CONVERT(VarChar(50),cast(n.NotaTarjeta as money ), 1) as Tarjeta,
CONVERT(VarChar(50),cast(n.NotaPagar as money ), 1) as Total,n.NotaId
from NotaPedido n
inner join Cliente c
on  c.ClienteId=n.ClienteId
where (n.NotaCondicion='CREDITO' and (n.NotaEstado<>'CANCELADO' and n.NotaEstado<>'ANULADO'))and n.NotaSaldo > 0
order by n.NotaId desc
end
GO
/****** Object:  StoredProcedure [dbo].[ventanaFacturas]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ventanaFacturas]@TipoCodigo varchar(40)
as
begin
select c.CompraId,p.ProveedorRazon,(Convert(char(10),c.CompraEmision,103)) as CompraEmision,substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Numero,c.CompraMoneda,c.CompraTipoCambio,CONVERT(VarChar(50),cast(c.CompraSaldo as money ), 1) as SaldoDoc,CONVERT(VarChar(50),cast(c.CompraTotal as money ), 1) as Total,
t.TipoDescripcion
from Compras c
inner join Proveedor p
on  c.ProveedorId=p.ProveedorId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where t.TipoCodigo=@TipoCodigo and c.CompraEstado='PENDIENTE DE PAGO'
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[ventanaLetras]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ventanaLetras]
as
begin
select d.DetalleId,l.LetraId,p.ProveedorRazon,(Convert(char(10),d.LetraVencimiento,103)) as Vencimiento,'LT '+d.LetraCanje as LetraCanje,
(Convert(char(10),l.LetraFechaGiro,103)) as FechaGiro,l.LetraMoneda,CONVERT(VarChar(50),cast(d.DetalleSaldo as money ), 1) as SaldoDoc,
CONVERT(VarChar(50),cast(d.DetalleMonto as money ), 1) as MontoDoc
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where d.DetalleEstado<>'TOTALMENTE PAGADO'
order by d.LetraVencimiento asc
end
GO
/****** Object:  StoredProcedure [web].[listaNotaPedido]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[listaNotaPedido]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[listaNotaPedido_web] @FechaInicio = @FechaInicio, @FechaFin = @FechaFin;
END
GO
/****** Object:  StoredProcedure [web].[listaNotaPedido_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[listaNotaPedido_web]
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @FechaInicio IS NULL OR @FechaFin IS NULL OR @FechaInicio > @FechaFin
    BEGIN
        SELECT '~' AS Resultado;
        RETURN;
    END;

    DECLARE @FechaFinExclusiva DATE;
    SET @FechaFinExclusiva = DATEADD(DAY, 1, @FechaFin);

    DECLARE @Sql NVARCHAR(MAX) = N'
    SELECT
        ISNULL(
            (
                SELECT STUFF(
                    (
                        SELECT
                            ''¬'' +
                            ISNULL(CONVERT(VARCHAR(50), n.NotaId), '''') + ''|'' +
                            ISNULL(n.NotaDocu, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), c.ClienteId), '''') + ''|'' +
                            ISNULL(c.ClienteRazon, '''') + ''|'' +
                            ISNULL(c.ClienteRuc, '''') + ''|'' +
                            ISNULL(c.ClienteDni, '''') + ''|'' +
                            ISNULL(c.ClienteDireccion, '''') + ''|'' +
                            ISNULL(c.ClienteTelefono, '''') + ''|'' +
                            ISNULL(c.ClienteCorreo, '''') + ''|'' +
                            ISNULL(c.ClienteEstado, '''') + ''|'' +
                            ISNULL(c.ClienteDespacho, '''') + ''|'' +
                            ISNULL(c.ClienteUsuario, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(10), c.ClienteFecha, 103), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(10), n.NotaFecha, 103) + '' '' + CONVERT(VARCHAR(8), n.NotaFecha, 108), '''') + ''|'' +
                            ISNULL(n.NotaUsuario, '''') + ''|'' +
                            ISNULL(n.NotaFormaPago, '''') + ''|'' +
                            ISNULL(n.NotaCondicion, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(10), n.NotaFechaPago, 103), '''') + ''|'' +
                            ISNULL(n.NotaDireccion, '''') + ''|'' +
                            ISNULL(n.NotaTelefono, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaSubtotal AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaMovilidad AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaDescuento AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaTotal AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaAcuenta AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaSaldo AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaAdicional AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaTarjeta AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaPagar AS MONEY), 1), '''') + ''|'' +
                            ISNULL(n.NotaEstado, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), n.CompaniaId), '''') + ''|'' +
                            ISNULL(n.NotaEntrega, '''') + ''|'' +
                            ISNULL(n.ModificadoPor, '''') + ''|'' +
                            ISNULL(n.FechaEdita, '''') + ''|'' +
                            ISNULL(n.NotaConcepto, '''') + ''|'' +
                            ISNULL(n.NotaSerie, '''') + ''|'' +
                            ISNULL(n.NotaNumero, '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.NotaGanancia AS MONEY), 1), '''') + ''|'' +
                            ISNULL(CONVERT(VARCHAR(50), CAST(n.ICBPER AS MONEY), 1), '''') + ''|'' +
                            ISNULL(n.CajaId, '''') + ''|'' +
                            '''' + ''|'' +
                            '''' + ''|'' +
                            '''' + ''|'' +
                            '''' + ''|'' +
                            ISNULL(
                                (
                                    SELECT TOP (1) d.EstadoSunat
                                    FROM dbo.DocumentoVenta d WITH (NOLOCK)
                                    WHERE d.NotaId = n.NotaId
                                    ORDER BY d.DocuId DESC
                                ),
                                ''''
                            )
                        FROM dbo.NotaPedido n
                        LEFT JOIN dbo.Cliente c
                            ON c.ClienteId = n.ClienteId
                        WHERE n.NotaFecha >= @FechaInicio
                          AND n.NotaFecha < @FechaFinExclusiva
                        ORDER BY n.NotaId DESC
                        FOR XML PATH('''')
                    ),
                    1, 1, ''''
                )
            ),
            ''~''
        ) AS Resultado
    OPTION (RECOMPILE);';

    EXEC sp_executesql @Sql,
        N'@FechaInicio DATE, @FechaFinExclusiva DATE',
        @FechaInicio = @FechaInicio,
        @FechaFinExclusiva = @FechaFinExclusiva;
END
GO
/****** Object:  StoredProcedure [web].[listarProductos]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[listarProductos]
    @Busqueda VARCHAR(250) = '',
    @Pagina INT = 1,
    @TamanoPagina INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[listarProductos_web] @Busqueda = @Busqueda, @Pagina = @Pagina, @TamanoPagina = @TamanoPagina;
END
GO
/****** Object:  StoredProcedure [web].[listarProductos_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[listarProductos_web]
    @Busqueda VARCHAR(250) = '',
    @Pagina INT = 1,
    @TamanoPagina INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @Pagina IS NULL OR @Pagina < 1 SET @Pagina = 1;
    IF @TamanoPagina IS NULL OR @TamanoPagina < 1 SET @TamanoPagina = 50;

    ;WITH ProductosBase AS
    (
        SELECT
            p.IdProducto,
            l.NombreLinea,
            s.NombreSublinea,
            p.ProductoCodigo,
            p.ProductoNombre,
            p.ProductoMarca,
            LTRIM(RTRIM(ISNULL(p.ProductoNombre, '') + ' ' + ISNULL(p.ProductoMarca, ''))) AS Descripcion,
            CONVERT(VARCHAR, CAST(p.ProductoCantidad AS MONEY), 1) AS ProductoCantidad,
            p.ProductoUM,
            CONVERT(VARCHAR, CAST(p.ProductoVenta AS MONEY), 1) AS ProductoVenta,
            CONVERT(VARCHAR, CAST(p.ProductoVentaB AS MONEY), 1) AS ProductoVentaB,
            p.ProductoCosto AS PrecioCosto,
            p.ProductoCostoDolar AS CostoDolar,
            p.ProductoTipoCambio AS TipoCambio,
            a.AlmacenNombre,
            p.ProductoUbicacion,
            '' AS ProductoObs,
            p.ProductoEstado,
            p.ProductoUsuario,
            CAST('1' AS VARCHAR(20)) AS ValorUM,
            p.ProductoImagen,
            p.ValorCritico,
            CAST(p.MaxCantVen AS VARCHAR(50)) AS MaxCantVen,
            p.AplicaINV
        FROM Producto p WITH (NOLOCK)
        INNER JOIN Sublinea s WITH (NOLOCK) ON p.IdSubLinea = s.IdSubLinea
        INNER JOIN Linea l WITH (NOLOCK) ON s.IdLinea = l.IdLinea
        INNER JOIN Almacen a WITH (NOLOCK) ON p.AlmacenId = a.AlmacenId
        WHERE p.ProductoEstado = 'BUENO' AND p.ProductoCantidad > 0

        UNION ALL

        SELECT
            p.IdProducto,
            l.NombreLinea,
            s.NombreSublinea,
            p.ProductoCodigo,
            p.ProductoNombre,
            p.ProductoMarca,
            LTRIM(RTRIM(ISNULL(p.ProductoNombre, '') + ' ' + ISNULL(p.ProductoMarca, ''))) AS Descripcion,
            CONVERT(VARCHAR, CAST((p.ProductoCantidad / NULLIF(u.ValorUM, 0)) AS MONEY), 1) AS ProductoCantidad,
            u.UMDescripcion AS ProductoUM,
            CONVERT(VARCHAR, CAST(u.PrecioVenta AS MONEY), 1) AS ProductoVenta,
            CONVERT(VARCHAR, CAST(u.PrecioVentaB AS MONEY), 1) AS ProductoVentaB,
            u.PrecioCosto AS PrecioCosto,
            '0' AS CostoDolar,
            '0' AS TipoCambio,
            a.AlmacenNombre,
            p.ProductoUbicacion,
            '' AS ProductoObs,
            p.ProductoEstado,
            p.ProductoUsuario,
            CAST(u.ValorUM AS VARCHAR(20)) AS ValorUM,
            p.ProductoImagen,
            p.ValorCritico,
            CONVERT(VARCHAR, CONVERT(DECIMAL(18,2), (CONVERT(DECIMAL(18,6), (1 / NULLIF(u.ValorUM, 0))) * p.MaxCantVen))) AS MaxCantVen,
            p.AplicaINV
        FROM UnidadMedida u WITH (NOLOCK)
        INNER JOIN Producto p WITH (NOLOCK) ON p.IdProducto = u.IdProducto
        INNER JOIN Sublinea s WITH (NOLOCK) ON p.IdSubLinea = s.IdSubLinea
        INNER JOIN Linea l WITH (NOLOCK) ON s.IdLinea = l.IdLinea
        INNER JOIN Almacen a WITH (NOLOCK) ON p.AlmacenId = a.AlmacenId
        WHERE p.ProductoEstado = 'BUENO' AND p.ProductoCantidad > 0
    ),
    ProductosFiltrados AS
    (
        SELECT *
        FROM ProductosBase
        WHERE ISNULL(@Busqueda, '') = ''
           OR Descripcion LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoCodigo, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoMarca, '') LIKE '%' + @Busqueda + '%'
           OR ISNULL(ProductoNombre, '') LIKE '%' + @Busqueda + '%'
    ),
    ProductosPaginados AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY Descripcion ASC, IdProducto ASC) AS RowNum,
            COUNT(*) OVER () AS TotalRegistros,
            IdProducto,
            NombreLinea,
            NombreSublinea,
            ProductoCodigo,
            ProductoNombre,
            ProductoMarca,
            Descripcion,
            ProductoCantidad,
            ProductoUM,
            ProductoVenta,
            ProductoVentaB,
            PrecioCosto,
            CostoDolar,
            TipoCambio,
            AlmacenNombre,
            ProductoUbicacion,
            ProductoObs,
            ProductoEstado,
            ProductoUsuario,
            ValorUM,
            ProductoImagen,
            ValorCritico,
            MaxCantVen,
            AplicaINV
        FROM ProductosFiltrados
    )
    SELECT
        TotalRegistros,
        IdProducto,
        NombreLinea,
        NombreSublinea,
        ProductoCodigo,
        ProductoNombre,
        ProductoMarca,
        Descripcion,
        ProductoCantidad,
        ProductoUM,
        ProductoVenta,
        ProductoVentaB,
        PrecioCosto,
        CostoDolar,
        TipoCambio,
        AlmacenNombre,
        ProductoUbicacion,
        ProductoObs,
        ProductoEstado,
        ProductoUsuario,
        ValorUM,
        ProductoImagen,
        ValorCritico,
        MaxCantVen,
        AplicaINV
    FROM ProductosPaginados
    WHERE RowNum BETWEEN ((@Pagina - 1) * @TamanoPagina + 1) AND (@Pagina * @TamanoPagina)
    ORDER BY RowNum;
END
GO
/****** Object:  StoredProcedure [web].[uspEditarNotaPedidowEB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspEditarNotaPedidowEB]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspEditarNotaPedidowEB_web] @Data = @Data;
END
GO
/****** Object:  StoredProcedure [web].[uspEditarNotaPedidowEB_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspEditarNotaPedidowEB_web]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('dbo.uspEditarNotaPedidowEB', 'P') IS NOT NULL
    BEGIN
        EXEC dbo.uspEditarNotaPedidowEB @Data = @Data;
        RETURN;
    END

    IF OBJECT_ID('dbo.uspEditarNotaPedido', 'P') IS NOT NULL
    BEGIN
        BEGIN TRY
            EXEC dbo.uspEditarNotaPedido @Data = @Data;
            RETURN;
        END TRY
        BEGIN CATCH
        END CATCH;

        BEGIN TRY
            EXEC dbo.uspEditarNotaPedido @ListaOrden = @Data;
            RETURN;
        END TRY
        BEGIN CATCH
            SELECT ERROR_MESSAGE() AS Error;
            RETURN;
        END CATCH;
    END

    RAISERROR('No existe SP de edicion de nota en dbo.', 16, 1);
END
GO
/****** Object:  StoredProcedure [web].[uspinsertarNotaB]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspinsertarNotaB]
    @ListaOrden varchar(Max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspinsertarNotaB_web] @ListaOrden = @ListaOrden;
END
GO
/****** Object:  StoredProcedure [web].[uspinsertarNotaB_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspinsertarNotaB_web]
    @ListaOrden varchar(Max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dbo.uspinsertarNotaB @ListaOrden = @ListaOrden;
END
GO
/****** Object:  StoredProcedure [web].[uspObtenerNotaPedidoById]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspObtenerNotaPedidoById]
    @Id NUMERIC(38,0)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspObtenerNotaPedidoById_web] @Id = @Id;
END
GO
/****** Object:  StoredProcedure [web].[uspObtenerNotaPedidoById_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspObtenerNotaPedidoById_web]
    @Id NUMERIC(38,0)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX) = N'
    SELECT TOP (1)
        n.NotaId,
        n.NotaDocu,
        n.ClienteId,
        n.NotaFecha,
        n.NotaUsuario,
        n.NotaFormaPago,
        n.NotaCondicion,
        n.NotaFechaPago,
        n.NotaDireccion,
        n.NotaTelefono,
        n.NotaSubtotal,
        n.NotaMovilidad,
        n.NotaDescuento,
        n.NotaTotal,
        n.NotaAcuenta,
        n.NotaSaldo,
        n.NotaAdicional,
        n.NotaTarjeta,
        n.NotaPagar,
        n.NotaEstado,
        n.CompaniaId,
        n.NotaEntrega,
        n.ModificadoPor,
        n.FechaEdita,
        n.NotaConcepto,
        n.NotaSerie,
        n.NotaNumero,
        n.NotaGanancia,
        n.ICBPER,
        n.CajaId,
        (
            SELECT TOP (1) d.EstadoSunat
            FROM dbo.DocumentoVenta d WITH (NOLOCK)
            WHERE d.NotaId = n.NotaId
            ORDER BY d.DocuId DESC
        ) AS EstadoSunat
    FROM dbo.NotaPedido n WITH (NOLOCK)
    WHERE n.NotaId = @Id;';

    EXEC sp_executesql @Sql, N'@Id NUMERIC(38,0)', @Id = @Id;
END
GO
/****** Object:  StoredProcedure [web].[uspObtenerNotaPedidoDetalles]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspObtenerNotaPedidoDetalles]
    @NotaId NUMERIC(38,0),
    @Page INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspObtenerNotaPedidoDetalles_web] @NotaId = @NotaId, @Page = @Page, @PageSize = @PageSize;
END
GO
/****** Object:  StoredProcedure [web].[uspObtenerNotaPedidoDetalles_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspObtenerNotaPedidoDetalles_web]
    @NotaId NUMERIC(38,0),
    @Page INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @Page < 1 SET @Page = 1;
    IF @PageSize < 1 SET @PageSize = 1;
    IF @PageSize > 100 SET @PageSize = 100;

    DECLARE @Offset INT;
    SET @Offset = (@Page - 1) * @PageSize;

    ;WITH D AS
    (
        SELECT
            d.DetalleId,
            d.NotaId,
            d.IdProducto,
            d.DetalleCantidad,
            d.DetalleUm,
            d.DetalleDescripcion,
            d.DetalleCosto,
            d.DetallePrecio,
            d.DetalleImporte,
            d.DetalleEstado,
            d.CantidadSaldo,
            d.ValorUM,
            ROW_NUMBER() OVER (ORDER BY d.DetalleId ASC) AS rn
        FROM dbo.DetallePedido d WITH (NOLOCK)
        WHERE d.NotaId = @NotaId
    )
    SELECT
        DetalleId,
        NotaId,
        IdProducto,
        DetalleCantidad,
        DetalleUm,
        DetalleDescripcion,
        DetalleCosto,
        DetallePrecio,
        DetalleImporte,
        DetalleEstado,
        CantidadSaldo,
        ValorUM
    FROM D
    WHERE rn BETWEEN (@Offset + 1) AND (@Offset + @PageSize)
    ORDER BY rn;
END
GO
/****** Object:  StoredProcedure [web].[uspValidaUsuario]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspValidaUsuario]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC [web].[uspValidaUsuario_web] @Data = @Data;
END
GO
/****** Object:  StoredProcedure [web].[uspValidaUsuario_web]    Script Date: 29/04/2026 15:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [web].[uspValidaUsuario_web]
    @Data varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dbo.uspValidaUsuario @Data = @Data;
END
GO
USE [master]
GO
ALTER DATABASE [MEGAROSITAB_ACT] SET  READ_WRITE 
GO
