USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_Count_BOL]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_Count_BOL] @BolNbr varchar(20) AS
Select Count(*) from EDShipTicket where bolnbr = @BolNbr
GO
