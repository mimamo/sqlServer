USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupExSh]    Script Date: 12/21/2015 15:36:46 ******/
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
