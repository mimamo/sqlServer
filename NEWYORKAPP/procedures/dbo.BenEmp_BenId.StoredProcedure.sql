USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[BenEmp_BenId]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEmp_BenId] @parm1 varchar ( 10) as
       Select * from BenEmp
           where BenId  =  @parm1
           order by EmpId
GO
