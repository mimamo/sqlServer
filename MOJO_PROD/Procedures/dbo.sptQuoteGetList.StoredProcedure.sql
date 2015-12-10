USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteGetList]

	@ProjectKey int


AS --Encrypt

		SELECT *
		FROM tQuote (NOLOCK) 
		WHERE
			ProjectKey = @ProjectKey
		Order By
			QuoteNumber

	RETURN 1
GO
