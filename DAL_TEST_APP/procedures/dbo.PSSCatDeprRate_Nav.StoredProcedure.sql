USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSCatDeprRate_Nav]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSCatDeprRate_Nav] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10), @parm4 VARCHAR(24)AS
  SELECT * FROM PSSCatDeprRate WHERE ClassID = @parm1 AND CatId = @parm2 AND BookCode = @parm3 AND SubAcct LIKE @parm4 ORDER BY SubAcct
GO
