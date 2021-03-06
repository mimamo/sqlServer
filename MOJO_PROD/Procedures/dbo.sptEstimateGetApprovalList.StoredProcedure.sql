USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetApprovalList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetApprovalList]
	(
		@CompanyKey int,
		@UserKey int,
		@ChangeOrder int
	)
AS -- Encrypt

	SET NOCOUNT ON
	
		SELECT 
			e.*
			,p.ProjectNumber
			,p.ProjectName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail	
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = @ChangeOrder
		AND    e.InternalStatus = 2
		AND    e.InternalApprover = @UserKey
		AND    p.CompanyKey = @CompanyKey
		
	UNION ALL
	
		SELECT 
			e.*
			,p.ProjectNumber
			,p.ProjectName
			,e.EstimateName + ' - ' + cast(e.Revision as varchar(10)) as EstimateFullName
			,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS EnteredByName
			,isnull(u.Email, '') AS EnteredByEmail	
			,isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') AS InternalApproverName			
			,isnull(u2.Email, '') AS InternalApproverEmail	
		FROM   tEstimate  e (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON e.EnteredBy = u.UserKey
			LEFT OUTER JOIN tUser u2 (NOLOCK) ON e.InternalApprover = u2.UserKey
		WHERE  e.ChangeOrder = @ChangeOrder
		AND	   e.InternalStatus = 4
		AND    e.ExternalStatus = 2
		AND    e.ExternalApprover = @UserKey
		AND    p.CompanyKey = @CompanyKey
	
	RETURN 1
GO
