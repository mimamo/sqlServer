USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_DEL_EmpId]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRCheckTran_DEL_EmpId] @parm1 varchar ( 10) as
       Delete prchecktran from PRCheckTran
           where EmpId  =  @parm1
		and ASID = 0
GO
