USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditCheck_GetCreditCheck]    Script Date: 12/21/2015 16:07:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CreditCheck_GetCreditCheck]
	@CreditCheck smallint OUTPUT
as
	-- Set to 1 so credit checking defaults to true if the select below fails
	set @CreditCheck = 1

	select	@CreditCheck = CreditCheck
	from	SOSetup (NOLOCK)

	--select @CreditCheck
GO
