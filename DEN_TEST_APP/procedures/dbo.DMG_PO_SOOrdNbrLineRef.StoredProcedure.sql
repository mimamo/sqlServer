USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOOrdNbrLineRef]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOOrdNbrLineRef]
	@InvtID		varchar(30),
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5) OUTPUT
as
	select	@LineRef = LineRef
	from	SOLine (NOLOCK)
	where	InvtID = @InvtID
	and	QtyOrd >= 0
	and	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr

	if @@ROWCOUNT <> 1
	begin
		set @LineRef = ''
		--select @LineRef
		return 0	--Failure
	end
	else
		--select @LineRef
		return 1	--Success
GO
