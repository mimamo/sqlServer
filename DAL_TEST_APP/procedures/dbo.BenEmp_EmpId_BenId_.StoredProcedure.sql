USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenEmp_EmpId_BenId_]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEmp_EmpId_BenId_] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select *, case when Benefit.AccrLiab <> 0
                     then (BenEmp.BYBegBal+BenEmp.BYTDAccr-BenEmp.BYTDUsed)
                     else 0
                end,
                (BenEmp.BYBegBal+BenEmp.BYTDAvail-BenEmp.BYTDUsed)
         from BenEmp
			left outer join Benefit
				on BenEmp.BenId = Benefit.BenId
           where BenEmp.EmpId  =     @parm1
             and BenEmp.BenId  LIKE  @parm2
           order by BenEmp.EmpId,
                    BenEmp.BenId
GO
