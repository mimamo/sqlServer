USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc]

	@SlsPrcID varchar(15)
as
	select	*
	from	SlsPrc
	where	SlsPrcID = @SlsPrcID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
