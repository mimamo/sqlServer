USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_BookSeq]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_BookSeq] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10), @parm4 VARCHAR(10) AS
  SELECT * FROM PSSAssetDeprBook WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND BookCode = @parm3 AND BookSeq = @parm4 ORDER BY BookSeq
GO
