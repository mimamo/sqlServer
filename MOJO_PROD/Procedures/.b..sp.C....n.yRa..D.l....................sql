USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyRateDelete]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyRateDelete]
	(
	@CurrencyRateKey int
	)
As --Encrypt

  /*
  || When     Who Rel      What
  || 09/05/13 GHL 10.572  Creation for new multi currency functionality
  || 09/10/13 GHL 10.572  Deleting using the PK 
  */

	SET NOCOUNT ON

	delete tCurrencyRate
	where  CurrencyRateKey = @CurrencyRateKey

	RETURN 1
GO
