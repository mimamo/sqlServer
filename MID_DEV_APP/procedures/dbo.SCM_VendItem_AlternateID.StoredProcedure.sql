USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_VendItem_AlternateID]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_VendItem_AlternateID]
	@InvtID varchar(30),
	@VendID varchar(15),
	@SiteID varchar(10),
	@AlternateID	varchar(30)
AS

	Select DISTINCT	AlternateID
	From	VendItem
	Where	InvtID = @InvtID
	  and	VendID = @VendID
	  and	SiteID = @SiteID
	  and	AlternateID like @AlternateID
	order by AlternateID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
