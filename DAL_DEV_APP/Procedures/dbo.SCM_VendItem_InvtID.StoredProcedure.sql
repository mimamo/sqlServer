USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_VendItem_InvtID]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_VendItem_InvtID]
	@InvtID varchar(30)
	AS

	Select Distinct Inventory.*
	From	Inventory
		INNER JOIN VendItem
		ON Inventory.InvtID = VendItem.InvtID
	Where	VendItem.InvtID LIKE @InvtID
	order by Inventory.InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
