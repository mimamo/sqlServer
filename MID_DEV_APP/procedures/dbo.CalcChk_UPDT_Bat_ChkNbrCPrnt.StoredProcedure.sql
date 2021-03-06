USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_UPDT_Bat_ChkNbrCPrnt]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[CalcChk_UPDT_Bat_ChkNbrCPrnt]
@parm1 varchar (10),
@parm2 varchar (10),
@parm3 varchar (10)
AS
    Update CalcChk
    Set CheckNbr=''
    From CalcChk
         INNER JOIN Employee
             ON CalcChk.EmpID=Employee.EmpID
    where Employee.CurrBatNbr=@parm1
          AND Employee.EmpID   LIKE @parm2
          AND CalcChk.CheckNbr LIKE @parm3

    if NOT exists (select EmpId from CalcChk where EmpId = @parm2 and CheckNbr <> '')
        Update Employee
        Set CurrBatNbr      =  ''      ,
            ChkNbr          =  ''      ,
            CurrCheckPrint  =  0
        where CurrBatNbr    =  @parm1
              AND Employee.EmpID LIKE @parm2
GO
