USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_All]    Script Date: 12/16/2015 15:55:34 ******/
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
