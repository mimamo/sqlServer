USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLRegion_All]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLRegion_All] @parm1 VARCHAR(10) AS 
  SELECT * FROM PSSLLRegion WHERE Region LIKE @parm1 ORDER BY Region
GO
