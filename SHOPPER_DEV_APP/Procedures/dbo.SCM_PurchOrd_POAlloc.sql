USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_PurchOrd_POAlloc]    Script Date: 12/16/2015 15:55:33 ******/
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
