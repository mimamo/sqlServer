USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormSummaryAllProjects]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormSummaryAllProjects]

	(
		@CompanyKey int,
		@WorkingLevel int,
		@LastLogin smalldatetime,
		@UserKey int
	)

AS --Encrypt


SELECT 
	tFormDef.CompanyKey, 
	tFormDef.FormName, 
	tFormDef.FormDefKey,
    tFormDef.FormPrefix, 
	tFormDef.WorkingLevel, 
    tFormDef.FormType, 
	COUNT(tForm.FormKey) AS TotalForms,
	SUM(
	CASE WHEN tForm.DateClosed IS NULL AND NOT tForm.FormKey IS NULL
		THEN 1
		ELSE 0
	END ) as TotalOpen,
	SUM(
	CASE WHEN tForm.DueDate < GETDATE() AND tForm.DateClosed IS NULL
		THEN 1
		ELSE 0
	END ) as TotalLate,
	SUM(
	CASE WHEN tForm.DateCreated >= @LastLogin
		THEN 1
		ELSE 0
	END ) as TotalNew
FROM 
	tFormDef (nolock), 
	tForm (nolock),
	tAssignment (nolock),
	tProject (nolock),
	tSecurityAccess (nolock),
	tUser (nolock)	
WHERE 
	tFormDef.FormDefKey = tForm.FormDefKey and 
	tFormDef.CompanyKey = @CompanyKey AND
	tFormDef.WorkingLevel = @WorkingLevel AND
	tFormDef.Active = 1 and
	tForm.ProjectKey = tAssignment.ProjectKey and
	tForm.AssignedTo = @UserKey AND
	tAssignment.UserKey = @UserKey and
	tAssignment.ProjectKey = tProject.ProjectKey and
	tProject.Active = 1 and
	tUser.UserKey = @UserKey and
	tUser.SecurityGroupKey = tSecurityAccess.SecurityGroupKey and
	tSecurityAccess.Entity = 'tFormDef' and
	tSecurityAccess.EntityKey = tFormDef.FormDefKey	
GROUP BY 
	tFormDef.CompanyKey, 
	tFormDef.FormName, 
	tFormDef.FormDefKey,
    tFormDef.FormPrefix, 
    tFormDef.WorkingLevel, 
    tFormDef.FormType
ORDER BY
	tFormDef.FormName
GO
