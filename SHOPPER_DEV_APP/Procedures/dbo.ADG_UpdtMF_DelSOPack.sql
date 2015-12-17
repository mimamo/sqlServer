USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtMF_DelSOPack]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtMF_DelSOPack]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	delete		SOShipPack
	where		CpnyID = @CpnyID
	  and		ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
