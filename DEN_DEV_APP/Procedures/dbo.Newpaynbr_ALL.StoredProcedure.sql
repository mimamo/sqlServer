USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Newpaynbr_ALL]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[Newpaynbr_ALL] @custid varchar(15), @refnbr varchar(10)  as
select count(*) from ARDoc where
custid = @custid
and doctype in ('PA', 'NS', 'RP')
and refnbr like @refnbr
GO
