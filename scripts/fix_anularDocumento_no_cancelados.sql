USE [MEGAROSITAB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[anularDocumento]
@Data varchar(max)
as
declare @pos1 int
declare @pos2 int
declare @pos3 int
declare @DocuId numeric(38),
@NotaId numeric(38),
@DocuUsuario varchar(80),
@EstadoNota varchar(60)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = Len(@Data)+1
Set @DocuUsuario=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
begin
set @EstadoNota = isnull((select top 1 ltrim(rtrim(NotaEstado)) from NotaPedido where NotaId=@NotaId),'')

if (upper(@EstadoNota)='CANCELADO')
begin
select 'CANCELADO_NO_ANULABLE'
end
else if NOT EXISTS(select * from CajaDetalle where NotaId=@NotaId)
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
