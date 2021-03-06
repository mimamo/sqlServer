USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CuryTransToBase]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CuryTransToBase]
	@TransactionAmount	decimal(25,9),
	@CuryRate		decimal(25,9),
	@CuryMultDiv		varchar(1),
	@DecimalPlaces		smallint,
	@BaseAmount		decimal(25,9) OUTPUT
as
	if @CuryMultDiv = 'M'
		Set @BaseAmount = round(@TransactionAmount * @CuryRate, @DecimalPlaces)
	else begin
		if @CuryRate = 0
			Set @BaseAmount = 0
		else
			Set @BaseAmount = round(@TransactionAmount / @CuryRate, @DecimalPlaces)
	end
	--select @BaseAmount
GO
