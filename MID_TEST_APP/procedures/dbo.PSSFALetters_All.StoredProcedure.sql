USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFALetters_All]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFALetters_All] @parm1 VARCHAR(6) AS
  SELECT * FROM PSSFALetters WHERE Code LIKE @parm1 ORDER BY Code
GO
