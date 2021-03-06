USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_VendItem_SiteID]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_VendItem_SiteID]
	@InvtID varchar(30),
	@VendID varchar(15),
	@SiteID varchar(10)
	AS

	Select 	Distinct Site.*
	From	Site
		INNER JOIN VendItem
		ON Site.SiteID = VendItem.SiteID
	Where	VendItem.InvtID = @InvtID
	  and	VendItem.VendID = @VendID
	  and	VendItem.SiteID LIKE @SiteID
	order by Site.SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
