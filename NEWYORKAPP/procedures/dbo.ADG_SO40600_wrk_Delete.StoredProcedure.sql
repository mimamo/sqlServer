USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SO40600_wrk_Delete]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SO40600_wrk_Delete]
	@ri_id		smallint

as

	-- Delete all records with the current ri_id out of SOPrintQueue.
	delete from SO40600_Wrk where ri_id = @ri_id

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
