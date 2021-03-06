USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_ZeroQty]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LocTable_ZeroQty]
	@SiteID VarChar(10)
AS
	UPDATE	LocTable
	SET	LocTable.Selected = 1, LocTable.CountStatus = 'P'
	FROM	LocTable, Location
	WHERE	LocTable.SiteID = @SiteID
	  AND	LocTable.CountStatus = 'A'
	  AND	Location.QtyOnHand = 0
	  AND	LocTable.WhseLoc = Location.WhseLoc
	  AND	LocTable.SiteID = Location.SiteID

-- Copyright 1998,1999 by Solomon Software, Inc. All rights reserved.
GO
