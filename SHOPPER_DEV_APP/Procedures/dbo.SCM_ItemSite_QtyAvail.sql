USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemSite_QtyAvail]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[SCM_ItemSite_QtyAvail]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10)
AS
	IF PATINDEX('%[%]%', @SiteID) > 0
		SELECT  QtyAvail
		FROM	ItemSite (NoLock)
		WHERE	InvtID = @InvtID
		  AND 	SiteID + '' LIKE @SiteID
	ELSE
		SELECT QtyAvail
		FROM	ItemSite (NoLock)
		WHERE	InvtID = @InvtID
		  AND	SiteID = @SiteID
GO
