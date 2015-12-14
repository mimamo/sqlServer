USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRptContactSnapshotProject]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRptContactSnapshotProject]
	@ContactUserKey int,
	@UserKey int
AS

/*
|| When     Who Rel     What
|| 06/11/09 MFT 10.500	Created for the ContactSnapshot active project subreport
|| 06/24/09 MFT 10.500	Changed name from sptProjectGetByUser, added BillingContact criteria
*/

SELECT
	p.*,
	pt.ProjectTypeName,
	p.ProjectNumber + ' ' + p.ProjectName AS ProjectFullName,
	ps.ProjectStatus,
	bs.ProjectBillingStatus
FROM
	tProject p (nolock)
	INNER JOIN tAssignment a (nolock)
		ON p.ProjectKey = a.ProjectKey
	LEFT JOIN tAssignment ca (nolock)
		ON p.ProjectKey = ca.ProjectKey
	LEFT JOIN tProjectType pt (nolock)
		ON p.ProjectTypeKey = pt.ProjectTypeKey
	LEFT JOIN tProjectStatus ps (nolock)
		ON p.ProjectStatusKey  = ps.ProjectStatusKey
	LEFT JOIN tProjectBillingStatus bs (nolock)
		ON p.ProjectBillingStatusKey = bs.ProjectBillingStatusKey
WHERE
	a.UserKey = @UserKey AND
	(
		ca.UserKey = @ContactUserKey OR
		p.BillingContact = @ContactUserKey
	) AND
	p.Active = 1
GO
