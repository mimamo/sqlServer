USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_MI]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_MI]
	@MiscChrgID	varchar(10),
	@MiscAcct	varchar(10) OUTPUT,
	@MiscSub	varchar(31) OUTPUT
as
	select	@MiscAcct = MiscAcct,
		@MiscSub = MiscSub
	from	MiscCharge (NOLOCK)
	where	MiscChrgID = @MiscChrgID

	if @@ROWCOUNT = 0 begin
		set @MiscAcct = ''
		set @MiscSub = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
