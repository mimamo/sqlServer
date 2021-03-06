USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UOMValid]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_UOMValid]
	@ClassID	varchar(6),
	@StkUnit	varchar(6),
	@InvtID		varchar(30),
	@UOM		varchar(6)
as
	if (
	select	count(*)
	from	INUnit (NOLOCK)
	where	FromUnit = @UOM
	and	ToUnit = @StkUnit
	and	(InvtId = '*' or InvtId = @InvtID)
	and	(ClassId = '*' or ClassId = @ClassID)
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
