USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_LotSerMst_Fetch_Test]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_LotSerMst_Fetch_Test]
	@CpnyID		varchar(10),
	@BatNbr		varchar(10)
as
	select	*
	from	LotSerMst
	where	SrcOrdNbr in	(	select	RcptNbr from POReceipt (NOLOCK)
					where	CpnyID = @CpnyID
					and 	BatNbr = @BatNbr
				)
	order by InvtID,LotSerNbr,SiteID,WhseLoc
GO
