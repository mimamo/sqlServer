USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportUpdate]
	@ReportKey int,
	@UserKey int,
	@Name varchar(255),
	@ReportType smallint,
	@Private int,
	@ReportGroupKey int,
	@ReportHeading1 varchar(200),
	@ReportHeading1Align smallint,
	@ReportHeading2 varchar(200),
	@ReportHeading2Align smallint,
	@Orientation smallint,
	@GroupBy smallint,
	@ShowConditions tinyint


AS --Encrypt

/*
|| When     Who Rel     What
|| 12/14/07 RTC 8.5.1   (issue 17338) Added UserKey parameter to handle switching user when marking reports private.
*/

	if @UserKey is not null
		UPDATE
			tReport
		SET
			UserKey = @UserKey,
			Name = @Name,
			ReportType = @ReportType,
			Private = @Private,
			ReportGroupKey = @ReportGroupKey,
			ReportHeading1 = @ReportHeading1,
			ReportHeading1Align = @ReportHeading1Align,
			ReportHeading2 = @ReportHeading2,
			ReportHeading2Align = @ReportHeading2Align,
			Orientation = @Orientation,
			GroupBy = @GroupBy,
			ShowConditions = @ShowConditions
		WHERE
			ReportKey = @ReportKey 
	ELSE
		UPDATE
			tReport
		SET
			Name = @Name,
			ReportType = @ReportType,
			Private = @Private,
			ReportGroupKey = @ReportGroupKey,
			ReportHeading1 = @ReportHeading1,
			ReportHeading1Align = @ReportHeading1Align,
			ReportHeading2 = @ReportHeading2,
			ReportHeading2Align = @ReportHeading2Align,
			Orientation = @Orientation,
			GroupBy = @GroupBy,
			ShowConditions = @ShowConditions
		WHERE
			ReportKey = @ReportKey 
	RETURN 1
GO
