USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetLocHist_All]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetLocHist_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSAAssetLocHist WHERE LocId LIKE @parm1 ORDER BY LocId
GO
