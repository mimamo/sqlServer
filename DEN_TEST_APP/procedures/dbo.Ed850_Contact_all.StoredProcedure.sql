USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_Contact_all]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Ed850_Contact_all]
 @parm1 varchar( 10 ),
 @parm2min smallint, @parm2max smallint
AS
 SELECT *
 FROM Ed850Contact
 WHERE EdiPoId LIKE @parm1
    AND LineNbr BETWEEN @parm2min AND @parm2max
 ORDER BY EdiPoId,
    LineNbr
GO
