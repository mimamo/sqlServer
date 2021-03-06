USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_SFLD_PayGrpId_Status]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_SFLD_PayGrpId_Status] @parm1 varchar ( 6), @parm2 varchar ( 1), @parm3 varchar(10) as
       Select   PayGrpId, EmpId, Name, DirectDeposit, Status, CurrCheckType, CpnyId From Employee
           where PayGrpId  =     @parm1
             and Status    LIKE  @parm2
             and CpnyId    LIKE  @parm3
           order by PayGrpId,
                    EmpId
GO
