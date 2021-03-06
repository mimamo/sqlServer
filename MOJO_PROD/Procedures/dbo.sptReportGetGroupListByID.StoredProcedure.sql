USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetGroupListByID]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptReportGetGroupListByID]

	 @CompanyKey int
	,@ReportID varchar(50)

AS --Encrypt

	select sg.SecurityGroupKey
		  ,sg.GroupName
		  ,ReportKey
	from tSecurityGroup sg (nolock) inner join tRptSecurityGroup rsg (nolock) on rsg.SecurityGroupKey = sg.SecurityGroupKey
	where sg.CompanyKey = @CompanyKey
	and sg.Active = 1
	and rsg.ReportKey in (select ReportKey from tReport (nolock) where ReportID = @ReportID and CompanyKey = @CompanyKey)

 return 1
GO
