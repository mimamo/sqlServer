USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAlloc_CpnyID_SOON_SOL_NoLike]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POAlloc_CpnyID_SOON_SOL_NoLike]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 5 )
AS
	SELECT *
	FROM POAlloc
	WHERE CpnyID = @parm1
	   AND SOOrdNbr = @parm2
	   AND SOLineRef = @parm3
	   AND SOSchedRef = @parm4
	ORDER BY CpnyID,
	   SOOrdNbr,
	   SOLineRef,
	   SOSchedRef
GO
