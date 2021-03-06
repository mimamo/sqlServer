USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGetList]
	(
	 @UserKey int
	,@SecurityGroupKey int
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 02/13/08  RTC 1.0.0.0 Added ApplicationVersion checking
*/

    SELECT r.ReportKey, r.Name,
		ISNULL(rg.GroupName, 'Other Reports') as GroupName,
		ISNULL(rg.ReportGroupKey, 0) as ReportGroupKey,
		ISNULL(rg.DisplayOrder, 0) as DisplayOrder
    FROM   tReport r (NOLOCK)
	left outer join tReportGroup rg (nolock) on r.ReportGroupKey = rg.ReportGroupKey
    WHERE	ReportType = 0
    and ApplicationVersion = 1 
    and		((r.Private = 0 AND r.ReportKey IN 
				(SELECT rsg.ReportKey 
				FROM   tRptSecurityGroup rsg (NOLOCK)
				WHERE  rsg.SecurityGroupKey = @SecurityGroupKey))
			OR
			(r.UserKey = @UserKey))
	Order By DisplayOrder, GroupName, Name

	/* set nocount on */
	return 1
GO
