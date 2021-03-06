USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDefUpdate]
 @FormDefKey int,
 @CompanyKey int,
 @FormName varchar(100),
 @FormPrefix varchar(10),
 @Description varchar(500),
 @Active tinyint,
 @OnlyAuthorCanClose tinyint,
 @OnlyAuthorEditDate tinyint,
 @OnlyAuthOrAssignCanEdit tinyint,
 @NotifyAssignee tinyint,
 @NotifyAuthorOnClose tinyint,
 @NotifyAuthorOnUpdate tinyint,
 @OnlyAuthorEdit tinyint,
 @DisplayColor varchar(20),
 @UniqueNumbers tinyint
AS --Encrypt
 UPDATE
  tFormDef
 SET
  CompanyKey = @CompanyKey,
  FormName = @FormName,
  FormPrefix = @FormPrefix,
  Description = @Description,
  Active = @Active,
  OnlyAuthorCanClose = @OnlyAuthorCanClose,
  OnlyAuthorEditDate = @OnlyAuthorEditDate,
  OnlyAuthOrAssignCanEdit = @OnlyAuthOrAssignCanEdit,
  NotifyAssignee = @NotifyAssignee,
  NotifyAuthorOnClose = @NotifyAuthorOnClose,
  NotifyAuthorOnUpdate = @NotifyAuthorOnUpdate,
  OnlyAuthorEdit = @OnlyAuthorEdit,
  DisplayColor = @DisplayColor,
  UniqueNumbers = @UniqueNumbers
 WHERE
  FormDefKey = @FormDefKey 
 RETURN 1
GO
