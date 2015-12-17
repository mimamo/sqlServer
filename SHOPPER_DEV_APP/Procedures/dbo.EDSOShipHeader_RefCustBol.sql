USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_RefCustBol]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipHeader_RefCustBol] @BolNbr varchar(20) AS
Select C.BOLRptFormat From SOShipHeader A, EDShipTicket B, customeredi C Where A.ShipperID = B.ShipperID And C.CustId = A.CustId And B.BolNbr = @BolNbr
GO
