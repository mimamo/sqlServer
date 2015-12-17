USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_EmpYr_Type_Wrk_EDId_E]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_EmpYr_Type_Wrk_EDId_E] @parm1 varchar ( 10), @parm2 varchar ( 4), @parm3 varchar ( 10), @parm4 varchar ( 6)  as
       Select *
		   from EarnDed
			left outer join EarnType
				on EarnDedId = EarnType.Id
           where EmpId         =     @parm1
             and CalYr         =     @parm2
             and EarnDed.EDType  =     'E'
             and EarnDedId     LIKE  @parm3
             and WrkLocId     LIKE  @parm4
           order by EmpId, CalYr, EarnDed.EDType,  EarnDedId, WrkLocId
GO
