USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Position]    Script Date: 12/16/2015 15:55:20 ******/
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
