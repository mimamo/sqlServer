USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_Delete]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrcDet_Delete]

	@SlsPrcID varchar(15),
	@DetRef varchar(5)
as
	delete
	from	SlsPrcDet
	where	SlsPrcID = @SlsPrcID
	and	DetRef like @DetRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
