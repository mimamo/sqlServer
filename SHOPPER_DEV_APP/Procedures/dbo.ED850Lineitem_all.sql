USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Lineitem_all]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Lineitem_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 10 ),
 @parm3min smallint, @parm3max smallint
AS
 SELECT *
 FROM ED850Lineitem
 WHERE Cpnyid LIKE @parm1
    AND EDIPoId LIKE @parm2
    AND LineNbr BETWEEN @parm3min AND @parm3max
 ORDER BY Cpnyid,
    EDIPoId,
    LineNbr
GO
