USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_SlsPrc_SlsPrcID]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrcDet_SlsPrc_SlsPrcID]

	@SlsPrcID	varchar(15)
as
	select	SlsPrcDet.*,
		SlsPrc.*
	from	SlsPrcDet
	join	SlsPrc on SlsPrc.SlsPrcID = SlsPrcDet.SlsPrcID
	where	SlsPrc.SlsPrcID = @SlsPrcID
	order by SlsPrc.DiscPrcTyp, SlsPrcDet.QtyBreak

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
