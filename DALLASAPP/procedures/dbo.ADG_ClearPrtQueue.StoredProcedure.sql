USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ClearPrtQueue]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ClearPrtQueue]
as
	delete from soprintqueue

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
