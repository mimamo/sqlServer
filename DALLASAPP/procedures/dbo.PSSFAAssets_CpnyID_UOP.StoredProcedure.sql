USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_CpnyID_UOP]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_CpnyID_UOP] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10)   AS
  SELECT * FROM PSSFAAssets WHERE CpnyId = @parm1 AND AssetId = @parm2 AND AssetSubId IN (SELECT AssetSubId FROM PSSFAAssets WHERE AssetId = @parm2 AND ProdUnitsTot <> 0) AND AssetSubId like @parm3  ORDER BY AssetId, AssetSubID
GO
