CREATE PROCEDURE [dbo].[spCF_tFieldDefInsert]
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
 @MapTo int,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 07/23/10  GHL 10.532  Added MapTo param...FieldDef for RequestDef can be mapped to a FieldDef for projects 
|| 06/22/11  GHL 10.545  (114355) Changed @ValueList from varchar(4000) to text
|| 11/15/13  RLB 10.574  (190288) increaded Hint to varchar(300)
|| 03/04/14  MFT 10.577  (207360) Set the Return param as expected by code
*/

SELECT @oIdentity = FieldDefKey
FROM tFieldDef (nolock)
WHERE
	FieldName = @FieldName AND
  OwnerEntityKey = @OwnerEntityKey AND
  AssociatedEntity = @AssociatedEntity

IF ISNULL(@oIdentity, 0) > 0
  RETURN -1

INSERT tFieldDef
  (
  OwnerEntityKey,
  AssociatedEntity,
  FieldName,
  Description,
  DisplayType,
  Caption,
  Hint,
  Size,
  MinSize,
  MaxSize,
  TextRows,
  ValueList,
  Required,
  Active,
  OnlyAuthorEdit,
  MapTo
  )
 VALUES
  (
  @OwnerEntityKey,
  @AssociatedEntity,
  @FieldName,
  @Description,
  @DisplayType,
  @Caption,
  @Hint,
  @Size,
  @MinSize,
  @MaxSize,
  @TextRows,
  @ValueList,
  @Required,
  @Active,
  @OnlyAuthorEdit,
  @MapTo
  )
 
SELECT @oIdentity = @@IDENTITY

RETURN @oIdentity