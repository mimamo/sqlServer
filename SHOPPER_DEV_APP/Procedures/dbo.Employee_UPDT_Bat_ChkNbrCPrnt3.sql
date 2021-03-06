USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_UPDT_Bat_ChkNbrCPrnt3]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_UPDT_Bat_ChkNbrCPrnt3]
@parm1 varchar (10),
@parm2 varchar (10)
AS
    Update CalcChk
    Set CheckNbr=''
    From CalcChk
         INNER JOIN Employee
             ON CalcChk.EmpID=Employee.EmpID
    where Employee.CurrBatNbr=@parm1
          AND Employee.EmpID LIKE @parm2

    Update Employee
    Set CurrBatNbr      =  ''      ,
        ChkNbr          =  ''      ,
        CurrCheckPrint  =  0
    where CurrBatNbr    =  @parm1
          AND Employee.EmpID LIKE @parm2
GO
