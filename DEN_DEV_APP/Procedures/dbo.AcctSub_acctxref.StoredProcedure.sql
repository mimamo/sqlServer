USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctSub_acctxref]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AcctSub_acctxref]   @parm1 varchar (10), @parm2 varchar (24) as
SELECT * from acctxref where
cpnyid = @parm1
and acct = @parm2
order by cpnyid, acct
GO
