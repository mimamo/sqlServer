USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportListingUpdateP]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptReportListingUpdateP]

	 @ReportKey int
	,@CompanyKey int
	,@ViewKey int
	,@ReportType smallint
	,@ReportID varchar(50)
	,@DefaultReportKey int
	,@ReportFilter varchar(50)
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
	,@GroupBy tinyint
	,@ShowConditions tinyint
	,@ReportGroupKey int
	,@AutoRun tinyint = 0
	,@Description varchar(max) = NULL
	
as --Encrypt
        
        
if @ReportKey <= 0
BEGIN
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
		,ReportFilter
		,GroupBy
		,ShowConditions 
		,ReportGroupKey
		,ApplicationVersion
		,AutoRun
		,Description
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
		,@ReportFilter
		,@GroupBy
		,@ShowConditions
		,@ReportGroupKey	
		,2	
		,@AutoRun
		,@Description
		)
	
	select @ReportKey = @@IDENTITY

END
ELSE
BEGIN
        	
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
		,GroupBy = @GroupBy
		,ShowConditions = @ShowConditions
		,ReportGroupKey = @ReportGroupKey
		,AutoRun = @AutoRun
		,Description = @Description
	where ReportKey = @ReportKey
END
	return @ReportKey
GO
