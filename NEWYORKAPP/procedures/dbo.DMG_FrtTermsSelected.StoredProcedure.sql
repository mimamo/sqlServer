USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_FrtTermsSelected]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_FrtTermsSelected]
	@FrtTermsID	varchar(10),
	@Collect	smallint OUTPUT,
	@FOBID		varchar(15) OUTPUT
as
	select	@Collect = Collect,
		@FOBID = ltrim(rtrim(FOBID))
	from	FrtTerms (NOLOCK)
	where	FrtTermsID = @FrtTermsID

	if @@ROWCOUNT = 0 begin
		set @Collect = 0
		set @FOBID = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
