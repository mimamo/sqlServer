USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotserMst_invLS]    Script Date: 12/21/2015 15:42:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[LotserMst_invLS]  @invtid varchar(30), @lotsernbr varchar(25) as
select * from lotsermst where 
invtid like @invtid
and lotsernbr like @lotsernbr
order by invtid, lotsernbr
GO
