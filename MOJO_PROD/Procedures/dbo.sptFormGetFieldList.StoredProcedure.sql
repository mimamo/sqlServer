USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormGetFieldList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormGetFieldList]
 (
  @CompanyKey int
 )
AS --Encrypt
 SELECT 
  tFieldDef.FieldName, 
  tFieldDef.Caption
 FROM 
  tFieldDef (nolock) INNER JOIN tFieldSetField (nolock) ON 
     tFieldDef.FieldDefKey = tFieldSetField.FieldDefKey INNER JOIN
     tFieldSet (nolock) ON tFieldSetField.FieldSetKey = tFieldSet.FieldSetKey
 WHERE 
	tFieldSet.AssociatedEntity = 'Forms' AND 
    tFieldDef.OwnerEntityKey = @CompanyKey AND
    tFieldDef.DisplayType <> 8
 GROUP BY 
  tFieldDef.FieldName, 
  tFieldDef.Caption
 ORDER BY 
  tFieldDef.Caption
GO
