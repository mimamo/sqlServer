USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkSUTAD_UserId]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkSUTAD_UserId] @parm1 varchar ( 47) as
       Select * From WrkSUTAD
           where UserId  =  @parm1
           order by UserId,
                    EmployeeId
GO
