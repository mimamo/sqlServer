USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_CpnyID_Hdr]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_CpnyID_Hdr] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAAssets WHERE CpnyId = @parm1 AND AssetId LIKE @parm2 ORDER BY AssetId
GO
