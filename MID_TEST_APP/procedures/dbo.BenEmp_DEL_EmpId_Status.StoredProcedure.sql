USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenEmp_DEL_EmpId_Status]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEmp_DEL_EmpId_Status] @parm1 varchar ( 10), @parm2 varchar ( 2) as
       Delete benemp from BenEmp
           where EmpId   =  @parm1
             and Status  =  @parm2
GO
