USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportDynamicInsert]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptReportDynamicInsert]

	 @Name varchar(255)
	,@ReportType smallint
	,@FieldDefinition text
	,@Private int
	,@UserKey int
	,@CompanyKey int
	,@ReportHeading1 varchar(200)
	,@ReportHeading1Align smallint
	,@ReportHeading2 varchar(200)
	,@ReportHeading2Align smallint
	,@Orientation smallint
	,@GroupBy smallint
	,@ShowConditions tinyint
	,@ReportID varchar(50)
	,@GroupByDefinition text
	,@LockedColumns smallint
	,@DefaultReportKey int
	,@AutoExpandGroups tinyint = 0
	,@oIdentity INT OUTPUT
	
as --Encrypt
	
  /*
  || When     Who Rel      What
  || 04/22/08 GHL 8.5.0.9 (25353) Made @AutoExpandGroups optional for app7, app8, demo using CMP85 vb code 
  */

	insert tReport
		(
		Name
		,ReportType
		,FieldDefinition
		,Private
		,UserKey
		,CompanyKey
		,ReportHeading1
		,ReportHeading1Align
		,ReportHeading2
		,ReportHeading2Align
		,Orientation
		,GroupBy
		,ShowConditions
		,ReportID
		,GroupByDefinition
		,LockedColumns
		,DefaultReportKey
		,AutoExpandGroups
		)

	values
		(
		@Name
		,@ReportType
		,@FieldDefinition 
		,@Private
		,@UserKey
		,@CompanyKey
		,@ReportHeading1
		,@ReportHeading1Align
		,@ReportHeading2
		,@ReportHeading2Align
		,@Orientation
		,@GroupBy
		,@ShowConditions
		,@ReportID
		,@GroupByDefinition 
		,@LockedColumns
		,@DefaultReportKey
		,@AutoExpandGroups
		)
	
	select @oIdentity = @@IDENTITY

	return 1
GO
