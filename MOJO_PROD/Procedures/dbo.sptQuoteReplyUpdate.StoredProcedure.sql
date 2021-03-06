USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyUpdate]
	@QuoteReplyKey int,
	@QuoteKey int,
	@VendorKey int,
	@ContactKey int,
	@Status smallint,
	@SpecialComments varchar(4000)

AS --Encrypt

	UPDATE
		tQuoteReply
	SET
		QuoteKey = @QuoteKey,
		VendorKey = @VendorKey,
		ContactKey = @ContactKey,
		Status = @Status,
		SpecialComments = @SpecialComments
	WHERE
		QuoteReplyKey = @QuoteReplyKey

	exec sptQuoteUpdateStatus @QuoteKey, 1

	RETURN 1
GO
