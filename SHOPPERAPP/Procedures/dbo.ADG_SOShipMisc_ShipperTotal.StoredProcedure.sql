USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipMisc_ShipperTotal]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOShipMisc_ShipperTotal]
	@cpnyid		varchar(10),
	@shipperid	varchar(15)
as
	select		coalesce(sum(CuryMiscChrg), 0),
			coalesce(sum(MiscChrg), 0)
	from		SOShipMisc
	where		CpnyID = @cpnyid
	  and		ShipperID = @shipperid
	group by	CpnyID, ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
