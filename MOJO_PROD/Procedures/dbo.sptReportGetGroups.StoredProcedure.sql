USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetGroups]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGetGroups]

	 @CompanyKey int
	,@ReportKey int
	
AS


if @ReportKey <= 0
	select   sg.SecurityGroupKey, sg.GroupName, 1 as Selected
	from tSecurityGroup sg (nolock)
	where sg.CompanyKey = @CompanyKey 
	order By sg.GroupName
else
	select   sg.SecurityGroupKey, sg.GroupName, 
		ISNULL((Select 1 from tRptSecurityGroup rsg (nolock) Where rsg.SecurityGroupKey = sg.SecurityGroupKey and rsg.ReportKey = @ReportKey), 0) as Selected
	from tSecurityGroup sg (nolock)
	where sg.CompanyKey = @CompanyKey 
	order By sg.GroupName
		
		
	return 1
GO
