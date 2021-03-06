USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_10400_QueueShippers]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[pp_10400_QueueShippers]

	@BatNbr			varchar(10)
as
	declare @InvtID		varchar(30)
	declare @SiteID		varchar(10)

	declare		InTranCursor	cursor
	for
	select		InvtID,
			SiteID
	from		InTran
	where		BatNbr = @BatNbr
	  and		TranType not in ('CG', 'CT')
	group by	InvtID,
			SiteID

	open InTranCursor

	fetch next from InTranCursor into @InvtID, @SiteID

	while (@@fetch_status = 0)
	begin
		exec ADG_ProcessMgr_QueueShInvt @InvtID, @SiteID

		fetch next from InTranCursor into @InvtID, @SiteID
	end

	close InTranCursor
	deallocate InTranCursor

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
