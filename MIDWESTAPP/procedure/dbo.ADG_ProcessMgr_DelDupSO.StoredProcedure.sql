USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupSO]    Script Date: 12/21/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupSO]
	@QueueID	int,
	@CpnyID		varchar(10),
	@SOOrdNbr	varchar(15),
	@SOLineRef	varchar(5),
	@SOSchedRef	varchar(5)
as
	delete	from ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'PLNSO'
	and	CpnyID = @CpnyID
	and	SOOrdNbr = @SOOrdNbr
	and	SOLineRef like @SOLineRef
	and	SOSchedRef like @SOSchedRef
GO
