USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_DEL_EmpId_ChkSeq]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRCheckTran_DEL_EmpId_ChkSeq] @parm1 varchar ( 10), @parm2 varchar(2) as
    Delete prchecktran from PRCheckTran
                 where EmpId  =  @parm1
                   and ChkSeq =  @parm2
		   and ASID = 0
GO
