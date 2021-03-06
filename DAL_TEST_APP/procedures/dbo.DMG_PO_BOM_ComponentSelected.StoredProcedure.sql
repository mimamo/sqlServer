USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_BOM_ComponentSelected]    Script Date: 12/21/2015 13:56:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_BOM_ComponentSelected]
	@KitID varchar(30),
	@KitSiteID varchar(10),
	@KitStatus varchar(1)
as
	select	CmpnentID,
		CmpnentQty
	from	Component (NOLOCK)
	where	KitID = @KitID
	and	KitSiteID = @KitSiteID
	and	KitStatus = @KitStatus
	order by LineNbr
GO
