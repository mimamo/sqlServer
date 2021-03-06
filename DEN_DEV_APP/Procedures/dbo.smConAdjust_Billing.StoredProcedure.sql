USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConAdjust_Billing]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConAdjust_Billing]
	@parm1 varchar( 10 ),
	@parm2 smalldatetime
	AS
SELECT * FROM smConAdjust
	WHERE
		ContractID = @parm1 AND
		BillDate <= @parm2 AND
		Status = 'A'
	ORDER BY
		ContractID,
		BillDate,
		Batnbr,
		LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
