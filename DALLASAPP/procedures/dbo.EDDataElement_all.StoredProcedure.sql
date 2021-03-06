USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_all]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_all]
 @parm1 varchar( 5 ),
 @parm2 varchar( 2 ),
 @parm3 varchar( 15 )
AS
 SELECT *
 FROM EDDataElement
 WHERE Segment LIKE @parm1
    AND Position LIKE @parm2
    AND Code LIKE @parm3
 ORDER BY Segment,
    Position,
    Code
GO
