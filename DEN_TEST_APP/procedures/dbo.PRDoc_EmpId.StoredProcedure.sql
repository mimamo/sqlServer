USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_EmpId]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_EmpId] @parm1 varchar ( 10) as
       Select * from PRDoc
           where EmpId  =  @parm1
           order by EmpId
GO
