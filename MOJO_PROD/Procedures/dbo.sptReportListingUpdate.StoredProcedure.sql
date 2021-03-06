USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportListingUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptReportListingUpdate]

	 @ReportKey int
	,@Name varchar(255)
	,@FieldDefinition text
	,@Private int
	,@UserKey int
	,@ReportHeading1 varchar(200)
	,@ReportHeading1Align smallint
	,@ReportHeading2 varchar(200)
	,@ReportHeading2Align smallint
	,@Orientation smallint
	,@GroupByDefinition text
	,@ConditionDefinition text
	,@LockedColumns smallint
	,@AutoExpandGroups tinyint
	,@Deleted tinyint
	,@GroupBy tinyint
	,@ShowConditions tinyint
	,@ReportGroupKey int
	
as --Encrypt
                	
	update tReport
	set Name = @Name
		,FieldDefinition = @FieldDefinition
		,Private = @Private
		,UserKey = @UserKey
		,ReportHeading1 = @ReportHeading1
		,ReportHeading1Align = @ReportHeading1Align
		,ReportHeading2 = @ReportHeading2
		,ReportHeading2Align = @ReportHeading2Align
		,Orientation = @Orientation
		,GroupByDefinition = @GroupByDefinition
		,ConditionDefinition = @ConditionDefinition
		,LockedColumns = @LockedColumns
		,AutoExpandGroups = @AutoExpandGroups
		,Deleted = @Deleted
		,GroupBy = @GroupBy
		,ShowConditions = @ShowConditions
		,ReportGroupKey = @ReportGroupKey
	where ReportKey = @ReportKey

	return 1
GO
