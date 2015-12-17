USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContractRev_Cancelled]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContractRev_Cancelled]
			@parm1 varchar(10)
AS
	SELECT * FROM smContractRev
	WHERE
		smContractRev.ContractID = @parm1 AND
		smContractRev.RevFlag = 0 AND
		smContractRev.Status = 'O'

	Order By
		smContractRev.ContractID,
		smContractRev.RevDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
