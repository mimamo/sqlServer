USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SalesTax_PV]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SalesTax_PV]
	@TaxID varchar(10)
AS
	SELECT	TaxID,
		Descr,
		TaxType,
		TaxRate
	FROM SalesTax
	WHERE TaxID LIKE @TaxID
	ORDER BY TaxID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
