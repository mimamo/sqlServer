USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_ShipperId]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_ShipperId]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDShipTicket
 WHERE ShipperId LIKE @parm1
 ORDER BY ShipperId
GO
