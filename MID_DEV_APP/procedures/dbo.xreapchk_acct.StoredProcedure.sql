USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xreapchk_acct]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xreapchk_acct] @acct varchar(10) as
select distinct acct from APDoc where
acct  like @acct
and doctype in ('HC', 'CK','VC','SC','ZC')
order by acct
GO
