USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsHdr_CpnyId_UOP]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsHdr_CpnyId_UOP] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAAssetsHdr WHERE CpnyId = @parm1 AND AssetId IN (SELECT AssetId FROM PSSFAAssets WHERE ProdUnitsTot <> 0) AND AssetId LIKE @parm2  ORDER BY AssetId
GO
