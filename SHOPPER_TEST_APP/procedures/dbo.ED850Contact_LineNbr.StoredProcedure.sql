USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Contact_LineNbr]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Contact_LineNbr]
 @parm1min smallint, @parm1max smallint
AS
 SELECT *
 FROM ED850Contact
 WHERE LineNbr BETWEEN @parm1min AND @parm1max
 ORDER BY LineNbr
GO
