USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRSetup_UpdateLastRun]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRSetup_UpdateLastRun] @LastProcessDate SmallDateTime, @LastStartDate SmallDateTime, @LastUserID VarChar(10) AS
	Update IRSetup set
		PlanOrdTime = getdate(),
		PlanOrdDate = @LastProcessDate,
		PlanOrdUserID = @LastUserID,
		PlanOrdStartDate = @LastStartDate
GO
