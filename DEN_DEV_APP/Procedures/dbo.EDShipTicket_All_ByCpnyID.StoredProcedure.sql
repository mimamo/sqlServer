USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_All_ByCpnyID]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_All_ByCpnyID] AS
Select * from EDShipTicket order by CpnyID
GO
