USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_Max_LineRef]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_INTran_Max_LineRef] @parm1 varchar( 10 ), @parm2 varchar ( 10 ) AS
	SELECT CAST(MAX(LineRef) As SmallInt)
	FROM INTran
	WHERE 	BatNbr = @parm1 And
		CpnyID = @parm2
GO
