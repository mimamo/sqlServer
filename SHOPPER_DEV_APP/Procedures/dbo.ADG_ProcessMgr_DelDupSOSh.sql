USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupSOSh]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupSOSh]
	@QueueID	int,
	@CpnyID		varchar(10),
	@SOOrdNbr	varchar(15)
as
	delete	ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'CRTSH'
	and	CpnyID = @CpnyID
	and	SOOrdNbr = @SOOrdNbr
GO
