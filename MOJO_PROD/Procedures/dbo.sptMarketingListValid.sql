USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListValid]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListValid]
	 @CompanyKey int
	,@ListName varchar(500)
AS

declare @MarketingListKey int

	
select @MarketingListKey = MarketingListKey
from tMarketingList (nolock)
where upper(ListName) = upper(@ListName)
and CompanyKey = @CompanyKey

return isnull(@MarketingListKey, 0)
GO
