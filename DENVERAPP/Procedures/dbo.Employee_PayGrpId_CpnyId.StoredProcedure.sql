USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_PayGrpId_CpnyId]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_PayGrpId_CpnyId] @parm1 varchar ( 6), @parm2 varchar (10) as
       Select * from Employee
           where PayGrpId LIKE @parm1
             and CpnyId   LIKE @parm2
           order by PayGrpId,
                    EmpId
GO
