USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateDailyEmailInfo]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateDailyEmailInfo]
	(
		@CompanyKey INT
		,@MissingTime DATETIME
		,@MissingTimeSheet DATETIME
		,@MissingTimeSheetFreq SMALLINT
		,@BudgetUpdate DATETIME
		,@MissingApproval DATETIME
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	UPDATE tPreference
	SET    MissingTime = @MissingTime
		  ,MissingTimeSheet = @MissingTimeSheet
		  ,MissingTimeSheetFreq = @MissingTimeSheetFreq
		  ,BudgetUpdate = @BudgetUpdate
		  ,MissingApproval = @MissingApproval
	WHERE  CompanyKey = @CompanyKey
	
	RETURN 1
GO
