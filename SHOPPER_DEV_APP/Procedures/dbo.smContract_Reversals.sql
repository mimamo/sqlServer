USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Reversals]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContract_Reversals]
	@parm1 	varchar(10)
	,@parm2 varchar(1)
	,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smContract
	WHERE
		CpnyID = @Parm1
	AND
		Status = 'A'
	AND
		((totalAmort > 0 And @parm2 = 'A') Or (Exists (Select * from smContractRev Where smContract.ContractID = smContractRev.ContractID And Status = 'P' and @parm2 = 'R' )))
	AND
		ContractId LIKE @parm3
	ORDER BY
		ContractId
GO
