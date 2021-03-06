USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_DeleteTrnsfrDoc]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_DeleteTrnsfrDoc]
	@CpnyID		varchar(10),
	@TrnsfrDocNbr	varchar(10),
	@BatNbr		varchar(10),
	@LastDocNbr	varchar(10)
as
	delete	TrnsfrDoc
	where	CpnyID = @CpnyID
	  and	TrnsfrDocNbr = @TrnsfrDocNbr
	  and	BatNbr = @BatNbr

	if @@rowcount = 1
	update	INSetup
	set	LstTrnsfrDocNbr = @LastDocNbr
	where	LstTrnsfrDocNbr = @TrnsfrDocNbr
GO
