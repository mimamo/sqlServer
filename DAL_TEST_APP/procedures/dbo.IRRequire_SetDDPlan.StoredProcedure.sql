USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequire_SetDDPlan]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRRequire_SetDDPlan] @InvtId VarChar(30), @SiteID VarChar(10) AS
Update IRRequirement set DueDatePlan = DueDate where InvtId = @InvtId and SiteID Like @SiteID
GO
