USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_Intransit]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TrnsfrDoc_Intransit]
	@CpnyID varchar(10),
	@TrnsfrDocNbr varchar(10)
AS
	SELECT *
	FROM TrnsfrDoc
	WHERE CpnyID = @CpnyID AND
	      Status = 'I' AND
            TransferType = '2' AND
	      TrnsfrDocNbr LIKE @TrnsfrDocNbr
	ORDER BY TrnsfrDocNbr
GO
