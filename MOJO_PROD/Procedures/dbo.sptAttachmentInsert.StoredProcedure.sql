USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttachmentInsert]
	@CompanyKey int,
	@AssociatedEntity varchar(50),
	@EntityKey int,
	@AddedBy int,
	@FileName varchar(300),
	@Comments varchar(1000),
	@oIdentity INT OUTPUT
AS --Encrypt
 
/*
|| When      Who Rel      What
|| 11/12/12  CRG 10.5.6.2 Added CompanyKey
*/
 
	INSERT tAttachment
		(CompanyKey,
		AssociatedEntity,
		EntityKey,
		AddedBy,
		FileName,
		Comments
		)
	VALUES
		(
		@CompanyKey,
		@AssociatedEntity,
		@EntityKey,
		@AddedBy,
		@FileName,
		@Comments
		)
 
	SELECT @oIdentity = @@IDENTITY
	RETURN 1
GO
