USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_IN10863WRK_UpdateABCCodes]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_IN10863WRK_UpdateABCCodes]
	@ri_id		smallint
as
		Update 	ItemSite
	Set	ABCCode = IsNull((Select ABCCode
				from	IN10863_WRK
				Where	RI_ID = @ri_id
				  and	ItemSite.InvtID = IN10863_WRK.InvtID
				  and	ItemSite.SiteID = IN10863_WRK.SiteID), '')
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
