USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xreapchk_sub]    Script Date: 12/21/2015 15:49:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xreapchk_sub] @acct varchar(10), @sub varchar(24) as
select distinct sub  from APDoc where
acct = @acct
and sub like @sub
and doctype in ('HC', 'CK','VC','SC','ZC')
order by  sub
GO
