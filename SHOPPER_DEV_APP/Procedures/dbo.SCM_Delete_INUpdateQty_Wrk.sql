USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Delete_INUpdateQty_Wrk]    Script Date: 12/16/2015 15:55:32 ******/
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
