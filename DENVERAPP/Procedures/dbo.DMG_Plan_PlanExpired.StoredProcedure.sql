USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_PlanExpired]    Script Date: 12/21/2015 15:42:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Plan_PlanExpired]
	@InvtID		varchar(30),
	@PlanExpired	smallint OUTPUT
as
	declare	@LotSerIssMthd	varchar(1)
	declare	@LotSerTrack	varchar(2)
	declare	@SerAssign	varchar(1)

	select	@LotSerIssMthd = LotSerIssMthd,
		@LotSerTrack = LotSerTrack,
		@SerAssign = SerAssign
	from	Inventory (NOLOCK)
	where	InvtID = @InvtID

	select	@PlanExpired = 0

	if (@LotSerIssMthd = 'E')
		if (@LotSerTrack in ('LI', 'SI'))
			if (@SerAssign = 'R')
				select @PlanExpired = 1
GO
