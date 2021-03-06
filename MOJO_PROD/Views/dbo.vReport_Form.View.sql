USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Form]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel      What
  || 10/11/06 WES 8.3567   Added Account Manager
  || 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
  || 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
  */


CREATE   VIEW [dbo].[vReport_Form]
AS
SELECT     tForm.CompanyKey, 
	tFormDef.FormName, 
	tFormDef.FormPrefix, 
	tProject.ProjectName, 
	tProject.ProjectNumber, 
	tTask.TaskID, 
	tTask.TaskName, 
	tForm.FormNumber, 
	tUser.FirstName + ' ' + tUser.LastName AS AuthorName, 
	tForm.DateCreated, 
	tForm.DateClosed, 
	tUser_1.FirstName + ' ' + tUser_1.LastName AS AssignedTo, 
	tForm.Subject, tForm.DueDate, 
	tForm.Priority, 
	tForm.CustomFieldKey, 
	tCompany.CompanyName,
	AM.FirstName + ' ' + AM.LastName AS AccountManager,
	tProject.ProjectKey,
	cd.DivisionID as ClientDivisionID,
    cd.DivisionName as ClientDivision,
    cp.ProductID as ClientProductID,
    cp.ProductName as ClientProduct
FROM tForm 
INNER JOIN tFormDef ON tForm.FormDefKey = tFormDef.FormDefKey 
INNER JOIN tUser ON tForm.Author = tUser.UserKey 
LEFT OUTER JOIN tCompany ON tForm.ContactCompanyKey = tCompany.CompanyKey 
LEFT OUTER JOIN  tUser tUser_1 ON tForm.AssignedTo = tUser_1.UserKey 
LEFT OUTER JOIN tTask ON tForm.TaskKey = tTask.TaskKey 
LEFT OUTER JOIN tProject ON tForm.ProjectKey = tProject.ProjectKey
LEFT OUTER JOIN tUser AM on tProject.AccountManager = AM.UserKey
LEFT OUTER JOIN tClientDivision cd (nolock) on tProject.ClientDivisionKey = cd.ClientDivisionKey
LEFT OUTER JOIN tClientProduct  cp (nolock) on tProject.ClientProductKey  = cp.ClientProductKey
GO
