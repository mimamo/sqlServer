USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportDynamicUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptReportDynamicUpdate]

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
	,@GroupBy smallint
	,@ShowConditions tinyint
	,@GroupByDefinition text
	,@LockedColumns smallint
	,@AutoExpandGroups tinyint = 0
	
as --Encrypt
	
  /*
  || When     Who Rel      What
  || 04/22/08 GHL 8.5.0.9 (25353) Made @AutoExpandGroups optional for app7, app8, demo using CMP85 vb code 
  */

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
		,GroupBy = @GroupBy
		,ShowConditions = @ShowConditions
		,GroupByDefinition = @GroupByDefinition
		,LockedColumns = @LockedColumns
		,AutoExpandGroups = @AutoExpandGroups
	where ReportKey = @ReportKey

	return 1
GO
