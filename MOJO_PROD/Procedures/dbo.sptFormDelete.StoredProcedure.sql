USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDelete]
 @FormKey int
AS --Encrypt
 
Declare @CustomFieldKey int
 SELECT @CustomFieldKey = CustomFieldKey
 FROM 
  tForm (nolock)
 WHERE
  FormKey = @FormKey
 EXEC spCF_tObjectFieldSetDelete @CustomFieldKey
 
 DELETE
 FROM tFormSubscription
 WHERE
  FormKey = @FormKey 
  
 DELETE
 FROM tForm
 WHERE
  FormKey = @FormKey 
 RETURN 1
GO
