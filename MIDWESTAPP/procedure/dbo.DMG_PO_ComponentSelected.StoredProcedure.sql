USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_ComponentSelected]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_ComponentSelected]
	@KitID varchar(30),
	@KitStatus varchar(1)
as
	select	CmpnentID,
		CmpnentQty
	from	Component (NOLOCK)
	where	KitID = @KitID
	and	KitStatus = @KitStatus
	order by LineNbr
GO
