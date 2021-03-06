USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetFieldGet]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetFieldGet]
 @FieldSetKey int
AS --Encrypt
 SELECT 
  tFieldDef.FieldName, 
  tFieldSetField.FieldDefKey, 
  tFieldSetField.DisplayOrder,
  CASE tFieldDef.DisplayType
	WHEN 8 THEN '---' + tFieldDef.FieldName + '---'
	ELSE tFieldDef.FieldName
  END as FieldDisplayName
 FROM 
  tFieldDef (NOLOCK) INNER JOIN tFieldSetField (NOLOCK) ON 
  tFieldDef.FieldDefKey = tFieldSetField.FieldDefKey
 WHERE 
  tFieldSetField.FieldSetKey = @FieldSetKey
 ORDER BY 
  tFieldSetField.DisplayOrder
 RETURN 1
GO
