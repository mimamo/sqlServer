USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOMisc_Total]    Script Date: 12/21/2015 13:56:51 ******/
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
