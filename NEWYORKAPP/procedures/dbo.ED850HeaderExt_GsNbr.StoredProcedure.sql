USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_GsNbr]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850HeaderExt_GsNbr]
 @parm1min int, @parm1max int
AS
 SELECT *
 FROM ED850HeaderExt
 WHERE GsNbr BETWEEN @parm1min AND @parm1max
 ORDER BY GsNbr
GO
