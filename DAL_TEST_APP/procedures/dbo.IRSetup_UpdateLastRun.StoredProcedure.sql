USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRSetup_UpdateLastRun]    Script Date: 12/21/2015 13:57:04 ******/
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
