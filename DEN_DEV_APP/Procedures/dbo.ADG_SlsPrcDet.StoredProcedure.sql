USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrcDet]

	@SlsPrcID varchar(15),
	@DetRef varchar(5)
as
	select	*
	from	SlsPrcDet
	where	SlsPrcID = @SlsPrcID
	and	DetRef like @DetRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
