USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_POTran_Receipts_Fetch]    Script Date: 12/21/2015 16:00:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PR_POTran_Receipts_Fetch]
	@CpnyID		varchar(10),
	@PONbr 		varchar(10),
	@POLineRef	varchar(5),
	@RcptNbr	varchar(10)
AS
	select 	POTran.*
	from 	POTran
	join	POReceipt (NOLOCK) on POReceipt.CpnyID = POTran.CpnyID and POReceipt.RcptNbr = POTran.RcptNbr
	where 	POTran.CpnyID = @CpnyID
	and	POTran.PONbr = @PONbr
	and	POTran.POLineRef like @POLineRef
	and	POTran.RcptNbr like @RcptNbr
	and 	POTran.TranType = 'R'
	and	POReceipt.Rlsed = 1
GO
