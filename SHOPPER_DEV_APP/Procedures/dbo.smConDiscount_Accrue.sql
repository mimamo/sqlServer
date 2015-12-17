USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDiscount_Accrue]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDiscount_Accrue]
AS
SELECT * FROM smConDiscount
	WHERE
		smConDiscount.AccrualProcess = 0

	ORDER BY
		smConDiscount.ContractID,
		smConDiscount.AccrueDate,
		smConDiscount.BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
