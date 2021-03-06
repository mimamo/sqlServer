USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_LotSerT_POTran]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_LotSerT_POTran]
	@CpnyID		varchar( 10 ),
	@RecordID	int,
	@LotSerNbr	varchar( 25 )
	AS

	SELECT		Distinct POTran.*
	FROM 		POTran
			INNER JOIN LotSerT
			ON POTran.CpnyId = LotSerT.CpnyID
			AND POTran.BatNbr = LotSerT.BatNbr
			AND POTran.RcptNbr = LotSerT.RefNbr
			AND POTran.Lineref = LotSert.InTRANLineRef

	WHERE 		LotSerT.CpnyID = @CpnyID
			AND LotSerT.RecordID = @RecordID
			AND LotSerT.LotSerNbr Like @LotSerNbr
GO
