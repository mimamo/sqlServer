USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ARSetupSelected]    Script Date: 12/16/2015 15:55:16 ******/
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
