USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_SlsPrcID_UnitDesc]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrcDet_SlsPrcID_UnitDesc]

	@SlsPrcID	varchar(15),
	@SlsUnit	varchar(6)
as
	select	SlsPrcDet.*
	from	SlsPrcDet
	join	SlsPrc on SlsPrc.SlsPrcID = SlsPrcDet.SlsPrcID
	where	SlsPrc.SlsPrcID = @SlsPrcID
	and	SlsPrcDet.SlsUnit like @SlsUnit
	order by SlsPrcDet.QtyBreak

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
