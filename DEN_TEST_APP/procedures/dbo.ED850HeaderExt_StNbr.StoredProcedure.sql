USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_StNbr]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850HeaderExt_StNbr]
 @parm1min int, @parm1max int
AS
 SELECT *
 FROM ED850HeaderExt
 WHERE StNbr BETWEEN @parm1min AND @parm1max
 ORDER BY StNbr
GO
