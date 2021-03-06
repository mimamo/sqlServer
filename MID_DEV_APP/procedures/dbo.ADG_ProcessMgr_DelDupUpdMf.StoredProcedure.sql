USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupUpdMf]    Script Date: 12/21/2015 14:17:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupUpdMf]
	@QueueID	int,
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	delete	ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'UPDMF'
	and	CpnyID = @CpnyID
	and	SOShipperID = @ShipperID
GO
