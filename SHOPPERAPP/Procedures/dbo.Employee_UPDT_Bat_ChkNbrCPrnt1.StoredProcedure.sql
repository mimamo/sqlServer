USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_UPDT_Bat_ChkNbrCPrnt1]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_UPDT_Bat_ChkNbrCPrnt1] @parm1 varchar ( 10) as
       Update Employee
           Set  CurrBatNbr      =  ''      ,
                ChkNbr          =  ''      ,
                CurrCheckPrint  =   0
           where CurrBatNbr     =  @parm1
             and ChkNbr         =  ''
GO
