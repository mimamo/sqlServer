USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_CpnyID_CuryId]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_CpnyID_CuryId] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(4), @parm4 VARCHAR(10)   AS
  SELECT * FROM PSSFAAssets WHERE CpnyId = @parm1 AND AssetId = @parm2 AND CuryId = @parm3 AND AssetSubId LIKE @parm4  ORDER BY AssetId, AssetSubID
GO
