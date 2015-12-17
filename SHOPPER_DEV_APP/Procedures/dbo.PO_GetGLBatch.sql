USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PO_GetGLBatch]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PO_GetGLBatch]
	@Cpny_ID varchar( 10 ),
	@Module varchar( 2 ),
	@OrigBatNbr varchar( 10 )

AS
	SELECT *
	FROM Batch
	WHERE CpnyID = @Cpny_ID
	   AND Module = @Module
	   AND OrigBatNbr = @OrigBatNbr
GO
