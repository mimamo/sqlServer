USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldDefInsert]    Script Date: 04/29/2016 15:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'spCF_tFieldDefInsert'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[spCF_tFieldDefInsert]
GO

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
 @DisplayViewMode tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt

/*******************************************************************************************************
*   mojo_dev.dbo.spCF_tFieldDefInsert
*
*   Creator:	WMJ
*   Date:		        
*   
*          
*   Notes: 
*
*   Usage:	set statistics io on

	execute mojo_dev.dbo.spCF_tFieldDefInsert 
	
|| When      Who Rel     What
|| 07/23/10  GHL 10.532  Added MapTo param...FieldDef for RequestDef can be mapped to a FieldDef for projects 
|| 06/22/11  GHL 10.545  (114355) Changed @ValueList from varchar(4000) to text
|| 11/15/13  RLB 10.574  (190288) increaded Hint to varchar(300)
|| 03/04/14  MFT 10.577  (207360) Set the Return param as expected by code
|| 11/19/15  MAS 10.599  (278451) Added DisplayViewMode to support display only CF
********************************************************************************************************/


SELECT @oIdentity = FieldDefKey
FROM mojo_dev.dbo.tFieldDef (nolock)
WHERE FieldName = @FieldName	
	AND OwnerEntityKey = @OwnerEntityKey 
	AND AssociatedEntity = @AssociatedEntity

IF ISNULL(@oIdentity, 0) > 0
  RETURN -1

INSERT mojo_dev.dbo.tFieldDef
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
  MapTo,
  DisplayViewMode
)
select @OwnerEntityKey,
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
  @MapTo,
  @DisplayViewMode

 
SELECT @oIdentity = @@IDENTITY

RETURN @oIdentity
