USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemInsert]
	@ApprovalKey int,
	@ItemName varchar(200),
	@Description varchar(6000),
	@AttachmentType smallint,
	@FileVersionKey int,
	@AttachmentKey int,
	@URL varchar(1000),
	@URLName varchar(300),
	@FileType smallint,
	@Visible tinyint,
	@FileHeight int,
	@FileWidth int,
	@WindowHeight int,
	@WindowWidth int,
	@WindowBackground varchar(50),
	@Position int,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @Order int

Select @Order = Max(DisplayOrder) from tApprovalItem (nolock) Where ApprovalKey = @ApprovalKey

 INSERT tApprovalItem
  (
	ApprovalKey,
	DisplayOrder,
	ItemName,
	Description,
	AttachmentType,
	FileVersionKey,
	AttachmentKey,
	URL,
	URLName,
	FileType,
	Visible,
	FileHeight,
	FileWidth,
	WindowHeight,
	WindowWidth,
	WindowBackground,
	Position
  )
 VALUES
  (
	@ApprovalKey,
	ISNULL(@Order, 0) + 1,
	@ItemName,
	@Description,
	@AttachmentType,
	@FileVersionKey,
	@AttachmentKey,
	@URL,
	@URLName,
	@FileType,
	@Visible,
	@FileHeight,
	@FileWidth,
	@WindowHeight,
	@WindowWidth,
	@WindowBackground,
	@Position
  )
 
 SELECT @oIdentity = @@IDENTITY
 
 if isnull(@AttachmentKey, 0) > 0
 Update tAttachment
 Set EntityKey = @oIdentity
 Where AttachmentKey = @AttachmentKey
 
 RETURN 1
GO
