USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ClearPrtQueue_RI]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ClearPrtQueue_RI]
	@ri_id		smallint
as
	delete from soprintqueue where ri_id = @ri_id

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
