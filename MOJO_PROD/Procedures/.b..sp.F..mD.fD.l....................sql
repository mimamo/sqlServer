USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefDelete]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDefDelete]
 @FormDefKey int
AS --Encrypt

Declare @FieldSetKey int

if exists(select 1 from tForm (nolock) Where FormDefKey = @FormDefKey)
	return -1
	
Select @FieldSetKey = FieldSetKey from tFieldSet (nolock) Where AssociatedEntity = 'Forms' and OwnerEntityKey = @FormDefKey

 DELETE
 FROM tFieldValue
 WHERE
  ObjectFieldSetKey in (Select ObjectFieldSetKey from tObjectFieldSet Where FieldSetKey = @FieldSetKey)
  
 DELETE
 FROM tObjectFieldSet
 WHERE
  FieldSetKey = @FieldSetKey 
  
 DELETE
 FROM tFieldSetField
 WHERE
  FieldSetKey = @FieldSetKey 

 DELETE
 FROM tFieldSet
 WHERE
  FieldSetKey = @FieldSetKey 

 DELETE
 FROM tFormDef
 WHERE
  FormDefKey = @FormDefKey 
 RETURN 1
GO
