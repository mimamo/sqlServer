USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFACounty_County]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFACounty_County] @parm1 VARCHAR(3), @parm2 VARCHAR(30) AS
  SELECT * FROM PSSFACounty WHERE StateId = @parm1 AND CountyDescr like @parm2 ORDER BY CountyDescr
GO
