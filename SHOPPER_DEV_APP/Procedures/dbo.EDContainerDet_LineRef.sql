USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_LineRef]    Script Date: 12/16/2015 15:55:20 ******/
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
