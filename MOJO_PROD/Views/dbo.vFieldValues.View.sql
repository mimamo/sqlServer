USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vFieldValues]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View vFieldValues    Script Date: 10/3/01 10:46:11 AM ******/
CREATE VIEW [dbo].[vFieldValues]
AS
SELECT 
 tObjectFieldSet.ObjectFieldSetKey, 
     tFieldDef.FieldDefKey, tFieldDef.FieldName, 
     tFieldDef.DisplayType, tFieldValue.FieldValue
FROM 
 tFieldValue RIGHT OUTER JOIN
     tFieldDef INNER JOIN
 tFieldSetField ON 
     tFieldDef.FieldDefKey = tFieldSetField.FieldDefKey RIGHT OUTER JOIN
 tFieldSet INNER JOIN tObjectFieldSet ON 
     tFieldSet.FieldSetKey = tObjectFieldSet.FieldSetKey ON
      tFieldSetField.FieldSetKey = tFieldSet.FieldSetKey ON 
     tFieldValue.ObjectFieldSetKey = tObjectFieldSet.ObjectFieldSetKey
      AND tFieldValue.FieldDefKey = tFieldDef.FieldDefKey
GO
