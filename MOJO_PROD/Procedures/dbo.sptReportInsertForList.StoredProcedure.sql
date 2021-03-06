USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportInsertForList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportInsertForList]
	@ViewKey int,
	@Name varchar(255),
	@Private int,
	@UserKey int,
	@CompanyKey int,
	@FieldDefinition text,
	@ConditionDefinition text,
	@GroupBy smallint,
	@ReportFilter varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 05/08/08 RTC 8.5.1   Added ApplicationVersion = 1 for compatibility with WMJ.
*/

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
		GroupBy,
		ReportFilter,
		ApplicationVersion
		)

	VALUES
		(
		@ViewKey,
		@Name,
		1,
		@FieldDefinition,
		@ConditionDefinition,
		@Private,
		@UserKey,
		@CompanyKey,
		@GroupBy,
		@ReportFilter,
		1
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	Insert Into tRptSecurityGroup (ReportKey, SecurityGroupKey)
	Select @oIdentity, SecurityGroupKey from tSecurityGroup (NOLOCK) Where CompanyKey = @CompanyKey and Active = 1

	RETURN 1
GO
