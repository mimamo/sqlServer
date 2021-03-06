USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Emp_Yr_Tp_Wrk_EDTp_Id2_]    Script Date: 12/21/2015 15:49:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_Emp_Yr_Tp_Wrk_EDTp_Id2_] @parm1 varchar ( 10), @parm2 varchar ( 4), @parm3 varchar ( 1), @parm4 varchar ( 6), @parm5 varchar ( 10) as
       Select * from EarnDed
           where EmpId        =     @parm1
             and CalYr        =     @parm2
             and EDType         LIKE  @parm3
             and WrkLocId     LIKE  @parm4
             and EarnDedId    LIKE  @parm5
           order by EmpId, CalYr, EDType, WrkLocId, EarnDedId
GO
