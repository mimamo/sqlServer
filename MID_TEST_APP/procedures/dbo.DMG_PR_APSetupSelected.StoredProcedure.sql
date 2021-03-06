USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_APSetupSelected]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_APSetupSelected]
	@CurrPerNbr	varchar(6) OUTPUT
as
	select	@CurrPerNbr = ltrim(rtrim(CurrPerNbr))
	from	APSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @CurrPerNbr = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
