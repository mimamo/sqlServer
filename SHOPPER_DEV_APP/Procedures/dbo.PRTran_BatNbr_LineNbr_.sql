USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_LineNbr_]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_BatNbr_LineNbr_] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint WITH RECOMPILE as
       SELECT *
         FROM PRTran LEFT OUTER JOIN Employee
                       ON PRTran.EmpId = Employee.EmpId
                     LEFT OUTER JOIN EarnType
                       ON PRTran.EarnDedId = EarnType.Id
        WHERE PRTran.BatNbr = @parm1
          AND PRTran.LineNbr BETWEEN @parm2beg AND @parm2end
        ORDER BY PRTran.BatNbr,
                 PRTran.ChkAcct,
                 PRTran.ChkSub,
                 PRTran.RefNbr,
                 PRTran.TranType,
                 PRTran.LineNbr
GO
