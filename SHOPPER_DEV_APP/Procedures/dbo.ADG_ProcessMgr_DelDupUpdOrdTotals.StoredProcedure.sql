USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupUpdOrdTotals]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupUpdOrdTotals]
	@QueueID	int,
	@CpnyID		varchar(10),
	@SOOrdNbr	varchar(15)
as
	delete	ProcessQueue
	where	ProcessQueueID <> @QueueID
	  and	ProcessType = 'UPDOT'
	  and	CpnyID = @CpnyID
	  and	SOOrdNbr = @SOOrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
