USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_LimitInfo]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_LimitInfo]
		@parm1	varchar(10)
AS
	SELECT
	        ContractID, ContractType, StartDate, ExpireDate, TotalAmt, BranchId,
	        Salesperson, PrimaryTech, SecondTech, Priority
	FROM
		smContract (NOLOCK)
	WHERE
		ContractID = @parm1
GO
