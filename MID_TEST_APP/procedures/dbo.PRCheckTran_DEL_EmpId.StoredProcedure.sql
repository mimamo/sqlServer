USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_DEL_EmpId]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRCheckTran_DEL_EmpId] @parm1 varchar ( 10) as
       Delete prchecktran from PRCheckTran
           where EmpId  =  @parm1
		and ASID = 0
GO
