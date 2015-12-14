USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListUpdateExternalKey]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListUpdateExternalKey]
	@MarketingListKey int,
	@ExternalMarketingKey int
	
AS --Encrypt

  /*
  || When     Who Rel       What
  || 11/30/12 QMD 10.5.6.2  Created to store external mail provider key  
  */
  
	UPDATE tMarketingList SET ExternalMarketingKey = @ExternalMarketingKey WHERE MarketingListKey = @MarketingListKey
GO
