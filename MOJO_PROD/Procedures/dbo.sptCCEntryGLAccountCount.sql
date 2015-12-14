USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCCEntryGLAccountCount]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCCEntryGLAccountCount]
	@CompanyKey int,
	@UserKey int

AS

  /*
  || When     Who Rel      What
  || 01/08/15 MAS 10.5.8.8 Create for Platinum (notification panel)
  || 02/02/15 MAS 10.5.8.9 Only bring back tGLAccount.CCDeliveryOption = 0 (exclude manual and v-payment CCs)
  */

	
SELECT AccountName, tCCEntry.GLAccountKey AS GLAccountKey, COUNT(*) AS count 
FROM tCCEntry (nolock)
JOIN tGLAccount (nolock) ON tGLAccount.GLAccountKey = tCCEntry.GLAccountKey
WHERE ISNULL(CCVoucherKey, 0) = 0 
AND tGLAccount.CompanyKey = @CompanyKey
AND ISNULL(tGLAccount.CCDeliveryOption, 0 ) = 0 -- exclude manual and v-payment CCs
GROUP BY AccountName, tCCEntry.GLAccountKey
GO
