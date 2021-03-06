USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[OldChkNbr_PV]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[OldChkNbr_PV] @acct varchar(10), @sub varchar(24), @refnbr varchar(10)  as
select refnbr, doctype,VENDID, docdate, origdocamt from APDoc where
acct  = @acct
and sub = @sub
and doctype in ('HC', 'CK','VC','SC','ZC')
and refnbr like @refnbr
order by acct, sub, doctype
GO
