USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSDeprSect_All]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSDeprSect_All] @parm1 VARCHAR(6) AS
  SELECT * FROM PSSDeprSect WHERE Sect Like @parm1 ORDER BY Sect
GO
