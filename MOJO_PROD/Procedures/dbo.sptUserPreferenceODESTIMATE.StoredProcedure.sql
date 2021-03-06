USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceODESTIMATE]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceODESTIMATE]
	(
		@UserKey INT
		,@Value int
	)
AS --Encrypt

	SET NOCOUNT ON 
	
	-- Value or Mode
	-- 1 = My Estimates
	-- 2 = All Estimates

/*
|| When     Who Rel	    What
|| 04/27/10 GHL	10.5.2.2 Removed inner join between tEstimate/tProject
|| 06/04/12 GHL 10.556   Added logic for GL Company restrict
*/

	Declare @CompanyKey int
			,@RestrictToGLCompany int

	Select @CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		  ,@RestrictToGLCompany = ISNULL(p.RestrictToGLCompany, 0)
	from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	DECLARE @CurrentDate DATETIME

	select @CurrentDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)
	
	SELECT e.*
			,c.CustomerID   AS ClientID
		    ,c.CompanyName   AS ClientName
		    ,p.ProjectNumber
		    ,p.ProjectName
			,CASE WHEN e.InternalStatus = 2
				  THEN ISNULL(ia.FirstName, '') + ' ' + ISNULL(ia.LastName, '') 
			  	  ELSE ISNULL(ea.FirstName, '') + ' ' + ISNULL(ea.LastName, '') 
			 END  As ApproverName
			,CASE WHEN e.InternalStatus = 2
				  THEN e.InternalDueDate 
			  	  ELSE e.ExternalDueDate 
			 END  As DueDate
			 
	FROM   tEstimate e (NOLOCK)
		INNER JOIN vEstimateClient vec (NOLOCK) ON e.EstimateKey = vec.EstimateKey
		LEFT JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tCompany c (NOLOCK) ON vec.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tUser ia (NOLOCK) ON e.InternalApprover = ia.UserKey
		LEFT OUTER JOIN tUser ea (NOLOCK) ON e.ExternalApprover = ea.UserKey
	WHERE	e.CompanyKey = @CompanyKey
	AND		isnull(p.Active, 1) = 1
	AND		isnull(p.Closed, 0) = 0
	AND		(@Value = 2 OR e.InternalApprover = @UserKey)
	AND		(
			(e.InternalStatus = 2
			 AND e.InternalDueDate IS NOT NULL
			 AND e.InternalDueDate	< @CurrentDate
			 )
			 OR
			 (ISNULL(e.ExternalApprover, 0) > 0 
			 AND e.ExternalStatus = 2
			 AND e.ExternalDueDate IS NOT NULL
			 AND e.ExternalDueDate	< @CurrentDate
			 )	
			)		
	and (@RestrictToGLCompany = 0 OR 
	    p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)
	RETURN 1
GO
