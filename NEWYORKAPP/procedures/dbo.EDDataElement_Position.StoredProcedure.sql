USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Position]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_Position]
 @parm1 varchar( 2 )
AS
 SELECT *
 FROM EDDataElement
 WHERE Position LIKE @parm1
 ORDER BY Position
GO
