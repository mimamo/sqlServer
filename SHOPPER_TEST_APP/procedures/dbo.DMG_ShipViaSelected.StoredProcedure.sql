USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ShipViaSelected]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ShipViaSelected]
	@CpnyID			varchar(10),
	@ShipViaID		varchar(15),
	@SaturdayDelivery	smallint OUTPUT,
	@SundayDelivery		smallint OUTPUT,
	@TransitTime		smallint OUTPUT
as
	select	@SaturdayDelivery = WeekendDelivery,
		@SundayDelivery = S4Future09,
		@TransitTime = TransitTime
	from	ShipVia (NOLOCK)
	where	CpnyID = @CpnyID
	and	ShipViaID = @ShipViaID

	if @@ROWCOUNT = 0 begin
		set @SaturdayDelivery = 0
		set @SundayDelivery = 0
		set @TransitTime = 0
		return 0	--Failure
	end
	else begin
		--select @SaturdayDelivery, @SundayDelivery, @TransitTime
		return 1	--Success
	end
GO
