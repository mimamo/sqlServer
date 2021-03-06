USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyInsert]
	@QuoteKey int,
	@VendorKey int,
	@ContactKey int,
	@Status smallint,
	@SpecialComments varchar(4000),
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @NextNum int

	Select @NextNum = ISNULL(MAX(QuoteReplyNumber) + 1, 1) from tQuoteReply (NOLOCK) Where QuoteKey = @QuoteKey

	INSERT tQuoteReply
		(
		QuoteKey,
		VendorKey,
		ContactKey,
		Status,
		SpecialComments,
		QuoteReplyNumber
		)

	VALUES
		(
		@QuoteKey,
		@VendorKey,
		@ContactKey,
		@Status,
		@SpecialComments,
		@NextNum
		)
	
	SELECT @oIdentity = @@IDENTITY

	exec sptQuoteUpdateStatus @QuoteKey, 1

	RETURN 1
GO
