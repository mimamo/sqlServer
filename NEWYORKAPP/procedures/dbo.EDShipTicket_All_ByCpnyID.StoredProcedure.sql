USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_All_ByCpnyID]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_All_ByCpnyID] AS
Select * from EDShipTicket order by CpnyID
GO
