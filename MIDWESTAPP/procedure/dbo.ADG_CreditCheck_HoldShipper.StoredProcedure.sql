USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditCheck_HoldShipper]    Script Date: 12/21/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditCheck_HoldShipper]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@CreditHold	smallint,
	@CreditHoldDate	smalldatetime,
	@ProgID		varchar(8),
	@UserID		varchar(10)
as
	update		SOShipHeader
	set		CreditHold = @CreditHold,
			CreditHoldDate = @CreditHoldDate,
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @ProgID,
			LUpd_User = @UserID,
			ReleaseValue = 0
	where		CpnyID = @CpnyID
	and		ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
