USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupSOSh]    Script Date: 12/21/2015 13:44:42 ******/
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
