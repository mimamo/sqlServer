USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupExSh]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupExSh]
	@QueueID		int,
	@CpnyID			varchar(10),
	@SOShipperID		varchar(15),
	@SOShipperLineRef	varchar(5)
as
	delete	from ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'PLNSH'
	and	CpnyID = @CpnyID
	and	SOShipperID = @SOShipperID
	and	SOShipperLineRef like @SOShipperLineRef
GO
