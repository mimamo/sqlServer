USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_Max_LineID]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_INTran_Max_LineID] @parm1 varchar( 10 ) AS
	SELECT MAX(LineID)
	FROM INTran
	WHERE BatNbr = @parm1
GO
