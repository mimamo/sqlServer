USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConDiscount_Status_Contract]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDiscount_Status_Contract]
	@parm1 varchar( 1 ),
	@parm2 varchar( 10 ),
	@parm3 smalldatetime
AS
	SELECT *
	FROM smConDiscount
	WHERE Status LIKE @parm1
	   AND ContractID LIKE @parm2
	   AND BillDate <= @parm3
	ORDER BY Status,
	   ContractID,
	   BillDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
