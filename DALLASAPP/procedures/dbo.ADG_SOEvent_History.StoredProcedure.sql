USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOEvent_History]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOEvent_History]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@ShipperID	varchar(15)
AS
	select	*
	from	SOEvent
	where	CpnyID = @CpnyID
	and	OrdNbr like @OrdNbr
	and	ShipperID like @ShipperID
	order by EventID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
