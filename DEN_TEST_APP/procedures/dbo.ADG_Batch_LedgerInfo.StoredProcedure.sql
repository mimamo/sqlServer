USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_LedgerInfo]    Script Date: 12/21/2015 15:36:44 ******/
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
