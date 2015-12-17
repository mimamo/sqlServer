USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequire_MoveIn]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRRequire_MoveIn] @InvtId VarChar(30), @SiteID VarChar(10), @DaysAllowed int, @ExcludeDate SmallDateTime AS
	Select * from IRRequirement where InvtId = @InvtId and SiteID Like @SiteID and DueDatePlan <> @ExcludeDate and DateDiff(dd,DueDatePlan,DueDate) > @DaysAllowed and Revised = 0 order by DueDate,DueDatePlan,DocumentId
GO
