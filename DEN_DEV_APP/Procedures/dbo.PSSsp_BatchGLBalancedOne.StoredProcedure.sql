USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_BatchGLBalancedOne]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_BatchGLBalancedOne] @JrnlType VARCHAR(2), @PerPost VARCHAR(6), @CpnyId VARCHAR(10), @CuryId VARCHAR(4), @CuryRateType VARCHAR(6), @CuryEffDate SmallDateTime, @LedgerID VARCHAR(10) AS
  SELECT * FROM Batch WHERE Module = 'GL' AND Status = 'B' AND editscrnnbr = '01010' AND JrnlType = @JrnlType AND PerPost = @PerPost AND CpnyId = @CpnyId AND CuryId = @CuryId AND CuryRateType = @CuryRateType AND CuryEffDate <= @CuryEffDate AND LedgerID = @LedgerID
GO
