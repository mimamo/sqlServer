USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetLocHist_Nav]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetLocHist_Nav] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3min SMALLINT, @parm3max SMALLINT As
  SELECT * FROM PSSFAAssetLocHist WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND LineId BETWEEN @parm3min AND @parm3max
GO
