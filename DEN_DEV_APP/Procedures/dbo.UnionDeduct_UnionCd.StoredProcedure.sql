USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[UnionDeduct_UnionCd]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[UnionDeduct_UnionCd] @parm1 varchar (4), @parm2 varchar (10), @parm3 varchar (4), @parm4 varchar (10) as
Select *
from UnionDeduct
	left outer join Deduction
		on UnionDeduct.DedId = Deduction.DedId
where Deduction.CalYr = @parm1
	and UnionDeduct.Union_Cd = @parm2
	and UnionDeduct.Labor_Class_Cd like @parm3
	and UnionDeduct.DedId like @parm4
Order by UnionDeduct.Labor_Class_Cd, UnionDeduct.DedId
GO
