USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSCatDeprBook_Asset]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSCatDeprBook_Asset] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10) AS
  SELECT * FROM PSSCatDeprBook WHERE ClassID = @parm1 AND CatId = @parm2 AND BookCode LIKE @parm3 ORDER BY BookCode
GO
