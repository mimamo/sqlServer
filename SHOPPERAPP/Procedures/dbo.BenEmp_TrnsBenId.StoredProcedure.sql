USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BenEmp_TrnsBenId]    Script Date: 12/21/2015 16:13:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEmp_TrnsBenId] @parm1 varchar ( 10) as
       Select * from BenEmp
           where TrnsBenId  =  @parm1
           order by EmpId,
                    BenId
GO
