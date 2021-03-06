USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormGet]
 @FormKey int
AS --Encrypt

  /*
  || When     Who  Rel   What
  || 08/25/08 GHL  8.518  (32528) Added Working Level to display project on UI depending on level            
  || 10/19/12 WDF 10.561 (157430) Added FormType to determine what fields to print          
  */

SELECT 
	f.*, 
	fd.FormName,
	fd.FormPrefix,
	fd.WorkingLevel,
	fd.FormType,
	p.ProjectNumber,
	p.ProjectName,
	p.ProjectNumber + ' - ' + p.ProjectName as ClientProject,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
    au.FirstName + ' ' + au.LastName AS AuthorName, 
    ass.FirstName + ' ' + ass.LastName AS AssignedUserName,
    au.Email AS AuthorEmail, 
    ass.Email AS AssignedToEmail,
    c.CompanyName as ContactCompanyName
FROM 
	tForm f (nolock) 
	inner join tFormDef fd (nolock) on f.FormDefKey = fd.FormDefKey
	inner join tUser au (nolock) on f.Author = au.UserKey
	Left outer join tProject p (nolock) on f.ProjectKey = p.ProjectKey
	Left Outer Join tTask t (nolock) on f.TaskKey = t.TaskKey
	Left Outer Join tUser ass (nolock) on f.AssignedTo = ass.UserKey
	Left Outer Join tCompany c (nolock) on f.ContactCompanyKey = c.CompanyKey

WHERE
 f.FormKey = @FormKey
 
 RETURN 1
GO
