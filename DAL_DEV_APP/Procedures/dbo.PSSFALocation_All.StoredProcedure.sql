USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFALocation_All]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFALocation_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFALocation WHERE LocId = @parm1 ORDER BY LocId
GO
