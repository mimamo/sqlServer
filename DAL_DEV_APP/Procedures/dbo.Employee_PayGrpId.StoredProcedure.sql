USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_PayGrpId]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Employee_PayGrpId] @parm1 varchar ( 6) as
       Select * from Employee
           where PayGrpId  LIKE  @parm1
           order by PayGrpId,
                    EmpId
GO
