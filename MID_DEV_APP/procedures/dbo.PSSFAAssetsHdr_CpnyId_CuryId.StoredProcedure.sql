USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsHdr_CpnyId_CuryId]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsHdr_CpnyId_CuryId] @parm1 VARCHAR(10), @parm2 VARCHAR(4), @parm3 VARCHAR(10) AS
  SELECT * FROM PSSFAAssetsHdr WHERE CpnyId = @parm1 AND AssetId IN (SELECT AssetId FROM PSSFAAssets WHERE CuryId = @parm2) AND AssetId LIKE @parm3  ORDER BY AssetId
GO
