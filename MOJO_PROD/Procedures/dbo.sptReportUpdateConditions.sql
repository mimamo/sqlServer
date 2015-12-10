USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportUpdateConditions]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportUpdateConditions]
	@ReportKey int,
	@ConditionDefinition text

AS --Encrypt

	UPDATE
		tReport
	SET
		ConditionDefinition = @ConditionDefinition
	WHERE
		ReportKey = @ReportKey 

	RETURN 1
GO
