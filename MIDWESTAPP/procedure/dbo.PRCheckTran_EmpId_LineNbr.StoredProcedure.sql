USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_EmpId_LineNbr]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRCheckTran_EmpId_LineNbr] @parm1 varchar ( 10), @parm2 int as
       Select * from PRCheckTran
           where EmpId  =  @parm1 and
		 LineNbr = @parm2
           order by EmpId,
                    LineNbr
GO
