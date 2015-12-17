USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetTermsIDNbrInstall]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_GetTermsIDNbrInstall]
	@TermsID	varchar(2),
	@NbrInstall	smallint OUTPUT
as
	select	@NbrInstall = NbrInstall
	from	Terms (NOLOCK)
	where	TermsID = @TermsID

	if @@ROWCOUNT = 0 begin
		set @NbrInstall = 0
		return 0	--Failure
	end
	else begin
		--select @NbrInstall
		return 1	--Success
	end
GO
