USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_EmpId_DedId_Sum]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_EmpId_DedId_Sum] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select SUM(CalYTDEarnDed) from EarnDed
           Where EmpId      =     @parm1
             and EDType     =     "D"
             and EarnDedId  =     @parm2
GO
