USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_PlanExpired]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_PlanExpired]
	@InvtID		varchar(30)
as
	declare	@PlanExpired	smallint	-- logical
	declare	@LotSerIssMthd	varchar(1)
	declare	@LotSerTrack	varchar(2)
	declare	@SerAssign	varchar(1)

	select	@LotSerIssMthd = LotSerIssMthd,
		@LotSerTrack = LotSerTrack,
		@SerAssign = SerAssign

	from	Inventory (nolock)
	where	InvtID = @InvtID

	select	@PlanExpired = 0

	if (@LotSerIssMthd = 'E')
		if (@LotSerTrack in ('LI', 'SI'))
			if (@SerAssign = 'R')
				select @PlanExpired = 1

	select @PlanExpired
GO
