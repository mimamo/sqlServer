USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_all1]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_all1]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM SOHeader
	WHERE CpnyID LIKE @parm1
	   AND OrdNbr LIKE @parm2
	ORDER BY CpnyID,
	   OrdNbr DESC
GO
