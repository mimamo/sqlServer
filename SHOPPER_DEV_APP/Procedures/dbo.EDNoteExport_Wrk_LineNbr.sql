USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_LineNbr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDNoteExport_Wrk_LineNbr]
 @parm1min int, @parm1max int
AS
 SELECT *
 FROM EDNoteExport_Wrk
 WHERE LineNbr BETWEEN @parm1min AND @parm1max
 ORDER BY LineNbr
GO
