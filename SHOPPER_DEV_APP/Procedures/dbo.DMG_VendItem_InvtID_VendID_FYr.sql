USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_VendItem_InvtID_VendID_FYr]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_VendItem_InvtID_VendID_FYr]
 	@InvtID varchar ( 30),
	@SiteID varchar ( 10),
	@VendID varchar ( 15),
	@AlternateID varchar (30),
	@FiscYr varchar ( 4)

AS
    	Select 	*
	from 	VendItem
        where 	InvtID LIKE @InvtID
	  and	SiteID LIKE @SiteID
	  and 	VendID LIKE @VendID
	  and	AlternateID LIKE @AlternateID
	  and	FiscYr LIKE @FiscYr
	Order by InvtID, SiteID, VendID,AlternateID, FiscYr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
