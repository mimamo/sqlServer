USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSProductCode_All]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSProductCode_All] @parm1 VARCHAR(4) AS
  SELECT * FROM PSSProductCode WHERE ProductCode LIKE @parm1 ORDER BY ProductCode
GO
