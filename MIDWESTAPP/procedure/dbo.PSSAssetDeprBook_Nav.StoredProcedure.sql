USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_Nav]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_Nav] @parm1 VARCHAR(10),@parm2 VARCHAR(10), @parm3min SMALLINT, @parm3max SMALLINT As
  SELECT * FROM PSSAssetDeprBook WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND Linenbr BETWEEN @parm3min AND @parm3max ORDER BY BookCode, BookSeq
GO
