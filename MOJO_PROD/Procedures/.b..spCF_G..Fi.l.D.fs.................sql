USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_GetFieldDefs]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_GetFieldDefs]
 @Entity varchar(50),
 @EntityKey int
 
 
AS --Encrypt
SELECT 
	fd.FieldName,
	fd.DisplayType,
	fd.Caption,
	fd.Hint,
	fd.Size,
	fd.MinSize,
	fd.MaxSize,
	fd.ValueList,
	fd.Required,
	fd.OnlyAuthorEdit,
	fd.MapTo,
	fsf.DisplayOrder,
	fs.FieldSetKey,
	fd.FieldDefKey
FROM 
 tFieldDef fd (NOLOCK) 
 INNER JOIN tFieldSetField fsf (NOLOCK) ON fd.FieldDefKey = fsf.FieldDefKey 
    RIGHT OUTER JOIN tFieldSet fs (NOLOCK) ON fsf.FieldSetKey = fs.FieldSetKey
    
WHERE 
 fs.AssociatedEntity = @Entity
 AND fs.OwnerEntityKey = @EntityKey
 AND fd.Active = 1
ORDER BY 
 fsf.DisplayOrder
GO
