USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_UPDT_Bat_ChkNbrCPrnt2]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_UPDT_Bat_ChkNbrCPrnt2] @parm1 varchar ( 10) as
       Update Employee
           Set  CurrBatNbr      =  ''      ,
                ChkNbr          =  ''      ,
                CurrCheckPrint  =   0
           where CurrBatNbr     =  @parm1
GO
