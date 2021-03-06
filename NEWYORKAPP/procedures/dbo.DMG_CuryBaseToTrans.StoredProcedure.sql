USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CuryBaseToTrans]    Script Date: 12/21/2015 16:00:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CuryBaseToTrans]
	@BaseAmount		decimal(25,9),
	@CuryRate		decimal(25,9),
	@CuryMultDiv		varchar(1),
	@DecimalPlaces		smallint,
	@TransactionAmount	decimal(25,9) OUTPUT
as
	-- Need to invert the meaning of the flag because we are going from base to transaction
	if @CuryMultDiv = 'M' begin
		if @CuryRate = 0
			Set @TransactionAmount = 0
		else
			Set @TransactionAmount = round(@BaseAmount / @CuryRate, @DecimalPlaces)
	end
	else
		Set @TransactionAmount = round(@BaseAmount * @CuryRate, @DecimalPlaces)

	--select @TransactionAmount
GO
