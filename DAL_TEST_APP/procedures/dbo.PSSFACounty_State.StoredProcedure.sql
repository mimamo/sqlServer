USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFACounty_State]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFACounty_State] @parm1 VARCHAR(3) AS
  SELECT DISTINCT StateId From PSSFACounty WHERE StateId like @parm1 ORDER BY StateID
GO
