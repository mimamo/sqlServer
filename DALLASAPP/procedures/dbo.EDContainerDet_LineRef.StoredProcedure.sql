USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_LineRef]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_LineRef]
 @parm1 varchar( 5 )
AS
 SELECT *
 FROM EDContainerDet
 WHERE LineRef LIKE @parm1
 ORDER BY LineRef
GO
