USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditInfo_SOSetup_Selected]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CreditInfo_SOSetup_Selected]
	@CreditGraceDays	smallint OUTPUT,
	@CreditGracePct		decimal(25,9) OUTPUT
as
	select	@CreditGraceDays = CreditGraceDays,
		@CreditGracePct = CreditGracePct
	from	SOSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @CreditGraceDays = 0
		set @CreditGracePct = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
