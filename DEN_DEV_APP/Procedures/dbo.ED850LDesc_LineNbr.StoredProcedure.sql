USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_LineNbr]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LDesc_LineNbr]
 @parm1min smallint, @parm1max smallint
AS
 SELECT *
 FROM ED850LDesc
 WHERE LineNbr BETWEEN @parm1min AND @parm1max
 ORDER BY LineNbr
GO
