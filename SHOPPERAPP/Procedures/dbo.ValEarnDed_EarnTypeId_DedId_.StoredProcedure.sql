USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ValEarnDed_EarnTypeId_DedId_]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ValEarnDed_EarnTypeId_DedId_] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 4) as
Select *
from ValEarnDed
	left outer join Deduction
		on ValEarnDed.DedId = Deduction.DedId
where ValEarnDed.EarnTypeId = @parm1
	and ValEarnDed.DedId LIKE @parm2
	and Deduction.CalYr = @parm3
order by ValEarnDed.EarnTypeId, ValEarnDed.DedId
GO
