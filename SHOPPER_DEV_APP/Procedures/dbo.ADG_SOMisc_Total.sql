USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOMisc_Total]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOMisc_Total]
	@cpnyid	varchar(10),
	@ordnbr	varchar(15)
as
	select		'OpenCury' = coalesce(sum(CuryMiscChrg - CuryMiscChrgAppl), 0),
			'OpenReg' = coalesce(sum(MiscChrg - MiscChrgAppl), 0)
	from		SOMisc
	where		CpnyID = @cpnyid
	  and		OrdNbr = @ordnbr
	group by	CpnyID, OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
