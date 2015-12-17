USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ComponentSelected]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ComponentSelected]
	@KitID varchar(30)
as
	select	CmpnentID,
		CmpnentQty,
		Status = ltrim(rtrim(Status))
	from	Component (NOLOCK)
	where	KitId = @KitID
	order by LineNbr
GO
