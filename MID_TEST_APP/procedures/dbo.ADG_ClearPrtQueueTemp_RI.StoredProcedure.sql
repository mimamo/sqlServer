USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ClearPrtQueueTemp_RI]    Script Date: 12/21/2015 15:49:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ClearPrtQueueTemp_RI]
	@ri_id		smallint
as
	delete from soprintqueue_temp where ri_id = @ri_id

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
