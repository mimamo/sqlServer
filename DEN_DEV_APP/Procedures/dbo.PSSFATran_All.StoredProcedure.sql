USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFATran_All]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFATran_All] @parm1 VARCHAR(10) AS
  SELECT DISTINCT batnbr, perpost FROM PSSFATran WHERE BatNbr LIKE @parm1 ORDER BY BatNbr, perpost
GO
