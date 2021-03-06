USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_PurchOrd_POAlloc_LineRef]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_PurchOrd_POAlloc_LineRef]
	@CpnyID		VARCHAR( 10 ),
	@OrdNbr		VARCHAR( 15 ),
	@LineRef	VARCHAR( 5 )
AS
	SELECT DISTINCT PurchOrd.*
	FROM PurchOrd 
		JOIN POAlloc
		ON POAlloc.PONbr = PurchOrd.PONbr
		AND POAlloc.CpnyID = @CpnyID
		AND POAlloc.SOOrdNbr = @OrdNbr
		AND POAlloc.SOLineRef = @LineRef
GO
