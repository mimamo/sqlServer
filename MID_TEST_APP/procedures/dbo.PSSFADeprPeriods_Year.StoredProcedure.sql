USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFADeprPeriods_Year]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFADeprPeriods_Year] @parm1 VARCHAR(10), @parm2 VARCHAR(4) AS
  SELECT * FROM PSSFADeprPeriods WHERE BookCode = @parm1 AND FiscYr LIKE @parm2 ORDER BY FiscYr
GO
