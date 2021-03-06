USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SO_CustID]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SO_CustID]

	@CpnyID		varchar(10),
	@OrdNbr 	varchar(15),
	@ShipperID 	varchar(15)
as

	declare @CustID varchar(15)

	if rtrim(@ShipperID) <> ''
	begin
		select	@CustID = CustID
		from	SOShipHeader
		where	CpnyID = @CpnyID
		  and	ShipperID = @ShipperID
	end
	else
	begin
		select	@CustID = CustID
		from	SOHeader
		where	CpnyID = @CpnyID
		  and	OrdNbr = @OrdNbr
	end

	select @CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
