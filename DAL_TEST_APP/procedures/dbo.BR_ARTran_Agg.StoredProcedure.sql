USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_ARTran_Agg]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[BR_ARTran_Agg]
@parm1 char(10),
@parm2 char(6),
@parm3 char(6),
@parm4 char(10),
@parm5 char(24)

as

Select *
from ARTran
where cpnyid = @parm1 and PerPost BETWEEN @parm2 AND @parm3
and Acct = @parm4
and Rlsed = 1
order by cpnyid, PerPost, Acct, Sub
GO
