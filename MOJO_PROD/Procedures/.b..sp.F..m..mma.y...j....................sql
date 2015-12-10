USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormSummaryProject]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormSummaryProject]
 (
  @CompanyKey int,
  @UserKey int,
  @ProjectKey int,
  @LastLogin smalldatetime
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
 CASE WHEN tForm.DateClosed IS NULL 
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
    tFormDef (nolock) LEFT OUTER JOIN tForm (nolock) ON tFormDef.FormDefKey = tForm.FormDefKey
    inner join tSecurityAccess (nolock) on tFormDef.FormDefKey = tSecurityAccess.EntityKey 
	inner join tUser (nolock) on tSecurityAccess.SecurityGroupKey = tUser.SecurityGroupKey
WHERE 
 tFormDef.CompanyKey = @CompanyKey AND
 tFormDef.WorkingLevel = 2 AND
 tForm.ProjectKey = @ProjectKey AND
 tForm.AssignedTo = @UserKey AND
 tFormDef.Active = 1 AND
 tUser.UserKey = @UserKey AND
 tSecurityAccess.Entity = 'tFormDef'
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
