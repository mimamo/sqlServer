USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_all]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOHeader_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM EDSOHeader
	WHERE CpnyId LIKE @parm1
	   AND OrdNbr LIKE @parm2
	ORDER BY CpnyId,
	   OrdNbr
GO
