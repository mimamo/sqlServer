USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_GetFieldSetFields]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_GetFieldSetFields]
 @FieldSetKey int
AS --Encrypt
SELECT 
	tFieldDef.*,
    tFieldSetField.DisplayOrder,
    tFieldSet.FieldSetKey
FROM 
 tFieldDef (NOLOCK) INNER JOIN tFieldSetField (NOLOCK) ON 
    tFieldDef.FieldDefKey = tFieldSetField.FieldDefKey RIGHT OUTER JOIN
    tFieldSet (NOLOCK) ON tFieldSetField.FieldSetKey = tFieldSet.FieldSetKey
    
WHERE 
 tFieldSet.FieldSetKey = @FieldSetKey
 AND tFieldDef.Active = 1
ORDER BY 
 tFieldSetField.DisplayOrder
GO
