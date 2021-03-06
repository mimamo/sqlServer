USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_VendItem_VendID]    Script Date: 12/21/2015 14:06:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_VendItem_VendID]
	@InvtID varchar(30),
	@VendID varchar(15)

AS

	Select 	Distinct Vendor.*
	From	Vendor
		INNER JOIN VendItem
		ON Vendor.VendID = VendItem.VendID
	Where	VendItem.InvtID = @InvtID
	  and	VendItem.VendID LIKE @VendID
	order by Vendor.VendID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
