USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLocation_InvtID_SiteID_LocTable]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOLocation_InvtID_SiteID_LocTable]
	@InvtID          varchar( 30 ),
	@SiteID          varchar( 10 )

AS
	SELECT           *
	FROM             Location L LEFT OUTER JOIN LocTable T
	ON               L.SiteID = T.SiteID and
	                 L.WhseLoc = T.WhseLoc
	WHERE            L.InvtID = @InvtID and
	                 L.SiteID LIKE @SiteID
	ORDER BY         L.InvtID, L.SiteID, L.WhseLoc
GO
