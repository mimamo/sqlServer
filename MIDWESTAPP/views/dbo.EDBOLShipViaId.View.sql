USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[EDBOLShipViaId]    Script Date: 12/21/2015 15:55:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[EDBOLShipViaId] As
Select Distinct A.BOLNbr, B.CpnyId, A.ViaCode 
From EDShipment A Inner Join EDShipTicket B On A.BOLNbr = B.BOLNbr
GO
