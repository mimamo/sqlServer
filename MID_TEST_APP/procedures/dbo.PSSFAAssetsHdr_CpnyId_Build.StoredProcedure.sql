USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsHdr_CpnyId_Build]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsHdr_CpnyId_Build] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAAssetsHdr WHERE CpnyId = @parm1 AND assetid in (Select assetid from pssfaassets WHERE status = 'A') AND allsubsinbuild = 'N' AND AssetId LIKE @parm2 ORDER BY AssetId
GO
