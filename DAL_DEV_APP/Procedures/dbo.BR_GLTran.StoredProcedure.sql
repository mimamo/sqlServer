USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_GLTran]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_GLTran]
@parm1 char(10),
@parm2 char(6),
@parm3 char(6),
@parm4 char(10),
@parm5 char(24)
as
Select *
from GLTran
where Module = 'GL'
and cpnyid = @parm1 and PerPost BETWEEN @parm2 AND @parm3
and Acct = @parm4
and Sub = @parm5
and Rlsed = 1
and LedgerID = (SELECT LedgerID FROM GLSetup)
order by cpnyid, Module, PerPost, Acct, Sub
--NOTE: Troy Grigsby - 11/29/01 - Modified from the original version where where clause is Rlsed = 'True'
GO
