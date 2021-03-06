USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportListingInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptReportListingInsert]

	 @Name varchar(255)
	,@ReportType smallint
	,@FieldDefinition text
	,@Private int
	,@UserKey int
	,@CompanyKey int
	,@ViewKey int
	,@ReportHeading1 varchar(200)
	,@ReportHeading1Align smallint
	,@ReportHeading2 varchar(200)
	,@ReportHeading2Align smallint
	,@Orientation smallint
	,@ReportID varchar(50)
	,@GroupByDefinition text
	,@ConditionDefinition text
	,@LockedColumns smallint
	,@DefaultReportKey int
	,@AutoExpandGroups tinyint
	,@Deleted tinyint
	,@ReportFilter varchar(50)
	,@GroupBy tinyint
	,@ShowConditions tinyint
	,@ReportGroupKey int	
	,@oIdentity INT OUTPUT
	
as --Encrypt

/*
|| When      Who Rel     What
|| 02/13/08  RTC 1.0.0.0 Added ApplicationVersion value
*/
                	
	insert tReport
		(
		Name
		,ReportType
		,FieldDefinition
		,Private
		,UserKey
		,CompanyKey
		,ViewKey
		,ReportHeading1
		,ReportHeading1Align
		,ReportHeading2
		,ReportHeading2Align
		,Orientation
		,ReportID
		,GroupByDefinition
		,ConditionDefinition
		,LockedColumns
		,DefaultReportKey
		,AutoExpandGroups
		,Deleted
		,ReportFilter
		,GroupBy
		,ShowConditions 
		,ReportGroupKey
		,ApplicationVersion
		)

	values
		(
		@Name
		,@ReportType
		,@FieldDefinition 
		,@Private
		,@UserKey
		,@CompanyKey
		,@ViewKey
		,@ReportHeading1
		,@ReportHeading1Align
		,@ReportHeading2
		,@ReportHeading2Align
		,@Orientation
		,@ReportID
		,@GroupByDefinition 
		,@ConditionDefinition
		,@LockedColumns
		,@DefaultReportKey
		,@AutoExpandGroups
		,@Deleted
		,@ReportFilter
		,@GroupBy
		,@ShowConditions
		,@ReportGroupKey	
		,2	
		)
	
	select @oIdentity = @@IDENTITY

	return 1
GO
