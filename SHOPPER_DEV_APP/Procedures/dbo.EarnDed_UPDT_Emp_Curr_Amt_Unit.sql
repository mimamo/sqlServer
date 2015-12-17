USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_UPDT_Emp_Curr_Amt_Unit]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_UPDT_Emp_Curr_Amt_Unit] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Update EarnDed
           Set CurrEarnDedAmt     = 0.0,
               CurrRptEarnSubjDed = 0.0,
               CurrUnits          = 0.0,
               ArrgCurr           = 0.0
           where EmpId = @parm1
             and CalYr = @parm2
GO
