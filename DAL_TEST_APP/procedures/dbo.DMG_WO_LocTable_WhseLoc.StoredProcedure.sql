USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WO_LocTable_WhseLoc]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_WO_LocTable_WhseLoc]
	@InvtID		varchar(30),
	@SiteID 	varchar(10),
	@WhseLoc	varchar(10)

AS
	select	*
	from	LocTable
	Where	((InvtID = @InvtID and InvtIDValid = 'Y') or (InvtID = '' and InvtIDValid = 'N'))
	and	SiteID like @SiteID
	and	WhseLoc like @WhseLoc
	and	ReceiptsValid = 'Y'
	order by WhseLoc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
