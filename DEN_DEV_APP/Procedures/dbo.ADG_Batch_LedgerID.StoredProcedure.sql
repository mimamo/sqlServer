USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_LedgerID]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_LedgerID]
as
	select		LedgerID
	from		GLSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
