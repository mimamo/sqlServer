USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_LotSerT_Fetch_Test]    Script Date: 12/21/2015 14:34:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_LotSerT_Fetch_Test]
	@CpnyID		varchar(10),
	@BatNbr		varchar(10)
as
	select	*
	from	LotSerT
	where	CpnyID = @CpnyID
	and	RefNbr in	(	select	RcptNbr from POReceipt (NOLOCK)
					where	CpnyID = @CpnyID
					and 	BatNbr = @BatNbr
				)
	order by INTranLineRef
GO
