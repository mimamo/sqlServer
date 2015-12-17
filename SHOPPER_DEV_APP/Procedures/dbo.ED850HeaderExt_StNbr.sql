USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_StNbr]    Script Date: 12/16/2015 15:55:19 ******/
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
