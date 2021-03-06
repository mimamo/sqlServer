USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[OldPayNbr_PV]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[OldPayNbr_PV] @custid varchar(15), @refnbr varchar(10)  as
select refnbr, docdate, origdocamt from ARDoc where
custid = @custid
and doctype in ('PA', 'NS', 'RP')
and refnbr like @refnbr
order by custid, doctype, refnbr
GO
