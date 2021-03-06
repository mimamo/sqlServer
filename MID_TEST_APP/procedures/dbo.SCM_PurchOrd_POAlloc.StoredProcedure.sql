USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_PurchOrd_POAlloc]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[SCM_PurchOrd_POAlloc]
	@CpnyID		varchar( 10 ),
	@OrdNbr		varchar( 15 )
	AS

	SELECT		DISTINCT PurchOrd.*
	FROM		PurchOrd
			Join POAlloc
			On POAlloc.PONbr = PurchOrd.PONbr
			and POAlloc.CpnyID = @CpnyID
			and POAlloc.SOOrdNbr = @OrdNbr
GO
