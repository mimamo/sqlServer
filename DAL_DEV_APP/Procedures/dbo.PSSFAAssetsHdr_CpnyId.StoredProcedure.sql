USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsHdr_CpnyId]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsHdr_CpnyId] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAAssetsHdr WHERE CpnyId = @parm1 AND AssetId LIKE @parm2 ORDER BY AssetId
GO
