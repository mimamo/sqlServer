USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefGetDetails]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormDefGetDetails]
 (
   @FormDefKey int
  ,@UserKey int
 )
AS --Encrypt
 SELECT 
  fd.*, 
  (Select ISNULL(FieldSetKey, 0) From tFieldSet (nolock) Where tFieldSet.OwnerEntityKey = fd.FormDefKey and tFieldSet.AssociatedEntity = 'Forms') as FieldSetKey
 FROM 
   tFormDef fd (nolock) inner join tSecurityAccess sa (nolock) on fd.FormDefKey = sa.EntityKey
   inner join tUser us (nolock) on sa.SecurityGroupKey = us.SecurityGroupKey
 WHERE 
  fd.FormDefKey = @FormDefKey
  and us.UserKey = @UserKey
  and sa.Entity = 'tFormDef'
GO
