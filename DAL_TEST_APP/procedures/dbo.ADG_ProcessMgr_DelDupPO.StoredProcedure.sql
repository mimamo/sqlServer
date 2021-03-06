USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupPO]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupPO]
	@QueueID	int,
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@POLineRef	varchar(5)
as
	delete	from ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'PLNPO'
	and	CpnyID = @CpnyID
	and	PONbr = @PONbr
	and	POLineRef like @POLineRef
GO
