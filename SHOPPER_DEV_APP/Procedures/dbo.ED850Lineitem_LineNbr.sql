USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Lineitem_LineNbr]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Lineitem_LineNbr]
 @parm1min smallint, @parm1max smallint
AS
 SELECT *
 FROM ED850Lineitem
 WHERE LineNbr BETWEEN @parm1min AND @parm1max
 ORDER BY LineNbr
GO
