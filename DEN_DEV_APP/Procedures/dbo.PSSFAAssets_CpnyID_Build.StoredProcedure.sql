USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_CpnyID_Build]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_CpnyID_Build] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10) AS
  SELECT * FROM PSSFAAssets WHERE CpnyId = @parm1 AND AssetId = @parm2 AND AssetSubId LIKE @parm3 AND Status = 'A' AND currbuildnbr = '' ORDER BY AssetId, AssetSubId
GO
