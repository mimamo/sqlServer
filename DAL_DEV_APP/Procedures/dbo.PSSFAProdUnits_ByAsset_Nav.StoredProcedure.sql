USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAProdUnits_ByAsset_Nav]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAProdUnits_ByAsset_Nav] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3min SMALLINT, @parm3max SMALLINT AS
  SELECT * FROM PSSFAProdUnits WHERE AssetId = @parm1 AND AssetSubId = @parm2 AND LineId BETWEEN @parm3min AND @parm3max  ORDER BY PerPost
GO
