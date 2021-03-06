USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_all]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDNoteExport_Wrk_all]
 @parm1 varchar( 21 ),
 @parm2min int, @parm2max int,
 @parm3min int, @parm3max int
AS
 SELECT *
 FROM EDNoteExport_Wrk
 WHERE ComputerName LIKE @parm1
    AND nId BETWEEN @parm2min AND @parm2max
    AND LineNbr BETWEEN @parm3min AND @parm3max
 ORDER BY ComputerName,
    nId,
    LineNbr
GO
