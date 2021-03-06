USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditInfo_TermsCOD]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CreditInfo_TermsCOD]
	@TermsID	varchar(15),
	@COD		smallint OUTPUT
as
	select	@COD = COD
	from	Terms (NOLOCK)
	where	TermsID = @TermsID

	if @@ROWCOUNT = 0 begin
		set @COD = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
