USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConDiscount_Cancelled]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDiscount_Cancelled]
		@parm1 varchar( 10 )
AS
	SELECT * FROM smConDiscount
	WHERE

		smConDiscount.ContractID = @parm1

	Order By
		smConDiscount.ContractID,
		smConDiscount.AccrueDate,
		smConDiscount.BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
