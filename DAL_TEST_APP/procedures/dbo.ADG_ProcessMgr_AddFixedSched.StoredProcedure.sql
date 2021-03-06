USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_AddFixedSched]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_AddFixedSched]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),	-- can be wildcard
	@SchedRef	varchar(5)	-- can be wildcard
as
	declare	@CancelDate	smalldatetime

	select	@CancelDate = getdate()

	select	SOSched.CpnyID,
		SOSched.OrdNbr,
		SOSched.LineRef,
		SOSched.SchedRef

	from	SOSched

	join	SOHeader
	on	SOHeader.CpnyID = SOSched.CpnyID
	and	SOHeader.OrdNbr = SOSched.OrdNbr

	join	SOType
	on	SOType.CpnyID = SOSched.CpnyID
	and	SOType.SOTypeID = SOHeader.SOTypeID

	join	Site
	on	Site.SiteID = SOSched.SiteID

	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	SOSched.LineRef + '' like @LineRef
	and	SOSched.SchedRef + '' like @SchedRef
	and	SOSched.Status = 'O'
	and	SOSched.CancelDate > @CancelDate
	and	SOSched.QtyOrd > 0
	and Site.S4Future09 = 0
	and SOSched.LotSerialEntered = 1
	and SOSched.DropShip = 0
	and	SOType.Behavior in ('SO', 'INVC', 'WC')
GO
