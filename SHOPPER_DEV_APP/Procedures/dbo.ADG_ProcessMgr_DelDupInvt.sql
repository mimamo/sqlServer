USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupInvt]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupInvt]
	@QueueID	int,
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	delete	from ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'PLNIN'
	and	InvtID = @InvtID
	and	SiteID = @SiteID
GO
