USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[EDCustomerBOLNotes]    Script Date: 12/21/2015 14:10:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[EDCustomerBOLNotes] As
Select A.BOLNbr, D.BOLNoteId From EDShipment A Inner Join EDShipTicket B On A.BOLNbr =
B.BOLNbr Inner Join SOShipHeader C On B.cpnyId = C.CpnyId And B.ShipperId = C.ShipperId
Inner Join CustomerEDI D On C.CustId = D.CustId
GO
