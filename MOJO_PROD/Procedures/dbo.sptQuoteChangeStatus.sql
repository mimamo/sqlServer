USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteChangeStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptQuoteChangeStatus]

	(
		@QuoteKey int,
		@NewStatus smallint
	)

AS --Encrypt

Update tQuote
Set
	Status = @NewStatus
Where
	QuoteKey = @QuoteKey
GO
