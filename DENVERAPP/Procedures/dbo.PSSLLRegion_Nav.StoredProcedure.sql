USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLRegion_Nav]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLRegion_Nav] @parm1min SMALLINT, @parm1max SMALLINT AS
  SELECT * FROM PSSLLRegion WHERE linenbr BETWEEN @parm1min AND @parm1max ORDER BY Region, LineNbr
GO
