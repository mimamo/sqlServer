USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Emp_Yr_Type_EarnDedId2]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_Emp_Yr_Type_EarnDedId2] @parm1 varchar ( 10), @parm2 varchar ( 4), @parm3 varchar ( 1), @parm4 varchar ( 10) as
       Select *
		   from EarnDed
			left outer join Deduction
				on EarnDedId = Deduction.DedId
           where EmpId      =     @parm1
             and EarnDed.CalYr =  @parm2
             and EDType       =     @parm3
             and EarnDedId  LIKE  @parm4
           order by EmpId, EarnDed.CalYr, EDType, WrkLocId, EarnDedType, EarnDedId
GO
