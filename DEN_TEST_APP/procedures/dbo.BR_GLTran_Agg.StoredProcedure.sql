USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_GLTran_Agg]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[BR_GLTran_Agg]
@parm1 char(10),
@parm2 char(6),
@parm3 char(6),
@parm4 char(10)

as

Select *
from GLTran
where Module = 'GL'
and cpnyid = @parm1 and PerPost BETWEEN @parm2 AND @parm3
and Acct = @parm4
and Rlsed = 1
and LedgerID = (SELECT LedgerID FROM GLSetup)
order by Module, PerPost, Acct, Sub
GO
