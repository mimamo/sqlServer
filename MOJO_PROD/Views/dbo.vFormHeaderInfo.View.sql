USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vFormHeaderInfo]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vFormHeaderInfo]
AS
SELECT tForm.FormKey, tFormDef.FormName, 
    tFormDef.FormPrefix, tForm.FormNumber, 
    ISNULL(LEFT(tCompany.CompanyName, 25) + '  \  ', '') 
    + LEFT(tProject.ProjectName, 25) AS ProjectName, 
    tUser.FirstName + ' ' + tUser.LastName AS Author, 
    tUser1.FirstName + ' ' + tUser1.LastName AS AssignedTo, 
    tForm.DateCreated, tForm.DateClosed, tForm.Subject, 
    tForm.DueDate, tForm.Priority, 
    CASE Priority WHEN 1 THEN 'High' WHEN 2 THEN 'Medium' WHEN
     3 THEN 'Low' END AS PriorityText, 
    tForm.CustomFieldKey
FROM tCompany RIGHT OUTER JOIN
    tProject ON 
    tCompany.CompanyKey = tProject.ClientKey RIGHT OUTER JOIN
    tUser tUser1 RIGHT OUTER JOIN
    tForm INNER JOIN
    tFormDef ON 
    tForm.FormDefKey = tFormDef.FormDefKey INNER JOIN
    tUser ON tForm.Author = tUser.UserKey ON 
    tUser1.UserKey = tForm.AssignedTo ON 
    tProject.ProjectKey = tForm.ProjectKey
GO
