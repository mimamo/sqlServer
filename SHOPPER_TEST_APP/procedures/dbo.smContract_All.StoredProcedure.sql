USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_All]    Script Date: 12/21/2015 16:07:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContract_All]
	@parm1 varchar(10)
AS
	SELECT * FROM smContract
	WHERE 	ContractId LIKE @parm1
	ORDER BY
		ContractId
GO
