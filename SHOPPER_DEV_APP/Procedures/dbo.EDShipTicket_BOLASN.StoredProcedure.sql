USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_BOLASN]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipTicket_BOLASN] @BOLNbr varchar(20) As
Select A.*,C.ConvMeth, C.Trans From EDShipTicket A Inner Join SOShipHeader B On A.CpnyId = B.CpnyId And
A.ShipperId = B.ShipperId Inner Join EDOutbound C On B.CustId = C.CustId Where A.BOLNbr = @BOLNbr
And C.Trans In ('856','857')
GO
