USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Lsss_LineId]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Lsss_LineId]
 @parm1min int, @parm1max int
AS
 SELECT *
 FROM ED850Lsss
 WHERE LineId BETWEEN @parm1min AND @parm1max
 ORDER BY LineId
GO
