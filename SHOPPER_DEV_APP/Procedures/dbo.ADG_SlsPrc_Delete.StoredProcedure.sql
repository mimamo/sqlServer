USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc_Delete]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc_Delete]

	@SlsPrcID varchar(15)
as
	delete
	from	SlsPrc
	where	SlsPrcID = @SlsPrcID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
