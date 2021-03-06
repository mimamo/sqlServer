USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_PONbr_Already_Referenced]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_PONbr_Already_Referenced]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@BatNbr		varchar(10) OUTPUT
as
	select	@BatNbr = POReceipt.BatNbr
	from 	POReceipt (NOLOCK)
        inner join potran (NOLOCK) on potran.rcptnbr = poreceipt.rcptnbr
        where 	POReceipt.CpnyID = @CpnyID
	and	POTRan.PONbr = @PONbr
	and	POReceipt.Rlsed = 0

	if @@ROWCOUNT = 0 begin
		set @BatNbr = ''
		return 0	--Failure
	end
	else
		--select 1
		return 1	--Success
GO
