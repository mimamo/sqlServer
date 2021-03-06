USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListUpdate]
	@MarketingListKey int,
	@CompanyKey int,
	@ListName varchar(500),
	@ListID varchar(50),
	@ColumnDef text

AS --Encrypt

if @MarketingListKey <= 0
BEGIN
	INSERT tMarketingList
		(
		CompanyKey,
		ListName,
		ListID,
		ColumnDef
		)

	VALUES
		(
		@CompanyKey,
		@ListName,
		@ListID,
		@ColumnDef
		)
	
	SELECT @MarketingListKey = @@IDENTITY

END
ELSE
BEGIN
	UPDATE
		tMarketingList
	SET
		ListName = @ListName,
		ListID = @ListID,
		ColumnDef = @ColumnDef
	WHERE
		MarketingListKey = @MarketingListKey 

END

	RETURN @MarketingListKey
GO
