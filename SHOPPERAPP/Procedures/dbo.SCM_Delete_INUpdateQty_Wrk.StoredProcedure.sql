USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Delete_INUpdateQty_Wrk]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[SCM_Delete_INUpdateQty_Wrk]
	@ComputerName	VARCHAR (21)
AS
	IF @ComputerName = '%'
		DELETE FROM INUpdateQty_Wrk WHERE ComputerName = @ComputerName	/* Computer Name */
	ELSE
		DELETE FROM INUpdateQty_Wrk WHERE ComputerName LIKE @ComputerName
GO
