USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ComponentSelected]    Script Date: 12/21/2015 14:06:00 ******/
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
