USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Arrg_Ytd]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_Arrg_Ytd] @parm1 varchar ( 10), @parm2 varchar ( 4), @parm3 varchar (10) as
       Select * from EarnDed
           where EarnDedId =  @parm1
             and EDType    =  "D"
             and CalYr     =  @parm2
             and EmpId  LIKE  @parm3
             and ArrgYTD   <> 0
GO
