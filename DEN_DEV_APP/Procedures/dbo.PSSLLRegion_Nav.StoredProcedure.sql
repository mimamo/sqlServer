USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLRegion_Nav]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLRegion_Nav] @parm1min SMALLINT, @parm1max SMALLINT AS
  SELECT * FROM PSSLLRegion WHERE linenbr BETWEEN @parm1min AND @parm1max ORDER BY Region, LineNbr
GO
