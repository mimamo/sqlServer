USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFACounty_Nav]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFACounty_Nav] @parm1 VARCHAR(3), @parm2min SMALLINT, @parm2max SMALLINT AS
  SELECT * FROM PSSFACounty WHERE stateid = @parm1 AND lineid between @parm2min AND @parm2max order by lineid
GO
