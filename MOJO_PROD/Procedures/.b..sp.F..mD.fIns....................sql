USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefInsert]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDefInsert]
 @CompanyKey int,
 @FormName varchar(100),
 @FormPrefix varchar(10),
 @Description varchar(500),
 @WorkingLevel smallint,
 @Active tinyint,
 @FormType tinyint,
 @OnlyAuthorCanClose tinyint,
 @OnlyAuthorEditDate tinyint,
 @OnlyAuthOrAssignCanEdit tinyint,
 @NotifyAssignee tinyint,
 @NotifyAuthorOnClose tinyint,
 @NotifyAuthorOnUpdate tinyint,
 @OnlyAuthorEdit tinyint,
 @DisplayColor varchar(20),
 @UniqueNumbers tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tFormDef
  (
  CompanyKey,
  FormName,
  FormPrefix,
  Description,
  WorkingLevel,
  Active,
  FormType,
  OnlyAuthorCanClose,
  OnlyAuthorEditDate,
  OnlyAuthOrAssignCanEdit,
  NotifyAssignee,
  NotifyAuthorOnClose,
  NotifyAuthorOnUpdate,
  OnlyAuthorEdit,
  DisplayColor,
  UniqueNumbers
  )
 VALUES
  (
  @CompanyKey,
  @FormName,
  @FormPrefix,
  @Description,
  @WorkingLevel,
  @Active,
  @FormType,
  @OnlyAuthorCanClose,
  @OnlyAuthorEditDate,
  @OnlyAuthOrAssignCanEdit,
  @NotifyAssignee,
  @NotifyAuthorOnClose,
  @NotifyAuthorOnUpdate,
  @OnlyAuthorEdit,
  @DisplayColor,
  @UniqueNumbers
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
