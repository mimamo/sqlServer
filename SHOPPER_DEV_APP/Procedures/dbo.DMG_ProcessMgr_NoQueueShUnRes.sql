USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProcessMgr_NoQueueShUnRes]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ProcessMgr_NoQueueShUnRes]
	@QueueShippersOnUnreserve smallint OUTPUT
as
	--Make the default 1 if the select below fails
	set @QueueShippersOnUnreserve = 1

	select	@QueueShippersOnUnreserve = convert(smallint, S4Future12)
	from	SOSetup (NOLOCK)

	--select @QueueShippersOnUnreserve
GO
