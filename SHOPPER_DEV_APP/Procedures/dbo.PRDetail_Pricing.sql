USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDetail_Pricing]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- DE 226977 Added new proc called by PR Data entry screens.
CREATE PROC [dbo].[PRDetail_Pricing]
	@szServCallID VARCHAR(10),
	@szCustID VARCHAR(15),
	@szShiptoID VARCHAR(10),
	@szInvtID VARCHAR(30),
	@UnitCost float As Declare @UnitPrice float

EXECUTE smTM_Detail_Pricing @szServCallID,
	@szCustID,
	@szShiptoID,
	@szInvtID,
	@UnitCost,
	@UnitPrice OUTPUT

SELECT @UnitPrice
GO
