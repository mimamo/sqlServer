USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInbound_Trans]    Script Date: 12/16/2015 15:55:20 ******/
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
