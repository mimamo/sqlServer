USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vFormFields]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vFormFields]
AS
SELECT tFieldDef.FieldName, tFormDef.FormDefKey, 
    tFieldDef.FieldDefKey, tFormDef.FormName, 
    tFormDef.CompanyKey, 
    tFieldDef.AssociatedEntity
FROM tFieldDef INNER JOIN
    tFormDef ON 
    tFieldDef.OwnerEntityKey = tFormDef.CompanyKey
GROUP BY tFieldDef.FieldName, tFormDef.FormDefKey, 
    tFieldDef.FieldDefKey, tFormDef.FormName, 
    tFormDef.CompanyKey, 
    tFieldDef.AssociatedEntity
HAVING (tFieldDef.AssociatedEntity = 'Forms')
GO
