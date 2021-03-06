USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_DeleteSchedPlan]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_DeleteSchedPlan]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	delete	SOPlan

	where	CpnyID = @CpnyID
	and	SOOrdNbr = @OrdNbr
	and	SOLineRef = @LineRef
	and	SOSchedRef = @SchedRef
	and	PlanType in ('50', '52', '54', '60', '61', '62', '64', '70')	-- Sales Order demand types
GO
