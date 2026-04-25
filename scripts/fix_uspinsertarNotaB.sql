USE [MEGAROSITAB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[uspinsertarNotaB]      
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
insert into NotaPedido (      
NotaDocu,ClienteId,NotaFecha,NotaUsuario,NotaFormaPago,NotaCondicion,NotaDias,NotaFechaPago,NotaDireccion,NotaTelefono,      
NotaSubtotal,NotaMovilidad,NotaDescuento,NotaTotal,NotaAcuenta,NotaSaldo,NotaAdicional,NotaTarjeta,NotaPagar,NotaEstado,      
CompaniaId,NotaEntrega,ModificadoPor,FechaEdita,NotaConcepto,NotaSerie,NotaNumero,NotaGanancia,ICBPER,CajaId      
) values (      
@NotaDocu,@ClienteId,GETDATE(),@NotaUsuario,@NotaFormaPago,@NotaCondicion,1,GETDATE(),@NotaDireccion,@NotaTelefono,      
@NotaSubtotal,@NotaMovilidad,@NotaDescuento,@NotaTotal,@NotaAcuenta,@NotaSaldo,@NotaAdicional,@NotaTarjeta,@NotaPagar,@NotaEstado,@CompaniaId,      
@NotaEntrega,'','',@NotaConcepto,@Serie,@cod,@NotaGanancia,@ICBPER,''      
)      
set @NotaId=(select @@IDENTITY)      
if @NotaDocu='BOLETA'      
begin      
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
