USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_LineItem_all]    Script Date: 12/21/2015 16:07:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Ed850_LineItem_all]
 @parm1 varchar( 10 ),
 @parm2min smallint, @parm2max smallint
AS
 SELECT *
 FROM Ed850LineItem
 WHERE EDIPoId LIKE @parm1
    AND LineNbr BETWEEN @parm2min AND @parm2max
 ORDER BY EDIPoId,
    LineNbr
GO
