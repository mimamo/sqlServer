USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetDelete]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetDelete]
 @FieldSetKey int
AS --Encrypt

 -- 'Child Restrict' type of situation
 DECLARE @AssociatedEntity VARCHAR(50) 
 
 SELECT @AssociatedEntity = AssociatedEntity
 FROM   tFieldSet (NOLOCK)
 WHERE  FieldSetKey = @FieldSetKey
 
 IF @AssociatedEntity = 'Spec'
 BEGIN
	IF EXISTS (SELECT 1
				FROM  tRequestDefSpec (NOLOCK)
				WHERE FieldSetKey = @FieldSetKey)
		RETURN -1 
 	IF EXISTS (SELECT 1
				FROM  tSpecSheet (NOLOCK)
				WHERE FieldSetKey = @FieldSetKey)
		RETURN -1 
 END
 
 
 Delete tFieldValue
 Where ObjectFieldSetKey in (Select ObjectFieldSetKey from tObjectFieldSet (nolock) Where FieldSetKey = @FieldSetKey)
 
 Delete tObjectFieldSet Where FieldSetKey = @FieldSetKey
 
 DELETE
 FROM tFieldSetField
 WHERE
  FieldSetKey = @FieldSetKey 
  
  
 DELETE
 FROM tFieldSet
 WHERE
  FieldSetKey = @FieldSetKey 
 
 -- 'Cascade Delete' type of situation
  
 Update tPurchaseOrderType
 Set HeaderFieldSetKey = NULL
 Where
	HeaderFieldSetKey = @FieldSetKey
	
 Update tPurchaseOrderType
 Set DetailFieldSetKey = NULL
 Where
	DetailFieldSetKey = @FieldSetKey
	
 RETURN 1
GO
