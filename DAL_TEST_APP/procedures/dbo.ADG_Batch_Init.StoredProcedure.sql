USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_Init]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_Init]
as
	select		*
	from		Batch
	where		Module = 'Z'
	  and		BatNbr = 'Z'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
