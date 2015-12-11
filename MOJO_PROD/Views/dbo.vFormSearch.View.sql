USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vFormSearch]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View vFormSearch    Script Date: 10/3/01 10:46:11 AM ******/
CREATE VIEW [dbo].[vFormSearch]
AS
SELECT vFormFields.FieldName, 
    vFormFields.FormDefKey, vFormFields.FieldDefKey, 
    vFormFields.FormName, tForm.FormKey, 
    tFieldValue.FieldValue, tProject.ProjectName, 
    tForm.CompanyKey, 
    vFormFields.AssociatedEntity
FROM tFormDef INNER JOIN
    vFormFields INNER JOIN
    tForm ON 
    vFormFields.FormDefKey = tForm.FormDefKey ON 
    tFormDef.FormDefKey = tForm.FormDefKey LEFT OUTER
     JOIN
    tProject ON 
    tForm.ProjectKey = tProject.ProjectKey LEFT OUTER JOIN
    tFieldValue ON 
    tForm.CustomFieldKey = tFieldValue.ObjectFieldSetKey AND
     vFormFields.FieldDefKey = tFieldValue.FieldDefKey
WHERE (tFormDef.Active = 1)
GROUP BY vFormFields.FieldName, 
    vFormFields.FormDefKey, vFormFields.FieldDefKey, 
    vFormFields.FormName, tForm.FormKey, 
    tFieldValue.FieldValue, tProject.ProjectName, 
    tForm.CompanyKey, 
    vFormFields.AssociatedEntity
HAVING (vFormFields.AssociatedEntity = 'Forms')
GO
