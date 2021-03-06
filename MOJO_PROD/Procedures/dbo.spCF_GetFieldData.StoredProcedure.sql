USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_GetFieldData]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_GetFieldData]
 @ObjectFieldSetKey int
 
AS --Encrypt

/*
|| When      Who Rel     What
|| 05/21/10  MFT 10.530  Added QualifiedFieldName
*/

SELECT 
	tFieldDef.*,
	tFieldSetField.DisplayOrder,
	tFieldValue.FieldValue,
	tFieldValue.FieldValueKey,
	tFieldSet.FieldSetKey,
	'CF_' + tFieldDef.AssociatedEntity + '_' + tFieldDef.FieldName AS QualifiedFieldName
FROM 
	tFieldValue (NOLOCK) RIGHT OUTER JOIN
	tFieldDef (NOLOCK) INNER JOIN tFieldSetField (NOLOCK) ON
	tFieldDef.FieldDefKey = tFieldSetField.FieldDefKey RIGHT OUTER JOIN
	tFieldSet (NOLOCK) INNER JOIN tObjectFieldSet (NOLOCK) ON
	tFieldSet.FieldSetKey = tObjectFieldSet.FieldSetKey ON
	tFieldSetField.FieldSetKey = tFieldSet.FieldSetKey ON
	tFieldValue.ObjectFieldSetKey = tObjectFieldSet.ObjectFieldSetKey
	AND tFieldValue.FieldDefKey = tFieldDef.FieldDefKey
WHERE
	tObjectFieldSet.ObjectFieldSetKey = @ObjectFieldSetKey
	AND tFieldDef.Active = 1
ORDER BY
	tFieldSetField.DisplayOrder
GO
