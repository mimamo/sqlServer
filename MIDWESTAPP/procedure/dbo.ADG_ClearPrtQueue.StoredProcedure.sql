USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ClearPrtQueue]    Script Date: 12/21/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ClearPrtQueue]
as
	delete from soprintqueue

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
