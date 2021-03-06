USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequire_MoveOut]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRRequire_MoveOut] @InvtId VarChar(30), @SiteID VarChar(10), @DaysAllowed int, @ExcludeDate SmallDateTime AS
	Select * from IRRequirement where InvtId = @InvtId and SiteID Like @SiteID and DueDatePlan <> @ExcludeDate and DateDiff(dd,DueDate,DueDatePlan) > @DaysAllowed and Revised = 0  order by DueDate,DueDatePlan,DocumentId
GO
