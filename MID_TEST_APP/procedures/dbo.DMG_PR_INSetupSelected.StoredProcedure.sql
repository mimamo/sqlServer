USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_INSetupSelected]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_INSetupSelected]
	@CurrPerNbr	varchar(6) OUTPUT,
	@DecPlQty	smallint OUTPUT,
	@DfltSite	varchar(10) OUTPUT,
	@MultWhse	smallint OUTPUT,
	@WhseLocValid	varchar(1) OUTPUT
as
	select	@CurrPerNbr = ltrim(rtrim(CurrPerNbr)),
		@DecPlQty = DecPlQty,
		@DfltSite = ltrim(rtrim(DfltSite)),
		@MultWhse = MultWhse,
		@WhseLocValid = ltrim(rtrim(WhseLocValid))
	from	INSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @CurrPerNbr = ''
		set @DecPlQty = 0
		set @DfltSite = ''
		set @MultWhse = 0
		set @WhseLocValid = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
