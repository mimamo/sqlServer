USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_AllForASN]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_AllForASN] AS
select * from EDShipment where bolnbr in (Select distinct(edshipticket.bolnbr) from EDShipTicket,SOShipHeader where edshipticket.Shipperid = soshipheader.shipperid and edshipticket.cpnyid = soshipheader.cpnyid and soshipheader.nextfunctionid = '5040200')
GO
