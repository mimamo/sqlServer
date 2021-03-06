USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipts_Release]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[LCReceipts_Release]
	@CpnyID varchar(10)
as
select distinct
	POReceipt.CpnyID,
	POReceipt.BatNbr,
	POReceipt.RcptNbr,
	POReceipt.CuryRcptAmtTot,
	POReceipt.RcptQtyTot
from
	POReceipt,
	LCReceipt
where
	POReceipt.cpnyid like @CpnyID
	and POReceipt.Rlsed =1
	and POReceipt.RcptNbr = LCReceipt.RcptNbr
	and LCReceipt.TranStatus = 'U'
order by POReceipt.RcptNbr
GO
