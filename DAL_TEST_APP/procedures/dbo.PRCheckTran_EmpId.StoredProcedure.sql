USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_EmpId]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRCheckTran_EmpId] @parm1 varchar ( 10) as
       Select * from PRCheckTran
           where EmpId  =  @parm1
           order by EmpId,
                    LineNbr
GO
