USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EmpId_TSht]    Script Date: 12/21/2015 14:06:15 ******/
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
