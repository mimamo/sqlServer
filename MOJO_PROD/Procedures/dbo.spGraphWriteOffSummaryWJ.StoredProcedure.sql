USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphWriteOffSummaryWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphWriteOffSummaryWJ]

	(
		@CompanyKey int,
		@OfficeKey int,
		@DepartmentKey int,
		@UserKey int,
		@StartDate varchar(10), -- The Date Range is calculated by Flex
		@EndDate   varchar(10),
		@GLCompanyKey int = null,
		@SessionUserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 10/3/07  GWG 8.4.3	    Fixed getting year to date calc
  || 01/15/08 QMD WMJ 1.0
  || 01/28/10 RLB 10.5.1.7  (73272) Changed Year to Date to FirstMonth <= Todays month
  || 11/12/10 RLB 10.5.3.8  (72300) Passing in Start and End dates per enhancement request 
  || 03/31/11 GWG 10.5.4.2  Reordered the @DepartmentKey is null to the beginning to speed up the query
  || 08/03/12 RLB 10.5.5.8  Changes for HMI and Added GLCompanyKey option 
  || 04/01/15 GHL 10.5.9.1 Specified source of DepartmentKey (ambiguous error)
  */
  


Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


SELECT	SUM(ROUND(tTime.ActualHours * tTime.ActualRate, 2)) AS Amount, ISNULL(ReasonName,'No Reason Specified') AS ReasonName
FROM	tTime (NOLOCK)	INNER JOIN tUser (nolock) on tUser.UserKey = tTime.UserKey  
						INNER JOIN tTimeSheet (NOLOCK) ON tTimeSheet.TimeSheetKey = tTime.TimeSheetKey
						LEFT OUTER JOIN tWriteOffReason (NOLOCK) ON tTime.WriteOffReasonKey = tWriteOffReason.WriteOffReasonKey
WHERE	tTimeSheet.CompanyKey = @CompanyKey
		AND tTime.WriteOff = 1
		AND WorkDate >= @StartDate 
		AND WorkDate <= @EndDate
		AND (@DepartmentKey IS NULL OR tUser.DepartmentKey = @DepartmentKey)
		AND (@OfficeKey IS NULL OR OfficeKey = @OfficeKey)
		AND (@UserKey IS NULL OR tTime.UserKey = @UserKey)
		AND (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
		AND (@UserKey IS NOT NULL OR (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 or tUser.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @SessionUserKey))))
GROUP BY ReasonName
ORDER BY Amount DESC
GO
