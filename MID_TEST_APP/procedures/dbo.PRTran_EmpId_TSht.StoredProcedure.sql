USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EmpId_TSht]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_EmpId_TSht] @parm1 varchar ( 10), @parm2 smallint as
       Select * from PRTran
           where EmpId       =  @parm1
             and TimeShtFlg  =  @parm2
           order by EmpId     ,
                    TimeShtFlg
GO
