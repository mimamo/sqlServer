USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByProjectDetailTotalLabor]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByProjectDetailTotalLabor]
	@CompanyKey int,
	@GLCompanyKey int,
	@ProjectKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AllocateBy int,
	@UserKey int = null,
	@ClientHours decimal(24,4) OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/27/08  CRG 10.0.1.1 (33250) Created for the Profit By Project Detail report
|| 04/11/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


	IF @AllocateBy IN (2, 3)
		SELECT	@ClientHours = ISNULL(SUM(ActualHours), 0)
		FROM	#tTime
		WHERE	ProjectKey = @ProjectKey
	ELSE
		SELECT	@ClientHours = SUM(ISNULL(t.ActualHours, 0))
		FROM	tTime t (nolock)
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		WHERE	t.WorkDate >= @StartDate 
		AND		t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		p.ProjectKey = @ProjectKey
		--AND		(ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)
GO
