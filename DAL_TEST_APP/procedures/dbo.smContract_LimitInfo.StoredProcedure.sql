USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_LimitInfo]    Script Date: 12/21/2015 13:57:15 ******/
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
