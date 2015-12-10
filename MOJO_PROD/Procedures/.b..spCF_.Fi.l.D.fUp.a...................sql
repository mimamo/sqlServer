USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldDefUpdate]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldDefUpdate]
 @FieldDefKey int,
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @FieldName varchar(75),
 @Description varchar(300),
 @DisplayType smallint,
 @Caption varchar(75),
 @Hint varchar(300),
 @Size int,
 @MinSize int,
 @MaxSize int,
 @TextRows int,
 @ValueList text,
 @Required tinyint,
 @Active tinyint,
 @OnlyAuthorEdit tinyint,
 @MapTo int
AS --Encrypt

/*
|| When      Who Rel     What
|| 06/22/11  GHL 10.545  (114355) Changed @ValueList from varchar(4000) to text
|| 11/15/13  RLB 10.574  (190288) increaded Hint to varchar(300)
*/

 IF EXISTS(SELECT 1 FROM tFieldDef (NOLOCK)
  WHERE FieldName = @FieldName AND
  OwnerEntityKey = @OwnerEntityKey AND
  FieldDefKey <> @FieldDefKey AND
  AssociatedEntity = @AssociatedEntity)
  BEGIN
  Return -1
  END
 ELSE
  BEGIN
  UPDATE
   tFieldDef
  SET
   OwnerEntityKey = @OwnerEntityKey,
   FieldName = @FieldName,
   Description = @Description,
   DisplayType = @DisplayType,
   Caption = @Caption,
   Hint = @Hint,
   Size = @Size,
   MinSize = @MinSize,
   MaxSize = @MaxSize,
   TextRows = @TextRows,
   ValueList = @ValueList,
   Required = @Required,
   Active = @Active,
   OnlyAuthorEdit = @OnlyAuthorEdit,
   MapTo = @MapTo
  WHERE
   FieldDefKey = @FieldDefKey 
  return 1
  END
GO
