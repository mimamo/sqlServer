USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_LCReceipt_Fetch]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_LCReceipt_Fetch]
	@CpnyID		varchar(10),
	@BatNbr		varchar(10)
as
	select	*
	from	LCReceipt
	where	CpnyID = @CpnyID
	and	RcptNbr in	(	select	RcptNbr from POReceipt (NOLOCK)
					where	CpnyID = @CpnyID
					and 	BatNbr = @BatNbr
				)
GO
