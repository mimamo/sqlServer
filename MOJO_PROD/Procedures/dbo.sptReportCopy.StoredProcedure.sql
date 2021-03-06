USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportCopy]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReportCopy]
 (
  @OldReportKey int,
  @NewName varchar(255),
  @NewReportKey int OUTPUT
 )
AS --Encrypt

/*
|| When       Who Rel     What
|| 04/29/08   RTC 1.0.0.0 Modified to insert application version.  Hardcoded to 1, WMJ does not use this procedure
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
	ReportGroupKey,
	ReportHeading1,
	ReportHeading1Align,
	ReportHeading2,
	ReportHeading2Align,
	Orientation,
	GroupBy,
	ApplicationVersion
	)
Select
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
	1
  FROM tReport (NOLOCK)
  WHERE ReportKey = @OldReportKey
  
  SELECT @NewReportKey = @@IDENTITY
  
  Update tReport Set Name = @NewName Where ReportKey = @NewReportKey
   
  INSERT tRptSecurityGroup (ReportKey, SecurityGroupKey)
  SELECT @NewReportKey
        ,SecurityGroupKey
  FROM   tRptSecurityGroup (NOLOCK) 
  WHERE  ReportKey = @OldReportKey
  
 /* set nocount on */
 return 1
GO
