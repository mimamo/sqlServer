USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_Delete]    Script Date: 12/21/2015 15:49:08 ******/
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
