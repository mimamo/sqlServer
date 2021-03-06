USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WORequest_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WORequest_All]
	@CpnyID		varchar( 10 ),
	@OrdNbr		varchar( 15 ),
	@LineRef	varchar( 5 )

AS
	SELECT		*
	FROM		WORequest
	WHERE		CpnyID = @CpnyID and
			OrdNbr = @OrdNbr and
			LineRef LIKE @LineRef
GO
