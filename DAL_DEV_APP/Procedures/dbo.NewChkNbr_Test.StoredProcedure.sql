USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[NewChkNbr_Test]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[NewChkNbr_Test] @acct varchar(10), @sub varchar(24), @refnbr varchar(10)  as
select count(*) from APDoc where
acct  = @acct
and sub = @sub
and doctype in ('HC', 'CK','VC','SC','ZC')
and refnbr = @refnbr
GO
