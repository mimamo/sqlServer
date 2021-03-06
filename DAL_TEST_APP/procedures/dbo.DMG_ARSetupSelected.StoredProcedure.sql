USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ARSetupSelected]    Script Date: 12/21/2015 13:56:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ARSetupSelected]
	@CurrPerNbr	varchar(6) OUTPUT
as
	select	@CurrPernbr = ltrim(rtrim(CurrPerNbr))
	from 	ARSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @CurrPerNbr = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
