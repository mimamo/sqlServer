USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_LineId]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LDesc_LineId]
 @parm1min int, @parm1max int
AS
 SELECT *
 FROM ED850LDesc
 WHERE LineId BETWEEN @parm1min AND @parm1max
 ORDER BY LineId
GO
