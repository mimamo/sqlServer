USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_BOLNbr]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_BOLNbr]
 @parm1 varchar( 20 )
AS
 SELECT *
 FROM EDShipTicket
 WHERE BOLNbr LIKE @parm1
 ORDER BY BOLNbr
GO
