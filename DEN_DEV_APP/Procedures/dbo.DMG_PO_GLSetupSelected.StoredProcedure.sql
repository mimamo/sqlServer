USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_GLSetupSelected]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_GLSetupSelected]
	@ValidateAcctSub	smallint OUTPUT
as
	select	@ValidateAcctSub = ValidateAcctSub
	from	GLSetup (NOLOCK)

	if @@ROWCOUNT = 0 begin
		set @ValidateAcctSub = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
