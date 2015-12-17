USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_UPDT_Bat_ChkNbr_CPrnt]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_UPDT_Bat_ChkNbr_CPrnt] @parm1 varchar ( 10), @parm2 smallint as
       Update Employee
           Set  CurrCheckPrint   =  @parm2
           where CurrBatNbr      =  @parm1
             and ChkNbr          <> ""
             and CurrCheckPrint  <>  @parm2
GO
