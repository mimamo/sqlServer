USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsTran_Nav]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsTran_Nav] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10), @parm4 VARCHAR(10) AS
  SELECT * FROM PSSFATran, PSSFATranHdr WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND (BookCode LIKE @parm3 OR BookCode = '') AND (BookSeq LIKE @parm4 OR BookSeq = 0) AND PSSFATran.BatNbr = PSSFATranHdr.BatNbr AND PSSFATran.BatNbr <> 'FORECAST' ORDER BY PSSFATran.BookCode, PSSFATran.BookSeq, PSSFATran.PerPost, PSSFATran.BatNbr, PSSFATran.LineID
GO
