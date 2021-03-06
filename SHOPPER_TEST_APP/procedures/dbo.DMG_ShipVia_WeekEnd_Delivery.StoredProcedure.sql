USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ShipVia_WeekEnd_Delivery]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ShipVia_WeekEnd_Delivery]
	@CpnyID		varchar(10),
	@ShipViaID 	varchar(15),
	@SatDelivery	smallint OUTPUT,
	@SatMove	smallint OUTPUT,
	@SatPickup	smallint OUTPUT,
	@SunDelivery	smallint OUTPUT,
	@SunMove	smallint OUTPUT,
	@SunPickup	smallint OUTPUT
as
	select	@SatDelivery = WeekendDelivery,
		@SatMove = MoveOnDeliveryDays,
		@SatPickup = convert(smallint, S4Future11),
		@SunDelivery = convert(smallint,S4Future09),
		@SunMove = convert(smallint, S4Future10),
		@SunPickup = convert(smallint, S4Future12)
	from	ShipVia (NOLOCK)
	where	CpnyID = @CpnyID
	  and	ShipViaID = @ShipViaID

	if @@ROWCOUNT = 0 begin
		set @SatDelivery = 0
		set @SatMove = 0
		set @SatPickup = 0
		set @SunDelivery = 0
		set @SunMove = 0
		set @SunPickup = 0
		return 0
	end
	else
		return 1
GO
