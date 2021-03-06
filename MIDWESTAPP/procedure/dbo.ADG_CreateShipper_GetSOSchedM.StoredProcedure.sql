USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_GetSOSchedM]    Script Date: 12/21/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_GetSOSchedM]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	AddrID,
		CustID,
		MarkForID,
		MarkForType,
		ShipViaID,
		SiteID,
		VendID

	from	SOSchedMark

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	LineRef = @LineRef
	  and	SchedRef = @SchedRef
GO
