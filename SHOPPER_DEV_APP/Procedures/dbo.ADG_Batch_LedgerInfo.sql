USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_LedgerInfo]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_LedgerInfo]
	@LedgerID	varchar(10)
as
	select		BalanceType,
			BaseCuryID
	from		Ledger
	where		LedgerID = @LedgerID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
