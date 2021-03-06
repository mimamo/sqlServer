USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850_HDisc_all]    Script Date: 12/21/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Ed850_HDisc_all]
 @parm1 varchar( 10 ), @parm2 varchar(10),
 @parm2min smallint, @parm2max smallint
AS
 SELECT *
 FROM Ed850HDisc
 WHERE cpnyid = @parm1 and EdiPoId LIKE @parm2
    AND LineNbr BETWEEN @parm2min AND @parm2max
 ORDER BY EdiPoId,
    LineNbr
GO
