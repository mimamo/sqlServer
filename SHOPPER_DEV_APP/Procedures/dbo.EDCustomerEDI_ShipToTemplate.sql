USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomerEDI_ShipToTemplate]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDCustomerEDI_ShipToTemplate] @CustId varchar(15)
As
	Select CheckShipToId, MultiDestMeth, OutbndTemplate, SepDestOrd, S4Future09, S4Future03
	From CustomerEDI
	Where CustId = @CustId
GO
