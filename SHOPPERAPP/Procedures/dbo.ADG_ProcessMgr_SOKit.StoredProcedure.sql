USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOKit]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SOKit]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select	BuildInvtID,
		BuildSiteID

	from	SOHeader

	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
GO
