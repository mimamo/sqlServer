USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectResourceUtilization]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectResourceUtilization]
    @CompanyKey int,
	@UserKey int,
	@StartDate datetime,
	@EndDate datetime,
	@ResourceUserKey int = NULL
AS

/*
|| When      Who Rel     What
|| 09/14/12  MFT 10.560  Created
|| 09/19/12  MFT 10.560  Added @ResourceUserKey
|| 01/28/15  GHL 10.588  Added @CompanyKey to use with Abelson Taylor
*/
DECLARE
	@TempDate datetime,
	@DayCount int

SELECT
	@TempDate = @StartDate,
	@DayCount = 0

WHILE @TempDate <= @EndDate
	BEGIN
		IF DATEPART(dw, @TempDate) BETWEEN 2 AND 6 SET @DayCount = @DayCount + 1
			SET @TempDate = DATEADD(d, 1, @TempDate)
	END

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int, GLCompanyName varchar(500))

SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF @RestrictToGLCompany = 0
	BEGIN --@RestrictToGLCompany = 0
		--All GLCompanyKeys + 0 to get NULLs
		INSERT INTO @tGLCompanies VALUES(0, NULL)
		INSERT INTO @tGLCompanies
			SELECT GLCompanyKey, GLCompanyName
			FROM tGLCompany (nolock)
			WHERE CompanyKey = @CompanyKey
	END --@RestrictToGLCompany = 0
ELSE
	BEGIN --@RestrictToGLCompany = 1
		 --Only GLCompanyKeys @UserKey has access to
		INSERT INTO @tGLCompanies
			SELECT glc.GLCompanyKey, glc.GLCompanyName
			FROM
				tUserGLCompanyAccess gla (nolock)
				INNER JOIN tGLCompany glc (nolock) ON gla.GLCompanyKey = glc.GLCompanyKey
			WHERE UserKey = @UserKey
	END --@RestrictToGLCompany = 1
--GL Company restrictions
------------------------------------------------------------

DECLARE @tResourceHours table
	(
		UserKey int,
		GLCompanyKey int,
		GLCompanyName varchar(500),
		Title varchar(200),
		FullName varchar(200),
		DepartmentKey int,
		DepartmentName varchar(200),
		OfficeKey int,
		OfficeName varchar(200),
		BasisHours decimal(10, 4),
		BillableHours decimal(10, 4),
		BillableHoursPct decimal(5, 2),
		PTOHours decimal(10, 4),
		PTOHoursPct decimal(5, 2),
		PitchHours decimal(10, 4),
		PitchHoursPct decimal(5, 2),
		InternalHours decimal(10, 4),
		InternalHoursPct decimal(5, 2),
		GAHours decimal(10, 4),
		GAHoursPct decimal(5, 2),
		TrainingHours decimal(10, 4),
		TrainingHoursPct decimal(5, 2),
		TotalHours decimal(10, 4),
		TotalHoursPct decimal(5, 2)
	)



INSERT INTO @tResourceHours
	(
		UserKey,
		GLCompanyKey,
		GLCompanyName,
		Title,
		FullName,
		DepartmentKey,
		DepartmentName,
		OfficeKey,
		OfficeName,
		BasisHours,
		BillableHours,
		BillableHoursPct,
		PTOHours,
		PTOHoursPct,
		PitchHours,
		PitchHoursPct,
		InternalHours,
		InternalHoursPct,
		GAHours,
		GAHoursPct,
		TrainingHours,
		TrainingHoursPct,
		TotalHours,
		TotalHoursPct
	)
SELECT
	u.UserKey,
	ISNULL(u.GLCompanyKey, 0),
	glc.GLCompanyName,
	u.Title,
	u.FirstName + ' ' + u.LastName,
	ISNULL(d.DepartmentKey, 0),
	d.DepartmentName,
	ISNULL(o.OfficeKey, 0),
	o.OfficeName,
	@DayCount * 8,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
FROM
	tUser u (nolock)
	INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
	LEFT JOIN tDepartment d (nolock) ON u.DepartmentKey = d.DepartmentKey
	LEFT JOIN tOffice o (nolock) ON u.OfficeKey = o.OfficeKey
WHERE
	u.UserKey = ISNULL(@ResourceUserKey, u.UserKey)
and isnull(u.OwnerCompanyKey,u.CompanyKey) = @CompanyKey  

UPDATE
	@tResourceHours
SET
	BasisHours = BasisHours - st.PTOHours,
	PTOHours = st.PTOHours,
	BillableHours = st.BillableHours,
	TrainingHours = st.TrainingHours,
	PitchHours = st.PitchHours,
	InternalHours = st.InternalHours,
	GAHours = st.GAHours,
	TotalHours = st.TotalHours
FROM
	@tResourceHours r
	INNER JOIN (
		SELECT
			UserKey,
			SUM(BillableHours) AS BillableHours,
			SUM(PTOHours) AS PTOHours,
			SUM(TrainingHours) AS TrainingHours,
			SUM(PitchHours) AS PitchHours,
			SUM(InternalHours) AS InternalHours,
			SUM(GAHours) AS GAHours,
			SUM(TotalHours) AS TotalHours
		FROM
			(
				SELECT
					t.UserKey,
					CASE p.NonBillable WHEN 0 THEN SUM(t.ActualHours) ELSE 0 END AS BillableHours,
					CASE p.UtilizationType WHEN 'PTO' THEN SUM(t.ActualHours) ELSE 0 END AS PTOHours,
					CASE p.UtilizationType WHEN 'Training' THEN SUM(t.ActualHours) ELSE 0 END AS TrainingHours,
					CASE p.UtilizationType WHEN 'Pitch' THEN SUM(t.ActualHours) ELSE 0 END AS PitchHours,
					CASE p.UtilizationType WHEN 'Internal' THEN SUM(t.ActualHours) ELSE 0 END AS InternalHours,
					CASE p.UtilizationType WHEN 'GA' THEN SUM(t.ActualHours) ELSE 0 END AS GAHours,
					SUM(t.ActualHours) AS TotalHours
				FROM
					tTime t (nolock)
					INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
				WHERE
					t.WorkDate >= @StartDate AND
					t.WorkDate <= @EndDate AND
					p.CompanyKey = @CompanyKey
				GROUP BY
					t.UserKey,
					p.UtilizationType,
					p.NonBillable
			) a
		GROUP BY
			UserKey
	) st ON r.UserKey = st.UserKey

UPDATE
	@tResourceHours
SET
	BillableHoursPct = CASE WHEN BasisHours > 0 THEN BillableHours/BasisHours ELSE 0 END,
	PTOHoursPct = CASE WHEN BasisHours > 0 THEN PTOHours/BasisHours ELSE 0 END,
	PitchHoursPct = CASE WHEN BasisHours > 0 THEN PitchHours/BasisHours ELSE 0 END,
	InternalHoursPct = CASE WHEN BasisHours > 0 THEN InternalHours/BasisHours ELSE 0 END,
	GAHoursPct = CASE WHEN BasisHours > 0 THEN GAHours/BasisHours ELSE 0 END,
	TrainingHoursPct = CASE WHEN BasisHours > 0 THEN TrainingHours/BasisHours ELSE 0 END,
	TotalHoursPct = CASE WHEN BasisHours > 0 THEN TotalHours/BasisHours ELSE 0 END

SELECT * FROM @tResourceHours
GO
