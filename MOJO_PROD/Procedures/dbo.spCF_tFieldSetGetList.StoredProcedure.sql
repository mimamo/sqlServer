USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetGetList]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCF_tFieldSetGetList]
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @Active tinyint = null
AS --Encrypt

If @Active is null
  SELECT *
  FROM tFieldSet (NOLOCK)
  WHERE
   OwnerEntityKey = @OwnerEntityKey AND
   AssociatedEntity = @AssociatedEntity
  ORDER BY
   AssociatedEntity, FieldSetName
   
else
  SELECT *
  FROM tFieldSet (NOLOCK)
  WHERE
   OwnerEntityKey = @OwnerEntityKey AND
   AssociatedEntity = @AssociatedEntity AND
   Active = @Active
   
  ORDER BY
   AssociatedEntity, FieldSetName
   
 RETURN 1
GO
