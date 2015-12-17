USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRRequire_SetDDPlan]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRRequire_SetDDPlan] @InvtId VarChar(30), @SiteID VarChar(10) AS
Update IRRequirement set DueDatePlan = DueDate where InvtId = @InvtId and SiteID Like @SiteID
GO
