USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Lineitem_Qty]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Lineitem_Qty]
 @parm1min float, @parm1max float
AS
 SELECT *
 FROM ED850Lineitem
 WHERE Qty BETWEEN @parm1min AND @parm1max
 ORDER BY Qty
GO
