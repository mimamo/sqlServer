USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInbound_Trans]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDInbound_Trans]
 @parm1 varchar( 3 )
AS
 SELECT *
 FROM EDInbound
 WHERE Trans LIKE @parm1
 ORDER BY Trans
GO
