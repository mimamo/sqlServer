USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_GetAEFieldSet]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCF_GetAEFieldSet]
 (
  @AssociatedEntity varchar(50),
  @OwnerEntityKey int
 )
AS --Encrypt
Declare @FieldSetKey as integer
 SELECT 
  @FieldSetKey = MIN(FieldSetKey)
 FROM 
  tFieldSet (NOLOCK)
 WHERE 
  AssociatedEntity = @AssociatedEntity AND
  OwnerEntityKey = @OwnerEntityKey
  
 IF @FieldSetKey IS NULL
  RETURN 0
 ELSE
  RETURN @FieldSetKey
GO
