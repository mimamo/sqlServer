USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_VendItem_FiscYr]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SCM_VendItem_FiscYr]
	@InvtID varchar(30),
	@VendID varchar(15),
	@SiteID varchar(10),
	@AlternateID	varchar(30),
	@FiscYr varchar( 4)
AS

	Select 	Distinct FiscYr
	From	VendItem
	Where	InvtID = @InvtID
	  and	VendID = @VendID
	  and	SiteID = @SiteID
	  and	AlternateID = @AlternateID
	  and	FiscYr LIKE @FiscYr
	order by FiscYr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
