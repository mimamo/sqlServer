USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Arrg_Curr_Ytd]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_Arrg_Curr_Ytd] @parm1 varchar ( 10), @parm2 varchar ( 4), @parm3 varchar (10) as
       Select * from EarnDed
           where EarnDedId =  @parm1
             and EDType    =  "D"
             and CalYr     =  @parm2
             and EmpId  LIKE  @parm3
             and (ArrgCurr <> 0 or ArrgYTD <> 0)
GO
