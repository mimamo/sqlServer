USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetGroupByKey]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGetGroupByKey]

	 @CompanyKey int
	,@ReportKey int
	
AS

		select   rsg.*
				,sg.*
		from tRptSecurityGroup rsg (nolock)
		inner join tReport rpt (nolock) on rpt.ReportKey = rsg.ReportKey
		inner join tSecurityGroup sg (nolock) on rsg.SecurityGroupKey = sg.SecurityGroupKey 
		where sg.CompanyKey = @CompanyKey 
		and rpt.ReportKey = @ReportKey
		order By sg.GroupName

	return 1
GO
