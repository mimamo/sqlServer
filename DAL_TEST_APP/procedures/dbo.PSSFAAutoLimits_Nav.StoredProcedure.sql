USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAutoLimits_Nav]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAutoLimits_Nav] @parm1 VARCHAR(15), @parm2min SMALLINT, @parm2max SMALLINT AS
  SELECT * FROM PSSFAautolimits WHERE vehicletype LIKE @parm1 AND linenbr BETWEEN @parm2min AND @parm2max ORDER BY StartDate
GO
