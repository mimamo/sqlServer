USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_VendItem_Availability]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_VendItem_Availability]
 	@InvtID varchar ( 30),
	@SiteID varchar ( 10),
	@FiscYr varchar ( 4),      --No longer used. Always gets the highest year
	@AlternateID varchar (30)
AS
    	Select 	VendItem.*
	from 	VendItem inner join
		(Select InvtID, SiteID, Max(Fiscyr) Fiscyr, AlternateID
		 from 	VendItem
		 group by InvtID, SiteID, AlternateID) VendItem2
		on VendItem.InvtID = VendItem2.InvtID and VendItem.SiteID = VendItem2.SiteID and VendItem.Fiscyr = VendItem2.Fiscyr and VendItem.AlternateID = VendItem2.AlternateID

        where 	VendItem.InvtID = @InvtID
	  and	VendItem.SiteID = @SiteID
	  and	VendItem.AlternateID like @AlternateID

	UNION
		Select	VendItem.*
	from	VendItem  inner join
		(Select InvtID, SiteID, Max(Fiscyr) Fiscyr, AlternateID
		 from 	VendItem
		 group by InvtID, SiteID, AlternateID) VendItem2
		on VendItem.InvtID = VendItem2.InvtID and VendItem.SiteID = VendItem2.SiteID and VendItem.Fiscyr = VendItem2.Fiscyr and VendItem.AlternateID = VendItem2.AlternateID
		INNER JOIN ItemXRef ON VendItem.InvtID = ItemXRef.AlternateID
        where 	ItemXRef.InvtID = @InvtID and AltIDType = 'S'
	  and	VendItem.SiteID = @SiteID
	  and	VendItem.AlternateID like @AlternateID
	Order by VendItem.InvtID, VendItem.SiteID, VendItem.VendID, VendItem.FiscYr, VendItem.AlternateID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
