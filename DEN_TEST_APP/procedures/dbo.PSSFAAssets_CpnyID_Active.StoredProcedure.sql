USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_CpnyID_Active]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_CpnyID_Active] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10) AS
  SELECT * FROM PSSFAAssets WHERE CpnyId = @parm1 AND AssetId = @parm2 AND AssetSubId LIKE @parm3 AND Status = 'A' ORDER BY AssetId, AssetSubID
GO
