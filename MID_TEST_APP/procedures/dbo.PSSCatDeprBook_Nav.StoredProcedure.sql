USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSCatDeprBook_Nav]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSCatDeprBook_Nav] @parm1 VARCHAR(10),@parm2 VARCHAR(10), @parm3min SMALLINT, @parm3max SMALLINT AS
  SELECT * FROM PSSCatDeprBook WHERE ClassId = @parm1 AND CatId = @parm2 AND LineNbr BETWEEN @parm3min AND @parm3max ORDER BY BookCode
GO
