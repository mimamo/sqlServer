USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportInsert]
	@ViewKey int,
	@Name varchar(255),
	@ReportType smallint,
	@Private int,
	@UserKey int,
	@CompanyKey int,
	@ReportGroupKey int,
	@ReportHeading1 varchar(200),
	@ReportHeading1Align smallint,
	@ReportHeading2 varchar(200),
	@ReportHeading2Align smallint,
	@Orientation smallint,
	@GroupBy smallint,
	@ReportFilter varchar(50),
	@ShowConditions tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When       Who Rel     What
|| 04/23/08   RTC 1.0.0.0 Modified to insert application version.  Hardcoded to 1, WMJ does not use this procedure
*/

	Declare @FieldDefinition VARCHAR(100)
	Declare @ConditionDefinition VARCHAR(100)

	Select @FieldDefinition = '<FIELDS></FIELDS>'
	Select @ConditionDefinition = '<CONDITIONS></CONDITIONS>'
	
	INSERT tReport
		(
		ViewKey,
		Name,
		ReportType,
		FieldDefinition,
		ConditionDefinition,
		Private,
		UserKey,
		CompanyKey,
		ReportGroupKey,
		ReportHeading1,
		ReportHeading1Align,
		ReportHeading2,
		ReportHeading2Align,
		Orientation,
		GroupBy,
		ReportFilter,
		ShowConditions,
		ApplicationVersion
		)

	VALUES
		(
		@ViewKey,
		@Name,
		@ReportType,
		@FieldDefinition,
		@ConditionDefinition,
		@Private,
		@UserKey,
		@CompanyKey,
		@ReportGroupKey,
		@ReportHeading1,
		@ReportHeading1Align,
		@ReportHeading2,
		@ReportHeading2Align,
		@Orientation,
		@GroupBy,
		@ReportFilter,
		@ShowConditions,
		1
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	Insert Into tRptSecurityGroup (ReportKey, SecurityGroupKey)
	Select @oIdentity, SecurityGroupKey from tSecurityGroup (NOLOCK) Where CompanyKey = @CompanyKey and Active = 1

	RETURN 1
GO
