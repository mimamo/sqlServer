USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_DropShipPO]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Plan_DropShipPO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5),
	@PONbr		varchar(10) OUTPUT,
	@POLineRef	varchar(5) OUTPUT,
	@AllocRef	varchar(5) OUTPUT
as
	select	@PONbr = ltrim(rtrim(a.PONbr)),
		@POLineRef = ltrim(rtrim(a.POLineRef)),
		@AllocRef = ltrim(rtrim(a.AllocRef))
	from	POAlloc a (NOLOCK)
	where	a.CpnyID = @CpnyID
	  and	a.SOOrdNbr = @OrdNbr
	  and	a.SOLineRef = @LineRef
	  and	a.SOSchedRef = @SchedRef

	if @@ROWCOUNT = 0 begin
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
