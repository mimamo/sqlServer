USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_FrtTerms_Collect]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_FrtTerms_Collect]
	@FrtTermsID	varchar(10),
	@Collect	bit OUTPUT
as
	select	@Collect = Collect
	from	FrtTerms (NOLOCK)
	where	FrtTermsID = @FrtTermsID

	if @@ROWCOUNT = 0 begin
		set @Collect = 0
		return 0	--Failure
	end
	else
		--select @Collect
		return 1	--Success
GO
