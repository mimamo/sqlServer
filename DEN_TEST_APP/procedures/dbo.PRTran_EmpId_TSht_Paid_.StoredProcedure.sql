USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EmpId_TSht_Paid_]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_EmpId_TSht_Paid_] @parm1 varchar ( 10), @parm2 smallint, @parm3 smallint as
        Select * from PRTran
           where EmpId      = @parm1
             and TimeShtFlg = @parm2
             and Paid       = @parm3
           order by EmpId,
                    TimeShtFlg,
                    Rlsed,
                    Paid,
                    WrkLocId,
                    EarnDedId
GO
