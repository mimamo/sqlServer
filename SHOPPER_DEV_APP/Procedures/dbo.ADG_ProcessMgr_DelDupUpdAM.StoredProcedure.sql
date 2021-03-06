USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupUpdAM]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupUpdAM]
	@QueueID	int,
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	delete	ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'UPDAM'
	and	CpnyID = @CpnyID
	and	SOShipperID = @ShipperID
GO
