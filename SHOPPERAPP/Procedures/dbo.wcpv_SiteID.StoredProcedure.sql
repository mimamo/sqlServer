USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_SiteID]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--This proc provides the possible-value list of inventory sites for a particular
--shopper.
CREATE Procedure [dbo].[wcpv_SiteID]
	@ShopperID 	VARCHAR(32) = '%',
	@SiteID 	VARCHAR(10) = '%'
As
	SET NOCOUNT ON
	-- Create a temp table to hold the results
	CREATE TABLE #ShopperSites
	(
	    SiteID VARCHAR(15),
	    Name   VARCHAR(30)
	)

	INSERT #ShopperSites
		EXEC wc_GetSites @ShopperID

	SELECT
		ShopperID = @ShopperID,
		SiteID,
		Name
	FROM
		#ShopperSites (NOLOCK)
	WHERE
		SiteID LIKE @SiteID
GO
