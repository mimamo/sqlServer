USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SetPOPrtQueueToOpenOrder]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SetPOPrtQueueToOpenOrder]
	@ri_id		smallint
as
	update	PurchOrd
	Set	Status = 'O'
	Where	Status = 'P'
	and	PONbr In (select PONbr from poprintqueue where RI_ID = @ri_id)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
