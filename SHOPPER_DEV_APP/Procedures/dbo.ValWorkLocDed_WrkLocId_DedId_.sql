USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ValWorkLocDed_WrkLocId_DedId_]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ValWorkLocDed_WrkLocId_DedId_] @parm1 varchar ( 6), @parm2 varchar ( 10), @parm3 varchar ( 4) as
Select *
from ValWorkLocDed
	left outer join Deduction
		on ValWorkLocDed.DedId = Deduction.DedId
where ValWorkLocDed.WrkLocId = @parm1
	and ValWorkLocDed.DedId LIKE @parm2
	and Deduction.CalYr = @parm3
order by ValWorkLocDed.WrkLocId, ValWorkLocDed.DedId
GO
