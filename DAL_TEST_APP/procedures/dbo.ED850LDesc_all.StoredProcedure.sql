USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_all]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LDesc_all]
 @parm1 varchar( 10 ),
 @parm2 varchar( 10 ),
 @parm3min smallint, @parm3max smallint
AS
 SELECT *
 FROM ED850LDesc
 WHERE Cpnyid LIKE @parm1
    AND EdiPoId LIKE @parm2
    AND LineNbr BETWEEN @parm3min AND @parm3max
 ORDER BY Cpnyid,
    EdiPoId,
    LineNbr
GO
