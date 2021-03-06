USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_Intransit]    Script Date: 12/21/2015 14:06:23 ******/
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
