USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDInbound_Trans]    Script Date: 12/21/2015 13:44:53 ******/
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
