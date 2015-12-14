USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tObjectFieldSetDelete]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tObjectFieldSetDelete]
 @ObjectFieldSetKey int
AS --Encrypt

if @ObjectFieldSetKey is null
	return 1
	
 DELETE
 FROM tFieldValue
 WHERE
  ObjectFieldSetKey = @ObjectFieldSetKey 
 
 DELETE
 FROM tObjectFieldSet
 WHERE
  ObjectFieldSetKey = @ObjectFieldSetKey 
  
 RETURN 1
GO
