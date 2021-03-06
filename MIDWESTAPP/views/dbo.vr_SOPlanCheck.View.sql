USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vr_SOPlanCheck]    Script Date: 12/21/2015 15:55:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Return the decimal places for base currency, base BMI currency, inventory setup cost and quantity
*/
Create View [dbo].[vr_SOPlanCheck]
AS

	Select	Distinct
		InvtID, SiteID, WillPrint = 1
		From	SOPlan
		Where	Plantype In ('50','52', '60', '62', '64')
GO
