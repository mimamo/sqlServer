USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_Accounts_All]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_Accounts_All]
@parm1 char(10),@parm2 char(10)
AS Select *
from BRAcct
where cpnyid = @parm1 and AcctID like @parm2
order by AcctID
GO
