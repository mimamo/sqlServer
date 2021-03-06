USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_FetchSchedPlan]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_FetchSchedPlan]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	*
	from	SOPlan

	where	CpnyID = @CpnyID
	and	SOOrdNbr = @OrdNbr
	and	SOLineRef = @LineRef
	and	SOSchedRef = @SchedRef
	and	PlanType in ('50', '52', '54', '60', '62', '64', '70')
GO
