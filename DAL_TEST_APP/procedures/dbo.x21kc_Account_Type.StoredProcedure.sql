USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Account_Type]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_Account_Type] @parm1 varchar (10), @parm2 varchar (10) as
select a.acct from account a, account x where
a.Acct  = @parm1 
and x.Acct   = @parm2 
and ((a.AcctType   in ('1A', '2L','3A','4L','2A','3L')  and x.AcctType   in ('3I', '4E', '3E','1I','2E','1E') ) 
or ( a.AcctType  in ('3I', '4E', '3E','1I','2E','1E') and x.AcctType   in ('1A', '2L','3A','4L','2A','3L') ))
GO
