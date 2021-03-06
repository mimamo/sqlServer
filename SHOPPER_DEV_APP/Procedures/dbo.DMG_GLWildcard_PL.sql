USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GLWildcard_PL]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_GLWildcard_PL]
	@ProdLineID	varchar(4),
	@COGSAcct	varchar(10) OUTPUT,
	@COGSSub	varchar(31) OUTPUT,
	@DiscAcct	varchar(10) OUTPUT,
	@DiscSub	varchar(31) OUTPUT,
	@SlsAcct	varchar(10) OUTPUT,
	@SlsSub		varchar(31) OUTPUT
as
	select	@COGSAcct = ltrim(rtrim(COGSAcct)),
		@COGSSub = ltrim(rtrim(COGSSub)),
		@DiscAcct = ltrim(rtrim(DiscAcct)),
		@DiscSub = ltrim(rtrim(DiscSub)),
		@SlsAcct = ltrim(rtrim(SlsAcct)),
		@SlsSub = ltrim(rtrim(SlsSub))
	from	ProductLine (NOLOCK)
	where	ProdLineID = @ProdLineID

	if @@ROWCOUNT = 0 begin
		set @COGSAcct = ''
		set @COGSSub = ''
		set @DiscAcct = ''
		set @DiscSub = ''
		set @SlsAcct = ''
		set @SlsSub = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
