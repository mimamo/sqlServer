USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_Neg]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LocTable_Neg]
	@SiteID VarChar(10)
AS
	UPDATE	LocTable
	SET	LocTable.Selected = 1, LocTable.CountStatus = 'P'
	FROM	LocTable, Location
	WHERE	LocTable.SiteID = @SiteID
	  AND	LocTable.CountStatus = 'A'
	  AND	Location.QtyOnHand < 0
	  AND	LocTable.WhseLoc = Location.WhseLoc
	  AND	LocTable.SiteID = Location.SiteID

-- Copyright 1998,1999 by Solomon Software, Inc. All rights reserved.
GO
