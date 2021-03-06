USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDefGet]
 @FormDefKey int
AS --Encrypt
 SELECT 
  tFormDef.*, 
  (Select FieldSetKey from tFieldSet Where tFormDef.FormDefKey = tFieldSet.OwnerEntityKey and AssociatedEntity = 'Forms') as FieldSetKey
 FROM tFormDef  (nolock) 
 WHERE 
  FormDefKey = @FormDefKey
 RETURN 1
GO
