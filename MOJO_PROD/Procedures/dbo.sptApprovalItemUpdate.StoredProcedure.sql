USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemUpdate]
 @ApprovalItemKey int,
 @ItemName varchar(200),
 @Description varchar(1000),
 @Visible tinyint,
 @FileHeight int,
 @FileWidth int,
 @WindowHeight int,
 @WindowWidth int,
 @WindowBackground varchar(50),
 @Position int
 
AS --Encrypt
 UPDATE
  tApprovalItem
 SET
  ItemName = @ItemName,
  Description = @Description,
  Visible = @Visible,
  FileHeight = @FileHeight,
  FileWidth = @FileWidth,
  WindowHeight = @WindowHeight,
  WindowWidth = @WindowWidth,
  WindowBackground = @WindowBackground,
  Position = @Position
 WHERE
  ApprovalItemKey = @ApprovalItemKey 

 RETURN 1
GO
