USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupUpdSh]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupUpdSh]
	@QueueID	int,
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	delete	ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'UPDSH'
	and	CpnyID = @CpnyID
	and	SOShipperID = @ShipperID
GO
